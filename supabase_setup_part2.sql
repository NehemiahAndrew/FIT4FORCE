-- Fit4Force Database Setup - Part 2: Additional Tables and Indexes
-- Run this AFTER Part 1

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

-- Badges system
CREATE TABLE public.badges (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    icon_url TEXT,
    category TEXT NOT NULL, -- 'fitness', 'study', 'community', 'achievement'

    -- Requirements
    requirements JSONB NOT NULL, -- Conditions to earn the badge
    points INTEGER DEFAULT 0,

    -- Metadata
    is_active BOOLEAN DEFAULT TRUE,
    rarity TEXT DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary'))
);

-- User badges
CREATE TABLE public.user_badges (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    badge_id UUID REFERENCES public.badges(id) ON DELETE CASCADE,

    earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(user_id, badge_id)
);

-- Quizzes
CREATE TABLE public.quizzes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    title TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL, -- Subject area
    target_agency TEXT NOT NULL,

    -- Settings
    time_limit_minutes INTEGER,
    total_questions INTEGER NOT NULL,
    passing_score INTEGER NOT NULL, -- Percentage

    -- Access
    is_premium BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,

    -- Metadata
    difficulty_level TEXT DEFAULT 'Beginner' CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced')),
    tags TEXT[]
);

-- Quiz questions
CREATE TABLE public.quiz_questions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    quiz_id UUID REFERENCES public.quizzes(id) ON DELETE CASCADE,

    question_text TEXT NOT NULL,
    question_type TEXT DEFAULT 'multiple_choice' CHECK (question_type IN ('multiple_choice', 'true_false', 'fill_blank')),

    -- Options (for multiple choice)
    options JSONB, -- Array of options
    correct_answer TEXT NOT NULL,
    explanation TEXT,

    -- Metadata
    points INTEGER DEFAULT 1,
    order_index INTEGER NOT NULL
);

-- User quiz attempts
CREATE TABLE public.user_quiz_attempts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    quiz_id UUID REFERENCES public.quizzes(id) ON DELETE CASCADE,

    -- Attempt data
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,

    -- Results
    score INTEGER, -- Percentage
    total_questions INTEGER,
    correct_answers INTEGER,
    time_taken_minutes INTEGER,

    -- Answers
    answers JSONB, -- User's answers

    -- Status
    is_completed BOOLEAN DEFAULT FALSE,
    passed BOOLEAN DEFAULT FALSE
);

-- Challenges
CREATE TABLE public.challenges (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL, -- 'fitness', 'study', 'community'

    -- Timeline
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,

    -- Requirements
    requirements JSONB NOT NULL, -- What needs to be accomplished

    -- Rewards
    reward_points INTEGER DEFAULT 0,
    reward_badge_id UUID REFERENCES public.badges(id) ON DELETE SET NULL,

    -- Settings
    max_participants INTEGER,
    is_premium BOOLEAN DEFAULT FALSE,
    status challenge_status DEFAULT 'upcoming',

    -- Creator
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL
);

-- User challenges
CREATE TABLE public.user_challenges (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,

    -- Progress
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    progress JSONB DEFAULT '{}', -- Progress tracking data

    -- Status
    is_completed BOOLEAN DEFAULT FALSE,
    final_score INTEGER,

    UNIQUE(user_id, challenge_id)
);

-- Create indexes for better performance
CREATE INDEX idx_users_target_agency ON public.users(target_agency);
CREATE INDEX idx_users_is_premium ON public.users(is_premium);
CREATE INDEX idx_users_last_active ON public.users(last_active_at);
CREATE INDEX idx_workouts_category ON public.workouts(category);
CREATE INDEX idx_workouts_is_premium ON public.workouts(is_premium);
CREATE INDEX idx_workouts_difficulty ON public.workouts(difficulty_level);
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
CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions(status);
CREATE INDEX idx_quiz_attempts_user_id ON public.user_quiz_attempts(user_id);
CREATE INDEX idx_quiz_attempts_quiz_id ON public.user_quiz_attempts(quiz_id);

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
CREATE TRIGGER update_quizzes_updated_at BEFORE UPDATE ON public.quizzes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_challenges_updated_at BEFORE UPDATE ON public.challenges FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS) on all tables
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
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_challenges ENABLE ROW LEVEL SECURITY;
