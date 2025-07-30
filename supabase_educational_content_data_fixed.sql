-- =====================================================
-- Fit4Force Educational Content Sample Data (FIXED)
-- Agency-Specific Study Materials and Content
-- =====================================================

-- =====================================================
-- 1. INSERT AGENCIES DATA
-- =====================================================

INSERT INTO agencies (code, name, full_name, description, is_active) VALUES
('army', 'Nigerian Army', 'Nigerian Army', 'The Nigerian Army is the land force of the Nigerian Armed Forces and the largest among the armed forces.', true),
('navy', 'Nigerian Navy', 'Nigerian Navy', 'The Nigerian Navy is the naval branch of the Nigerian Armed Forces.', true),
('airforce', 'Nigerian Air Force', 'Nigerian Air Force', 'The Nigerian Air Force is the air branch of the Nigerian Armed Forces.', true),
('nda', 'NDA', 'Nigerian Defence Academy', 'The Nigerian Defence Academy is a military university that trains officer cadets.', true),
('dssc', 'DSSC/SSC', 'Direct Short Service Commission', 'Direct Short Service Commission for graduate officers.', true),
('polac', 'POLAC', 'Police Academy', 'Nigeria Police Academy for training police officers.', true),
('fire', 'Fire Service', 'Federal Fire Service', 'Federal Fire Service responsible for fire prevention and emergency response.', true),
('nscdc', 'NSCDC', 'Nigeria Security and Civil Defence Corps', 'Nigeria Security and Civil Defence Corps for internal security.', true),
('customs', 'Customs Service', 'Nigeria Customs Service', 'Nigeria Customs Service for border control and revenue collection.', true),
('immigration', 'Immigration', 'Nigeria Immigration Service', 'Nigeria Immigration Service for border control and immigration.', true),
('frsc', 'FRSC', 'Federal Road Safety Corps', 'Federal Road Safety Corps for road safety and traffic management.', true)
ON CONFLICT (code) DO UPDATE SET
  name = EXCLUDED.name,
  full_name = EXCLUDED.full_name,
  description = EXCLUDED.description,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

-- =====================================================
-- 2. INSERT CONTENT SECTIONS FOR EACH AGENCY
-- =====================================================

-- Nigerian Army Sections
INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  section_name,
  section_desc,
  section_order,
  true
FROM agencies a,
(VALUES 
  ('General Knowledge', 'General knowledge questions and materials for Nigerian Army recruitment', 1),
  ('Aptitude Test', 'Aptitude test preparation materials and practice questions', 2),
  ('Screening/Training', 'Physical screening and training preparation materials', 3),
  ('Ranks & Structure', 'Nigerian Army ranks, structure, and organizational information', 4),
  ('Interview Prep', 'Interview preparation materials and common questions', 5)
) AS sections(section_name, section_desc, section_order)
WHERE a.code = 'army'
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  display_order = EXCLUDED.display_order,
  updated_at = NOW();

-- Nigerian Navy Sections
INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  section_name,
  section_desc,
  section_order,
  true
FROM agencies a,
(VALUES 
  ('General Knowledge', 'General knowledge for Nigerian Navy recruitment', 1),
  ('Aptitude Test', 'Navy-specific aptitude test materials', 2),
  ('Training Insight', 'Naval training programs and requirements', 3),
  ('Interview Prep', 'Navy interview preparation and tips', 4),
  ('Physical Fitness', 'Navy physical fitness requirements and training', 5)
) AS sections(section_name, section_desc, section_order)
WHERE a.code = 'navy'
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  display_order = EXCLUDED.display_order,
  updated_at = NOW();

-- Nigerian Air Force Sections
INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  section_name,
  section_desc,
  section_order,
  true
FROM agencies a,
(VALUES 
  ('Aptitude Test', 'Air Force aptitude and technical tests', 1),
  ('Technical Knowledge', 'Aviation and technical knowledge base', 2),
  ('Training Insight', 'Air Force training programs overview', 3),
  ('Physical Screening', 'Physical and medical requirements', 4),
  ('Interview Simulation', 'Air Force interview preparation', 5)
) AS sections(section_name, section_desc, section_order)
WHERE a.code = 'airforce'
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  display_order = EXCLUDED.display_order,
  updated_at = NOW();

-- NDA Sections
INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  section_name,
  section_desc,
  section_order,
  true
FROM agencies a,
(VALUES 
  ('General Papers', 'Academic subjects for NDA entrance', 1),
  ('Full Practice Exam', 'Complete NDA practice examinations', 2),
  ('Campus Life', 'Life and culture at Nigerian Defence Academy', 3),
  ('Interview Board', 'NDA interview preparation and tips', 4),
  ('Experience Sharing', 'Experiences from current and former cadets', 5)
) AS sections(section_name, section_desc, section_order)
WHERE a.code = 'nda'
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  display_order = EXCLUDED.display_order,
  updated_at = NOW();

-- Add sections for remaining agencies (DSSC, POLAC, Fire Service, etc.)
INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  'General Knowledge',
  'General knowledge and preparation materials',
  1,
  true
FROM agencies a
WHERE a.code IN ('dssc', 'polac', 'fire', 'nscdc', 'customs', 'immigration', 'frsc')
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  updated_at = NOW();

INSERT INTO content_sections (agency_id, name, description, display_order, is_active) 
SELECT 
  a.id,
  'Aptitude Test',
  'Aptitude test preparation and practice',
  2,
  true
FROM agencies a
WHERE a.code IN ('dssc', 'polac', 'fire', 'nscdc', 'customs', 'immigration', 'frsc')
ON CONFLICT (agency_id, name) DO UPDATE SET
  description = EXCLUDED.description,
  updated_at = NOW();

-- =====================================================
-- 3. INSERT SAMPLE STUDY MATERIALS
-- =====================================================

-- Function to insert materials for an agency
DO $$
DECLARE
  agency_rec RECORD;
  section_rec RECORD;
  material_count INTEGER := 0;
BEGIN
  -- Loop through each agency
  FOR agency_rec IN SELECT id, code, name FROM agencies WHERE is_active = true LOOP
    -- Loop through each section for this agency
    FOR section_rec IN SELECT id, name FROM content_sections WHERE agency_id = agency_rec.id AND is_active = true LOOP
      
      -- Insert 3 materials per section
      FOR i IN 1..3 LOOP
        material_count := material_count + 1;
        
        INSERT INTO study_materials (
          agency_id,
          section_id,
          title,
          description,
          content_type,
          file_path,
          is_premium,
          duration,
          difficulty_level,
          tags,
          published_at,
          is_active
        ) VALUES (
          agency_rec.id,
          section_rec.id,
          agency_rec.name || ' ' || section_rec.name || ' - Material ' || i,
          'Comprehensive study material for ' || agency_rec.name || ' ' || section_rec.name || ' preparation. This material covers essential topics and provides practical examples.',
          CASE 
            WHEN i = 1 THEN 'document'
            WHEN i = 2 THEN 'quiz'
            ELSE 'video'
          END,
          LOWER(agency_rec.code) || '/' || LOWER(REPLACE(section_rec.name, ' ', '_')) || '/material_' || i || CASE 
            WHEN i = 1 THEN '.pdf'
            WHEN i = 2 THEN '.json'
            ELSE '.mp4'
          END,
          CASE WHEN i = 3 THEN true ELSE false END, -- Every 3rd material is premium
          CASE
            WHEN i = 1 THEN 900  -- 15 minutes in seconds
            WHEN i = 2 THEN 1800 -- 30 minutes in seconds
            ELSE 2700            -- 45 minutes in seconds
          END,
          CASE 
            WHEN i = 1 THEN 'beginner'
            WHEN i = 2 THEN 'intermediate'
            ELSE 'advanced'
          END,
          ARRAY[LOWER(agency_rec.code), LOWER(REPLACE(section_rec.name, ' ', '_')), 'preparation'],
          NOW() - INTERVAL '1 day',
          true
        );
      END LOOP;
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Inserted % study materials across all agencies', material_count;
END $$;

-- =====================================================
-- 4. ADD SAMPLE QUIZ DATA TO QUIZ MATERIALS
-- =====================================================

-- Add quiz data to one Army quiz material
UPDATE study_materials 
SET quiz_data = '{
  "questions": [
    {
      "question": "What is the motto of the Nigerian Army?",
      "options": ["Victory in Unity", "To Serve Nigeria", "Duty and Honor", "Strength and Courage"],
      "correct": 0,
      "explanation": "The Nigerian Army motto is Victory in Unity, emphasizing teamwork and national service."
    },
    {
      "question": "In which year was the Nigerian Army established?",
      "options": ["1960", "1963", "1956", "1958"],
      "correct": 0,
      "explanation": "The Nigerian Army was established in 1960, the same year Nigeria gained independence."
    }
  ],
  "duration": 1800,
  "passing_score": 70,
  "total_questions": 2
}'
WHERE content_type = 'quiz' 
AND agency_id = (SELECT id FROM agencies WHERE code = 'army')
AND id = (
  SELECT id FROM study_materials 
  WHERE content_type = 'quiz' 
  AND agency_id = (SELECT id FROM agencies WHERE code = 'army')
  ORDER BY created_at 
  LIMIT 1
);

-- =====================================================
-- 5. VERIFICATION AND SUMMARY
-- =====================================================

-- Display summary of inserted data
DO $$
DECLARE
  agency_count INTEGER;
  section_count INTEGER;
  material_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO agency_count FROM agencies WHERE is_active = true;
  SELECT COUNT(*) INTO section_count FROM content_sections WHERE is_active = true;
  SELECT COUNT(*) INTO material_count FROM study_materials WHERE is_active = true;
  
  RAISE NOTICE '=== DATA INSERTION SUMMARY ===';
  RAISE NOTICE 'Active Agencies: %', agency_count;
  RAISE NOTICE 'Content Sections: %', section_count;
  RAISE NOTICE 'Study Materials: %', material_count;
  RAISE NOTICE '';
  RAISE NOTICE '✅ Sample data insertion completed successfully!';
  RAISE NOTICE '✅ Agency-specific content structure is ready';
  RAISE NOTICE '✅ Premium and free content mix available';
  RAISE NOTICE '';
  RAISE NOTICE 'Next steps:';
  RAISE NOTICE '1. Test user registration with agency selection';
  RAISE NOTICE '2. Verify content filtering by agency';
  RAISE NOTICE '3. Upload actual study materials to Supabase Storage';
END $$;
