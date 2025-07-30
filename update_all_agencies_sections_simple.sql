-- =====================================================
-- SIMPLE UPDATE ALL AGENCIES TO HAVE 8 SECTIONS
-- =====================================================
-- This script ensures all agencies have the same 8 categories

-- First, clear existing content sections to avoid duplicates
DELETE FROM content_sections;

-- Create a function to insert sections for each agency
DO $$ 
DECLARE
    agency_record RECORD;
BEGIN
    FOR agency_record IN SELECT id, code FROM agencies WHERE is_active = true
    LOOP
        -- Insert 8 standard sections for each agency
        INSERT INTO content_sections (agency_id, name, description, icon, display_order, is_active) VALUES
        (agency_record.id, 'General Knowledge', 'General knowledge and current affairs', 'lightbulb', 1, true),
        (agency_record.id, 'Aptitude Test', 'Aptitude and reasoning tests', 'psychology', 2, true),
        (agency_record.id, 'Training Insight', 'Training and preparation insights', 'fitness_center', 3, true),
        (agency_record.id, 'Interview Prep', 'Interview preparation materials', 'chat', 4, true),
        (agency_record.id, 'Ranks & Structure', 'Ranks and organizational structure', 'military_tech', 5, true),
        (agency_record.id, 'Physical Fitness', 'Physical fitness requirements and training', 'directions_run', 6, true),
        (agency_record.id, 'Technical Knowledge', 'Technical and specialized knowledge', 'engineering', 7, true),
        (agency_record.id, 'Career Guide', 'Career guidance and opportunities', 'work', 8, true);
    END LOOP;
END $$;

-- Verify the update
SELECT 
  a.name as agency_name,
  COUNT(cs.id) as section_count,
  string_agg(cs.name, ', ' ORDER BY cs.display_order) as sections
FROM agencies a
LEFT JOIN content_sections cs ON a.id = cs.agency_id
WHERE a.is_active = true
GROUP BY a.id, a.name
ORDER BY a.name;
