-- Fit4Force Database Setup - Part 3: Row Level Security Policies
-- Run this AFTER Parts 1 and 2

-- Enable Row Level Security on all tables
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
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Helper functions
CREATE OR REPLACE FUNCTION is_admin(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = user_id AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_premium_user(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = user_id 
        AND is_premium = true 
        AND (premium_expires_at IS NULL OR premium_expires_at > NOW())
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- USERS TABLE POLICIES
CREATE POLICY "Users can view public profiles" ON public.users
    FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- WORKOUTS TABLE POLICIES
CREATE POLICY "Everyone can view free workouts" ON public.workouts
    FOR SELECT USING (is_premium = false);

CREATE POLICY "Premium users can view all workouts" ON public.workouts
    FOR SELECT USING (
        is_premium = true AND is_premium_user(auth.uid())
    );

CREATE POLICY "Admins can manage workouts" ON public.workouts
    FOR ALL USING (is_admin(auth.uid()));

-- EXERCISES TABLE POLICIES
CREATE POLICY "Everyone can view exercises" ON public.exercises
    FOR SELECT USING (true);

CREATE POLICY "Admins can manage exercises" ON public.exercises
    FOR ALL USING (is_admin(auth.uid()));

-- USER_WORKOUTS TABLE POLICIES
CREATE POLICY "Users can view own workout sessions" ON public.user_workouts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout sessions" ON public.user_workouts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout sessions" ON public.user_workouts
    FOR UPDATE USING (auth.uid() = user_id);

-- PROGRESS TABLE POLICIES
CREATE POLICY "Users can view own progress" ON public.progress
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON public.progress
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON public.progress
    FOR UPDATE USING (auth.uid() = user_id);

-- POSTS TABLE POLICIES
CREATE POLICY "Everyone can view posts" ON public.posts
    FOR SELECT USING (is_deleted = false);

CREATE POLICY "Authenticated users can create posts" ON public.posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own posts" ON public.posts
    FOR UPDATE USING (auth.uid() = user_id);

-- COMMENTS TABLE POLICIES
CREATE POLICY "Everyone can view comments" ON public.comments
    FOR SELECT USING (is_deleted = false);

CREATE POLICY "Authenticated users can create comments" ON public.comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments" ON public.comments
    FOR UPDATE USING (auth.uid() = user_id);

-- LIKES TABLE POLICIES
CREATE POLICY "Users can view likes" ON public.likes
    FOR SELECT USING (true);

CREATE POLICY "Users can create own likes" ON public.likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own likes" ON public.likes
    FOR DELETE USING (auth.uid() = user_id);

-- SUBSCRIPTIONS TABLE POLICIES
CREATE POLICY "Users can view own subscriptions" ON public.subscriptions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "System can manage subscriptions" ON public.subscriptions
    FOR ALL USING (true);

-- NOTIFICATIONS TABLE POLICIES
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "System can create notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Trigger functions for automatic user profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, full_name, email)
    VALUES (
        NEW.id, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
        NEW.email
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile when auth user is created
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to handle engagement counters
CREATE OR REPLACE FUNCTION public.handle_like_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.post_id IS NOT NULL THEN
            UPDATE public.posts 
            SET likes_count = likes_count + 1 
            WHERE id = NEW.post_id;
        ELSIF NEW.comment_id IS NOT NULL THEN
            UPDATE public.comments 
            SET likes_count = likes_count + 1 
            WHERE id = NEW.comment_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.post_id IS NOT NULL THEN
            UPDATE public.posts 
            SET likes_count = likes_count - 1 
            WHERE id = OLD.post_id;
        ELSIF OLD.comment_id IS NOT NULL THEN
            UPDATE public.comments 
            SET likes_count = likes_count - 1 
            WHERE id = OLD.comment_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_like_change
    AFTER INSERT OR DELETE ON public.likes
    FOR EACH ROW EXECUTE FUNCTION public.handle_like_change();

-- Function to handle comment count
CREATE OR REPLACE FUNCTION public.handle_comment_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.posts 
        SET comments_count = comments_count + 1 
        WHERE id = NEW.post_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.posts 
        SET comments_count = comments_count - 1 
        WHERE id = OLD.post_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_comment_change
    AFTER INSERT OR DELETE ON public.comments
    FOR EACH ROW EXECUTE FUNCTION public.handle_comment_change();

-- Insert some sample data for testing
INSERT INTO public.workouts (name, description, category, difficulty_level, duration_minutes, is_premium) VALUES
('Basic Push-ups', 'Fundamental upper body exercise', 'Strength Building', 'Beginner', 15, false),
('Military Fitness Test Prep', 'Prepare for standard military fitness tests', 'Military Fitness', 'Intermediate', 45, true),
('HIIT Fat Burner', 'High intensity interval training for fat loss', 'Fat Loss/HIIT', 'Advanced', 30, false),
('Core Strength Builder', 'Build strong abdominal muscles', 'Core & Abs', 'Beginner', 20, false),
('Flexibility Flow', 'Improve flexibility and mobility', 'Flexibility & Mobility', 'Beginner', 25, false);

INSERT INTO public.exercises (name, description, muscle_groups, difficulty_level) VALUES
('Push-ups', 'Classic upper body exercise', ARRAY['chest', 'shoulders', 'triceps'], 'Beginner'),
('Squats', 'Lower body strength exercise', ARRAY['quadriceps', 'glutes', 'hamstrings'], 'Beginner'),
('Plank', 'Core stability exercise', ARRAY['core', 'shoulders'], 'Beginner'),
('Burpees', 'Full body cardio exercise', ARRAY['full body'], 'Intermediate'),
('Pull-ups', 'Upper body pulling exercise', ARRAY['back', 'biceps'], 'Advanced');

-- Success message
DO $$
BEGIN
    RAISE NOTICE '✅ Fit4Force database setup completed successfully!';
    RAISE NOTICE '📊 Tables created: users, workouts, exercises, posts, comments, likes, subscriptions, notifications';
    RAISE NOTICE '🔒 Row Level Security policies applied';
    RAISE NOTICE '🔄 Triggers and functions created';
    RAISE NOTICE '📝 Sample data inserted';
    RAISE NOTICE '🚀 Ready for Fit4Force app integration!';
END $$;
