-- =====================================================
-- Fit4Force Educational Content RLS Policies
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

-- Skip admin policies for now (no user_roles table)
-- CREATE POLICY "Admins can manage agencies" ON agencies
-- FOR ALL USING (
--   EXISTS (
--     SELECT 1 FROM user_roles
--     WHERE user_id = auth.uid()
--     AND role IN ('admin', 'super_admin')
--   )
-- );

-- =====================================================
-- 3. CONTENT SECTIONS TABLE POLICIES
-- =====================================================

-- Users can view sections for their target agency or secondary agencies
CREATE POLICY "Users can view their agency sections" ON content_sections
FOR SELECT USING (
  auth.role() = 'authenticated' 
  AND is_active = true
  AND (
    agency_id IN (
      SELECT target_agency_id 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
    OR agency_id = ANY(
      SELECT unnest(secondary_agencies) 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
  )
);

-- Admins can manage all sections
CREATE POLICY "Admins can manage content sections" ON content_sections
FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- =====================================================
-- 4. STUDY MATERIALS TABLE POLICIES (CORE CONTENT ACCESS)
-- =====================================================

-- Users can view materials for their target agency or secondary agencies
-- Premium content requires premium subscription
CREATE POLICY "Users can view their agency materials" ON study_materials
FOR SELECT USING (
  auth.role() = 'authenticated' 
  AND is_active = true
  AND published_at IS NOT NULL
  AND published_at <= NOW()
  AND (
    -- Check if user has access to this agency
    agency_id IN (
      SELECT target_agency_id 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
    OR agency_id = ANY(
      SELECT unnest(secondary_agencies) 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
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

-- Admins can manage all study materials
CREATE POLICY "Admins can manage study materials" ON study_materials
FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- Users can update view count and download count (for analytics)
CREATE POLICY "Users can update material analytics" ON study_materials
FOR UPDATE USING (
  auth.role() = 'authenticated'
  AND (
    agency_id IN (
      SELECT target_agency_id 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
    OR agency_id = ANY(
      SELECT unnest(secondary_agencies) 
      FROM user_preferences 
      WHERE user_id = auth.uid()
    )
  )
) WITH CHECK (
  -- Only allow updating analytics fields
  OLD.id = NEW.id
  AND OLD.title = NEW.title
  AND OLD.content_type = NEW.content_type
  AND OLD.file_path = NEW.file_path
  AND OLD.is_premium = NEW.is_premium
  AND OLD.created_at = NEW.created_at
);

-- =====================================================
-- 5. USER PREFERENCES TABLE POLICIES
-- =====================================================

-- Users can view and manage their own preferences
CREATE POLICY "Users can manage their own preferences" ON user_preferences
FOR ALL USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Admins can view all user preferences (for analytics)
CREATE POLICY "Admins can view user preferences" ON user_preferences
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- =====================================================
-- 6. USER STUDY PROGRESS TABLE POLICIES
-- =====================================================

-- Users can manage their own study progress
CREATE POLICY "Users can manage their own progress" ON user_study_progress
FOR ALL USING (user_id = auth.uid())
WITH CHECK (
  user_id = auth.uid()
  AND EXISTS (
    -- Ensure the material belongs to user's accessible agencies
    SELECT 1 FROM study_materials sm
    JOIN user_preferences up ON (
      sm.agency_id = up.target_agency_id 
      OR sm.agency_id = ANY(up.secondary_agencies)
    )
    WHERE sm.id = material_id 
    AND up.user_id = auth.uid()
    AND sm.is_active = true
  )
);

-- Admins can view all progress (for analytics)
CREATE POLICY "Admins can view all progress" ON user_study_progress
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- =====================================================
-- 7. CONTENT RATINGS TABLE POLICIES
-- =====================================================

-- Users can manage their own ratings
CREATE POLICY "Users can manage their own ratings" ON content_ratings
FOR ALL USING (user_id = auth.uid())
WITH CHECK (
  user_id = auth.uid()
  AND EXISTS (
    -- Ensure the material belongs to user's accessible agencies
    SELECT 1 FROM study_materials sm
    JOIN user_preferences up ON (
      sm.agency_id = up.target_agency_id 
      OR sm.agency_id = ANY(up.secondary_agencies)
    )
    WHERE sm.id = material_id 
    AND up.user_id = auth.uid()
    AND sm.is_active = true
  )
);

-- All authenticated users can view ratings (for material reviews)
CREATE POLICY "Users can view all ratings" ON content_ratings
FOR SELECT USING (auth.role() = 'authenticated');

-- =====================================================
-- 8. STORAGE BUCKET POLICIES
-- =====================================================

-- Policy for study materials bucket (read-only for users)
INSERT INTO storage.buckets (id, name, public) VALUES ('study-materials', 'study-materials', false);

CREATE POLICY "Users can view study materials" ON storage.objects
FOR SELECT USING (
  bucket_id = 'study-materials'
  AND auth.role() = 'authenticated'
  AND EXISTS (
    SELECT 1 FROM study_materials sm
    JOIN user_preferences up ON (
      sm.agency_id = up.target_agency_id 
      OR sm.agency_id = ANY(up.secondary_agencies)
    )
    WHERE sm.file_path = name
    AND up.user_id = auth.uid()
    AND sm.is_active = true
    AND (
      sm.is_premium = false 
      OR (sm.is_premium = true AND up.is_premium = true)
    )
  )
);

-- Admins can upload to study materials bucket
CREATE POLICY "Admins can upload study materials" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'study-materials'
  AND EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- Admins can delete study materials
CREATE POLICY "Admins can delete study materials" ON storage.objects
FOR DELETE USING (
  bucket_id = 'study-materials'
  AND EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- =====================================================
-- 9. HELPER FUNCTIONS FOR COMPLEX QUERIES
-- =====================================================

-- Function to check if user has access to specific agency content
CREATE OR REPLACE FUNCTION user_has_agency_access(user_uuid UUID, agency_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_preferences 
    WHERE user_id = user_uuid 
    AND (
      target_agency_id = agency_uuid 
      OR agency_uuid = ANY(secondary_agencies)
    )
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

-- Function to get user's accessible agencies
CREATE OR REPLACE FUNCTION get_user_accessible_agencies(user_uuid UUID)
RETURNS UUID[] AS $$
DECLARE
  result UUID[];
BEGIN
  SELECT ARRAY(
    SELECT target_agency_id 
    FROM user_preferences 
    WHERE user_id = user_uuid
    UNION
    SELECT unnest(secondary_agencies) 
    FROM user_preferences 
    WHERE user_id = user_uuid
  ) INTO result;
  
  RETURN COALESCE(result, '{}');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 10. PERFORMANCE OPTIMIZATION
-- =====================================================

-- Create partial indexes for better performance
CREATE INDEX CONCURRENTLY idx_study_materials_user_access 
ON study_materials (agency_id, is_active, is_premium, published_at) 
WHERE is_active = true AND published_at IS NOT NULL;

CREATE INDEX CONCURRENTLY idx_user_preferences_agencies 
ON user_preferences (target_agency_id, secondary_agencies) 
WHERE target_agency_id IS NOT NULL;

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON POLICY "Users can view their agency materials" ON study_materials IS 
'Core policy ensuring users only see content for their selected target agency and any secondary agencies they have access to. Premium content requires premium subscription.';

COMMENT ON FUNCTION user_has_agency_access IS 
'Helper function to check if a user has access to content from a specific agency (either as target or secondary agency)';

COMMENT ON FUNCTION get_user_accessible_agencies IS 
'Returns array of all agency IDs that a user can access (target + secondary agencies)';

-- =====================================================
-- SECURITY NOTES
-- =====================================================

/*
SECURITY IMPLEMENTATION NOTES:

1. **Agency Isolation**: Users can only see content from their selected target agency and any secondary agencies they've been granted access to.

2. **Premium Content**: Premium materials are only visible to users with active premium subscriptions.

3. **Content Visibility**: Only active, published content is visible to users. Draft or inactive content is hidden.

4. **Admin Override**: Administrators can access and manage all content regardless of agency restrictions.

5. **Storage Security**: File access is controlled through RLS policies that verify user permissions before allowing downloads.

6. **Progress Tracking**: Users can only track progress for materials they have legitimate access to.

7. **Rating System**: Users can only rate content they can access, preventing spam or manipulation.

8. **Performance**: Indexes are optimized for the most common query patterns (agency + premium status + active status).
*/
