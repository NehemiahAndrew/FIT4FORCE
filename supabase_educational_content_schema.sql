-- =====================================================
-- Fit4Force Educational Content Database Schema
-- Agency-Specific Content Management System
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. AGENCIES TABLE
-- =====================================================
CREATE TABLE agencies (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  full_name TEXT NOT NULL,
  description TEXT,
  logo_url TEXT,
  color_scheme JSONB DEFAULT '{"primary": "#1E40AF", "secondary": "#3B82F6"}',
  is_active BOOLEAN DEFAULT TRUE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert agencies data
INSERT INTO agencies (code, name, full_name, description, display_order) VALUES
('army', 'Nigerian Army', 'Nigerian Army', 'Land-based military force of Nigeria', 1),
('navy', 'Nigerian Navy', 'Nigerian Navy', 'Naval force of Nigeria', 2),
('airforce', 'Nigerian Air Force', 'Nigerian Air Force', 'Air force of Nigeria', 3),
('nda', 'NDA', 'Nigerian Defence Academy', 'Premier military university in Nigeria', 4),
('dssc', 'DSSC/SSC', 'Direct Short Service Commission/Short Service Commission', 'Officer training program', 5),
('polac', 'POLAC', 'Police Academy', 'Nigeria Police Academy', 6),
('fire', 'Fire Service', 'Federal Fire Service', 'Fire prevention and emergency response', 7),
('nscdc', 'NSCDC', 'Nigeria Security and Civil Defence Corps', 'Civil defence and security', 8),
('customs', 'Customs Service', 'Nigeria Customs Service', 'Customs and border control', 9),
('immigration', 'Immigration', 'Nigeria Immigration Service', 'Immigration and border control', 10),
('frsc', 'FRSC', 'Federal Road Safety Corps', 'Road safety and traffic management', 11);

-- =====================================================
-- 2. CONTENT SECTIONS TABLE
-- =====================================================
CREATE TABLE content_sections (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  agency_id UUID REFERENCES agencies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT DEFAULT 'book',
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(agency_id, name)
);

-- Create indexes for performance
CREATE INDEX idx_content_sections_agency_id ON content_sections(agency_id);
CREATE INDEX idx_content_sections_active ON content_sections(is_active);

-- =====================================================
-- 3. STUDY MATERIALS TABLE (Main Content Table)
-- =====================================================
CREATE TABLE study_materials (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  agency_id UUID REFERENCES agencies(id) ON DELETE CASCADE,
  section_id UUID REFERENCES content_sections(id) ON DELETE CASCADE,
  
  -- Content Information
  title TEXT NOT NULL,
  description TEXT,
  content_type TEXT NOT NULL CHECK (content_type IN ('pdf', 'quiz', 'video', 'interactive_video', 'document', 'audio')),
  
  -- File Storage
  file_path TEXT, -- Path in Supabase storage
  file_url TEXT, -- Public or signed URL
  file_size BIGINT, -- File size in bytes
  mime_type TEXT,
  
  -- Quiz/Interactive Content
  quiz_data JSONB, -- For storing quiz questions and answers
  interactive_data JSONB, -- For interactive video data
  
  -- Content Metadata
  duration INTEGER, -- Duration in seconds for videos/audio
  difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
  tags TEXT[], -- Array of tags for search
  
  -- Access Control
  is_premium BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  
  -- Analytics
  view_count INTEGER DEFAULT 0,
  download_count INTEGER DEFAULT 0,
  average_rating DECIMAL(3,2) DEFAULT 0.0,
  total_ratings INTEGER DEFAULT 0,
  
  -- Timestamps
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Admin Info
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id)
);

-- Create comprehensive indexes for performance
CREATE INDEX idx_study_materials_agency_id ON study_materials(agency_id);
CREATE INDEX idx_study_materials_section_id ON study_materials(section_id);
CREATE INDEX idx_study_materials_content_type ON study_materials(content_type);
CREATE INDEX idx_study_materials_is_premium ON study_materials(is_premium);
CREATE INDEX idx_study_materials_is_active ON study_materials(is_active);
CREATE INDEX idx_study_materials_published_at ON study_materials(published_at);
CREATE INDEX idx_study_materials_agency_section ON study_materials(agency_id, section_id);
CREATE INDEX idx_study_materials_tags ON study_materials USING GIN(tags);

-- =====================================================
-- 4. USER PREFERENCES TABLE
-- =====================================================
CREATE TABLE user_preferences (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  target_agency_id UUID REFERENCES agencies(id),
  secondary_agencies UUID[] DEFAULT '{}', -- Array of agency IDs for additional access
  is_premium BOOLEAN DEFAULT FALSE,
  notification_preferences JSONB DEFAULT '{"email": true, "push": true, "sms": false}',
  study_preferences JSONB DEFAULT '{"difficulty": "intermediate", "content_types": ["pdf", "quiz", "video"]}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
CREATE INDEX idx_user_preferences_target_agency ON user_preferences(target_agency_id);

-- =====================================================
-- 5. USER PROGRESS TRACKING
-- =====================================================
CREATE TABLE user_study_progress (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  material_id UUID REFERENCES study_materials(id) ON DELETE CASCADE,
  
  -- Progress Data
  status TEXT CHECK (status IN ('not_started', 'in_progress', 'completed', 'bookmarked')) DEFAULT 'not_started',
  progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
  time_spent INTEGER DEFAULT 0, -- Time in seconds
  
  -- Quiz/Test Results
  quiz_score INTEGER,
  quiz_total INTEGER,
  quiz_attempts INTEGER DEFAULT 0,
  best_score INTEGER,
  
  -- Timestamps
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  last_accessed TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, material_id)
);

-- Create indexes for progress tracking
CREATE INDEX idx_user_study_progress_user_id ON user_study_progress(user_id);
CREATE INDEX idx_user_study_progress_material_id ON user_study_progress(material_id);
CREATE INDEX idx_user_study_progress_status ON user_study_progress(status);
CREATE INDEX idx_user_study_progress_last_accessed ON user_study_progress(last_accessed);

-- =====================================================
-- 6. CONTENT RATINGS TABLE
-- =====================================================
CREATE TABLE content_ratings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  material_id UUID REFERENCES study_materials(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  review TEXT,
  is_helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, material_id)
);

-- Create indexes
CREATE INDEX idx_content_ratings_material_id ON content_ratings(material_id);
CREATE INDEX idx_content_ratings_rating ON content_ratings(rating);

-- =====================================================
-- 7. TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to all tables
CREATE TRIGGER update_agencies_updated_at BEFORE UPDATE ON agencies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_content_sections_updated_at BEFORE UPDATE ON content_sections FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_study_materials_updated_at BEFORE UPDATE ON study_materials FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON user_preferences FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_study_progress_updated_at BEFORE UPDATE ON user_study_progress FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_content_ratings_updated_at BEFORE UPDATE ON content_ratings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 8. FUNCTIONS FOR CONTENT ANALYTICS
-- =====================================================

-- Function to update material ratings
CREATE OR REPLACE FUNCTION update_material_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE study_materials 
    SET 
        average_rating = (
            SELECT COALESCE(AVG(rating), 0) 
            FROM content_ratings 
            WHERE material_id = COALESCE(NEW.material_id, OLD.material_id)
        ),
        total_ratings = (
            SELECT COUNT(*) 
            FROM content_ratings 
            WHERE material_id = COALESCE(NEW.material_id, OLD.material_id)
        )
    WHERE id = COALESCE(NEW.material_id, OLD.material_id);
    
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Trigger to update ratings automatically
CREATE TRIGGER update_material_rating_trigger
    AFTER INSERT OR UPDATE OR DELETE ON content_ratings
    FOR EACH ROW EXECUTE FUNCTION update_material_rating();

-- =====================================================
-- 9. VIEWS FOR EASY QUERYING
-- =====================================================

-- View for agency content summary
CREATE VIEW agency_content_summary AS
SELECT 
    a.id as agency_id,
    a.name as agency_name,
    a.code as agency_code,
    COUNT(sm.id) as total_materials,
    COUNT(CASE WHEN sm.is_premium = false THEN 1 END) as free_materials,
    COUNT(CASE WHEN sm.is_premium = true THEN 1 END) as premium_materials,
    COUNT(CASE WHEN sm.content_type = 'pdf' THEN 1 END) as pdf_count,
    COUNT(CASE WHEN sm.content_type = 'quiz' THEN 1 END) as quiz_count,
    COUNT(CASE WHEN sm.content_type = 'video' THEN 1 END) as video_count,
    COUNT(CASE WHEN sm.content_type = 'interactive_video' THEN 1 END) as interactive_count
FROM agencies a
LEFT JOIN study_materials sm ON a.id = sm.agency_id AND sm.is_active = true
WHERE a.is_active = true
GROUP BY a.id, a.name, a.code
ORDER BY a.display_order;

-- View for user's accessible content
CREATE VIEW user_accessible_content AS
SELECT 
    sm.*,
    a.name as agency_name,
    a.code as agency_code,
    cs.name as section_name,
    up.is_premium as user_is_premium,
    CASE 
        WHEN sm.is_premium = false THEN true
        WHEN sm.is_premium = true AND up.is_premium = true THEN true
        ELSE false
    END as can_access
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
JOIN content_sections cs ON sm.section_id = cs.id
JOIN user_preferences up ON (
    up.target_agency_id = sm.agency_id 
    OR sm.agency_id = ANY(up.secondary_agencies)
)
WHERE sm.is_active = true 
AND a.is_active = true 
AND cs.is_active = true;

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE agencies IS 'Military and paramilitary agencies in Nigeria';
COMMENT ON TABLE content_sections IS 'Content categories within each agency (e.g., General Knowledge, Aptitude Test)';
COMMENT ON TABLE study_materials IS 'Main table storing all educational content (PDFs, quizzes, videos, etc.)';
COMMENT ON TABLE user_preferences IS 'User agency preferences and settings';
COMMENT ON TABLE user_study_progress IS 'Tracks user progress through study materials';
COMMENT ON TABLE content_ratings IS 'User ratings and reviews for study materials';

COMMENT ON COLUMN study_materials.quiz_data IS 'JSON structure: {"questions": [{"question": "text", "options": ["a", "b", "c", "d"], "correct": 0, "explanation": "text"}]}';
COMMENT ON COLUMN study_materials.interactive_data IS 'JSON structure for interactive video timestamps and questions';
COMMENT ON COLUMN user_preferences.secondary_agencies IS 'Additional agencies user can access (for cross-training)';
