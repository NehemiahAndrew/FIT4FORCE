-- =====================================================
-- Fit4Force Educational Content RLS Policies (Simple & Working)
-- Agency-Specific Content Access Control
-- =====================================================

-- =====================================================
-- 1. ENABLE RLS ON ALL TABLES
-- =====================================================

ALTER TABLE agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_study_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_ratings ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 2. AGENCIES TABLE POLICIES
-- =====================================================

-- All authenticated users can view active agencies
CREATE POLICY "Users can view active agencies" ON agencies
FOR SELECT USING (
  auth.role() = 'authenticated' AND is_active = true
);

-- =====================================================
-- 3. CONTENT SECTIONS TABLE POLICIES
-- =====================================================

-- Users can view sections for their target agency
CREATE POLICY "Users can view their agency sections" ON content_sections
FOR SELECT USING (
  auth.role() = 'authenticated' 
  AND is_active = true
  AND agency_id IN (
    SELECT target_agency_id 
    FROM user_preferences 
    WHERE user_id = auth.uid()
  )
);

-- =====================================================
-- 4. STUDY MATERIALS TABLE POLICIES (CORE CONTENT ACCESS)
-- =====================================================

-- Users can view materials for their target agency
-- Premium content requires premium subscription
CREATE POLICY "Users can view their agency materials" ON study_materials
FOR SELECT USING (
  auth.role() = 'authenticated' 
  AND is_active = true
  AND published_at IS NOT NULL
  AND published_at <= NOW()
  AND agency_id IN (
    SELECT target_agency_id 
    FROM user_preferences 
    WHERE user_id = auth.uid()
  )
  AND (
    -- Check premium access
    is_premium = false 
    OR (
      is_premium = true 
      AND EXISTS (
        SELECT 1 FROM user_preferences 
        WHERE user_id = auth.uid() 
        AND is_premium = true
      )
    )
  )
);

-- =====================================================
-- 5. USER PREFERENCES TABLE POLICIES
-- =====================================================

-- Users can view and manage their own preferences
CREATE POLICY "Users can manage their own preferences" ON user_preferences
FOR ALL USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- =====================================================
-- 6. USER STUDY PROGRESS TABLE POLICIES
-- =====================================================

-- Users can manage their own study progress
CREATE POLICY "Users can manage their own progress" ON user_study_progress
FOR ALL USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- =====================================================
-- 7. CONTENT RATINGS TABLE POLICIES
-- =====================================================

-- Users can manage their own ratings
CREATE POLICY "Users can manage their own ratings" ON content_ratings
FOR ALL USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- All authenticated users can view ratings (for material reviews)
CREATE POLICY "Users can view all ratings" ON content_ratings
FOR SELECT USING (auth.role() = 'authenticated');

-- =====================================================
-- 8. STORAGE BUCKET SETUP
-- =====================================================

-- Create study materials bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public) 
VALUES ('study-materials', 'study-materials', false)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 9. HELPER FUNCTIONS
-- =====================================================

-- Function to check if user has access to specific agency content
CREATE OR REPLACE FUNCTION user_has_agency_access(user_uuid UUID, agency_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_preferences 
    WHERE user_id = user_uuid 
    AND target_agency_id = agency_uuid
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can access premium content
CREATE OR REPLACE FUNCTION user_has_premium_access(user_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_preferences 
    WHERE user_id = user_uuid 
    AND is_premium = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 10. PERFORMANCE INDEXES
-- =====================================================

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_study_materials_agency_active 
ON study_materials (agency_id, is_active, published_at) 
WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_user_preferences_target_agency 
ON user_preferences (user_id, target_agency_id);

CREATE INDEX IF NOT EXISTS idx_user_study_progress_user 
ON user_study_progress (user_id, material_id);

CREATE INDEX IF NOT EXISTS idx_content_ratings_user 
ON content_ratings (user_id, material_id);

-- =====================================================
-- 11. VERIFICATION
-- =====================================================

-- Verify setup
DO $$
DECLARE
  rls_count INTEGER;
  policy_count INTEGER;
BEGIN
  -- Check RLS enabled
  SELECT COUNT(*) INTO rls_count
  FROM pg_tables 
  WHERE schemaname = 'public' 
  AND tablename IN ('agencies', 'content_sections', 'study_materials', 'user_preferences', 'user_study_progress', 'content_ratings')
  AND rowsecurity = true;
  
  -- Check policies created
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies 
  WHERE tablename IN ('agencies', 'content_sections', 'study_materials', 'user_preferences', 'user_study_progress', 'content_ratings');
  
  RAISE NOTICE '=== RLS SETUP VERIFICATION ===';
  RAISE NOTICE 'Tables with RLS enabled: %', rls_count;
  RAISE NOTICE 'Security policies created: %', policy_count;
  
  IF rls_count >= 6 AND policy_count >= 6 THEN
    RAISE NOTICE '✅ SUCCESS: Agency-specific content access control is active!';
    RAISE NOTICE '✅ Users will only see content for their selected agency';
    RAISE NOTICE '✅ Premium content access is controlled';
  ELSE
    RAISE NOTICE '❌ WARNING: Setup may be incomplete';
  END IF;
  
  RAISE NOTICE '=== NEXT STEPS ===';
  RAISE NOTICE '1. Run the sample data script';
  RAISE NOTICE '2. Test user registration with agency selection';
  RAISE NOTICE '3. Verify content filtering works';
END $$;
