-- Fit4Force Database Schema for Supabase
-- Run this in your Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create custom types
CREATE TYPE user_role AS ENUM ('user', 'admin', 'moderator');
CREATE TYPE subscription_status AS ENUM ('active', 'inactive', 'cancelled', 'expired');
CREATE TYPE post_type AS ENUM ('text', 'image', 'video', 'poll');
CREATE TYPE notification_type AS ENUM ('like', 'comment', 'follow', 'workout_reminder', 'system');
CREATE TYPE challenge_status AS ENUM ('upcoming', 'active', 'completed', 'cancelled');

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Profile information
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    profile_image_url TEXT,
    bio TEXT,

    -- Personal details
    age INTEGER CHECK (age >= 16 AND age <= 100),
    gender TEXT CHECK (gender IN ('Male', 'Female', 'Other')),
    height DECIMAL(5,2), -- in cm
    weight DECIMAL(5,2), -- in kg

    -- Military aspirant details
    target_agency TEXT NOT NULL,
    fitness_goal TEXT,
    experience_level TEXT DEFAULT 'Beginner' CHECK (experience_level IN ('Beginner', 'Intermediate', 'Advanced')),

    -- App preferences
    notification_preferences JSONB DEFAULT '{"push": true, "email": true, "workout_reminders": true}',
    privacy_settings JSONB DEFAULT '{"profile_visibility": "public", "workout_visibility": "friends"}',

    -- Subscription
    is_premium BOOLEAN DEFAULT FALSE,
    premium_expires_at TIMESTAMP WITH TIME ZONE,

    -- Activity tracking
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_workouts INTEGER DEFAULT 0,
    total_study_time INTEGER DEFAULT 0, -- in minutes
    streak_days INTEGER DEFAULT 0,

    -- System
    role user_role DEFAULT 'user',
    is_verified BOOLEAN DEFAULT FALSE,
    is_banned BOOLEAN DEFAULT FALSE
);

-- Workouts table
CREATE TABLE public.workouts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL, -- 'Fat Loss/HIIT', 'Strength Building', 'Military Fitness', 'Core & Abs', 'Flexibility & Mobility'
    difficulty_level TEXT DEFAULT 'Beginner' CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced')),
    duration_minutes INTEGER NOT NULL,
    calories_burned INTEGER,
    equipment_needed TEXT[],

    -- Media
    image_url TEXT,
    video_url TEXT,

    -- Metadata
    is_premium BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    tags TEXT[],

    -- Stats
    total_completions INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,

    -- Creator (for custom workouts)
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL
);

-- Exercises table
CREATE TABLE public.exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    name TEXT NOT NULL,
    description TEXT,
    instructions TEXT,
    muscle_groups TEXT[],
    equipment_needed TEXT[],

    -- Media
    image_url TEXT,
    video_url TEXT,
    gif_url TEXT,

    -- Metadata
    difficulty_level TEXT DEFAULT 'Beginner' CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced')),
    is_compound BOOLEAN DEFAULT FALSE,
    tags TEXT[]
);

-- Workout exercises junction table
CREATE TABLE public.workout_exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,

    order_index INTEGER NOT NULL,
    sets INTEGER,
    reps INTEGER,
    duration_seconds INTEGER,
    rest_seconds INTEGER,
    weight_kg DECIMAL(5,2),
    notes TEXT,

    UNIQUE(workout_id, exercise_id, order_index)
);

-- User workout sessions
CREATE TABLE public.user_workouts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE,

    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER,
    calories_burned INTEGER,

    -- Performance data
    exercises_completed JSONB, -- Array of exercise performance data
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),

    -- Status
    is_completed BOOLEAN DEFAULT FALSE
);

-- Progress tracking
CREATE TABLE public.progress (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Measurements
    weight_kg DECIMAL(5,2),
    body_fat_percentage DECIMAL(4,2),
    muscle_mass_kg DECIMAL(5,2),

    -- Fitness metrics
    max_pushups INTEGER,
    max_situps INTEGER,
    run_time_2km INTEGER, -- in seconds
    plank_time_seconds INTEGER,

    -- Photos
    progress_photos TEXT[], -- URLs to progress photos

    -- Notes
    notes TEXT
);

-- Community posts
CREATE TABLE public.posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,

    -- Content
    title TEXT,
    content TEXT NOT NULL,
    post_type post_type DEFAULT 'text',
    media_urls TEXT[],

    -- Categorization
    agency TEXT, -- Target agency for the post
    tags TEXT[],

    -- Engagement
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    shares_count INTEGER DEFAULT 0,

    -- Moderation
    is_pinned BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- Location (optional)
    location TEXT
);

-- Comments
CREATE TABLE public.comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE, -- For nested comments

    content TEXT NOT NULL,
    likes_count INTEGER DEFAULT 0,

    is_deleted BOOLEAN DEFAULT FALSE
);

-- Likes (for posts and comments)
CREATE TABLE public.likes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
    comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,

    CHECK (
        (post_id IS NOT NULL AND comment_id IS NULL) OR
        (post_id IS NULL AND comment_id IS NOT NULL)
    ),

    UNIQUE(user_id, post_id),
    UNIQUE(user_id, comment_id)
);

-- Subscriptions
CREATE TABLE public.subscriptions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,

    -- Subscription details
    plan_name TEXT NOT NULL DEFAULT 'Premium',
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'NGN',

    -- Dates
    start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,

    -- Payment
    payment_reference TEXT UNIQUE,
    payment_method TEXT,

    -- Status
    status subscription_status DEFAULT 'active',
    auto_renew BOOLEAN DEFAULT TRUE,

    -- Metadata
    metadata JSONB
);

-- Study groups
CREATE TABLE public.study_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    name TEXT NOT NULL,
    description TEXT,
    target_agency TEXT NOT NULL,

    -- Settings
    is_private BOOLEAN DEFAULT FALSE,
    max_members INTEGER DEFAULT 50,

    -- Creator
    created_by UUID REFERENCES public.users(id) ON DELETE CASCADE,

    -- Stats
    member_count INTEGER DEFAULT 1,

    -- Media
    image_url TEXT
);

-- Study group members
CREATE TABLE public.study_group_members (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    group_id UUID REFERENCES public.study_groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,

    role TEXT DEFAULT 'member' CHECK (role IN ('admin', 'moderator', 'member')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(group_id, user_id)
);

-- Notifications
CREATE TABLE public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,

    -- Content
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type notification_type NOT NULL,

    -- Related entities
    related_user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    related_post_id UUID REFERENCES public.posts(id) ON DELETE SET NULL,
    related_workout_id UUID REFERENCES public.workouts(id) ON DELETE SET NULL,

    -- Status
    is_read BOOLEAN DEFAULT FALSE,

    -- Metadata
    data JSONB
);

-- Create indexes for better performance
CREATE INDEX idx_users_target_agency ON public.users(target_agency);
CREATE INDEX idx_users_is_premium ON public.users(is_premium);
CREATE INDEX idx_workouts_category ON public.workouts(category);
CREATE INDEX idx_workouts_is_premium ON public.workouts(is_premium);
CREATE INDEX idx_posts_user_id ON public.posts(user_id);
CREATE INDEX idx_posts_agency ON public.posts(agency);
CREATE INDEX idx_posts_created_at ON public.posts(created_at DESC);
CREATE INDEX idx_comments_post_id ON public.comments(post_id);
CREATE INDEX idx_likes_user_id ON public.likes(user_id);
CREATE INDEX idx_likes_post_id ON public.likes(post_id);
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_user_workouts_user_id ON public.user_workouts(user_id);
CREATE INDEX idx_progress_user_id ON public.progress(user_id);

-- Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON public.workouts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_study_groups_updated_at BEFORE UPDATE ON public.study_groups FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
