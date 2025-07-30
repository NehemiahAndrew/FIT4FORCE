-- Row Level Security (RLS) Policies for Fit4Force
-- Run this AFTER creating the main schema

-- Helper function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = user_id AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to check if user is premium
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
-- Users can view all public profiles
CREATE POLICY "Users can view public profiles" ON public.users
    FOR SELECT USING (true);

-- Users can only update their own profile
CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile (during signup)
CREATE POLICY "Users can insert own profile" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- WORKOUTS TABLE POLICIES
-- Everyone can view non-premium workouts
CREATE POLICY "Everyone can view free workouts" ON public.workouts
    FOR SELECT USING (is_premium = false);

-- Premium users can view all workouts
CREATE POLICY "Premium users can view all workouts" ON public.workouts
    FOR SELECT USING (
        is_premium = true AND is_premium_user(auth.uid())
    );

-- Admins can manage all workouts
CREATE POLICY "Admins can manage workouts" ON public.workouts
    FOR ALL USING (is_admin(auth.uid()));

-- EXERCISES TABLE POLICIES
-- Everyone can view exercises
CREATE POLICY "Everyone can view exercises" ON public.exercises
    FOR SELECT USING (true);

-- Admins can manage exercises
CREATE POLICY "Admins can manage exercises" ON public.exercises
    FOR ALL USING (is_admin(auth.uid()));

-- WORKOUT_EXERCISES TABLE POLICIES
-- Everyone can view workout exercises
CREATE POLICY "Everyone can view workout exercises" ON public.workout_exercises
    FOR SELECT USING (true);

-- Admins can manage workout exercises
CREATE POLICY "Admins can manage workout exercises" ON public.workout_exercises
    FOR ALL USING (is_admin(auth.uid()));

-- USER_WORKOUTS TABLE POLICIES
-- Users can view their own workout sessions
CREATE POLICY "Users can view own workout sessions" ON public.user_workouts
    FOR SELECT USING (auth.uid() = user_id);

-- Users can insert their own workout sessions
CREATE POLICY "Users can insert own workout sessions" ON public.user_workouts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own workout sessions
CREATE POLICY "Users can update own workout sessions" ON public.user_workouts
    FOR UPDATE USING (auth.uid() = user_id);

-- PROGRESS TABLE POLICIES
-- Users can view their own progress
CREATE POLICY "Users can view own progress" ON public.progress
    FOR SELECT USING (auth.uid() = user_id);

-- Users can insert their own progress
CREATE POLICY "Users can insert own progress" ON public.progress
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own progress
CREATE POLICY "Users can update own progress" ON public.progress
    FOR UPDATE USING (auth.uid() = user_id);

-- POSTS TABLE POLICIES
-- Everyone can view non-deleted posts
CREATE POLICY "Everyone can view posts" ON public.posts
    FOR SELECT USING (is_deleted = false);

-- Authenticated users can create posts
CREATE POLICY "Authenticated users can create posts" ON public.posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own posts
CREATE POLICY "Users can update own posts" ON public.posts
    FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete their own posts (soft delete)
CREATE POLICY "Users can delete own posts" ON public.posts
    FOR UPDATE USING (auth.uid() = user_id);

-- Admins can manage all posts
CREATE POLICY "Admins can manage all posts" ON public.posts
    FOR ALL USING (is_admin(auth.uid()));

-- COMMENTS TABLE POLICIES
-- Everyone can view non-deleted comments
CREATE POLICY "Everyone can view comments" ON public.comments
    FOR SELECT USING (is_deleted = false);

-- Authenticated users can create comments
CREATE POLICY "Authenticated users can create comments" ON public.comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own comments
CREATE POLICY "Users can update own comments" ON public.comments
    FOR UPDATE USING (auth.uid() = user_id);

-- LIKES TABLE POLICIES
-- Users can view all likes
CREATE POLICY "Users can view likes" ON public.likes
    FOR SELECT USING (true);

-- Users can create their own likes
CREATE POLICY "Users can create own likes" ON public.likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can delete their own likes
CREATE POLICY "Users can delete own likes" ON public.likes
    FOR DELETE USING (auth.uid() = user_id);

-- SUBSCRIPTIONS TABLE POLICIES
-- Users can view their own subscriptions
CREATE POLICY "Users can view own subscriptions" ON public.subscriptions
    FOR SELECT USING (auth.uid() = user_id);

-- System can insert subscriptions (via service role)
CREATE POLICY "System can insert subscriptions" ON public.subscriptions
    FOR INSERT WITH CHECK (true);

-- System can update subscriptions (via service role)
CREATE POLICY "System can update subscriptions" ON public.subscriptions
    FOR UPDATE USING (true);

-- STUDY_GROUPS TABLE POLICIES
-- Everyone can view public study groups
CREATE POLICY "Everyone can view public study groups" ON public.study_groups
    FOR SELECT USING (is_private = false);

-- Group members can view private groups
CREATE POLICY "Members can view private study groups" ON public.study_groups
    FOR SELECT USING (
        is_private = true AND EXISTS (
            SELECT 1 FROM public.study_group_members 
            WHERE group_id = id AND user_id = auth.uid()
        )
    );

-- Authenticated users can create study groups
CREATE POLICY "Authenticated users can create study groups" ON public.study_groups
    FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Group creators can update their groups
CREATE POLICY "Creators can update study groups" ON public.study_groups
    FOR UPDATE USING (auth.uid() = created_by);

-- STUDY_GROUP_MEMBERS TABLE POLICIES
-- Group members can view group membership
CREATE POLICY "Members can view group membership" ON public.study_group_members
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.study_group_members sgm
            WHERE sgm.group_id = group_id AND sgm.user_id = auth.uid()
        )
    );

-- Users can join groups (insert)
CREATE POLICY "Users can join study groups" ON public.study_group_members
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can leave groups (delete)
CREATE POLICY "Users can leave study groups" ON public.study_group_members
    FOR DELETE USING (auth.uid() = user_id);

-- Group admins can manage membership
CREATE POLICY "Group admins can manage membership" ON public.study_group_members
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.study_group_members sgm
            WHERE sgm.group_id = group_id 
            AND sgm.user_id = auth.uid() 
            AND sgm.role IN ('admin', 'moderator')
        )
    );

-- NOTIFICATIONS TABLE POLICIES
-- Users can view their own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

-- System can create notifications
CREATE POLICY "System can create notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Create functions for real-time subscriptions
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, full_name, email)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile when auth user is created
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update user last_active_at
CREATE OR REPLACE FUNCTION public.update_user_last_active()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.users 
    SET last_active_at = NOW() 
    WHERE id = auth.uid();
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to increment post engagement counters
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

-- Triggers for engagement counters
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
