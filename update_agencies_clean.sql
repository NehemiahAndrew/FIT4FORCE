-- =====================================================
-- UPDATE ALL AGENCIES TO HAVE 8 COMPREHENSIVE SECTIONS
-- CLEAN VERSION WITHOUT ANY SEQUENCE OPERATIONS
-- =====================================================

-- First, clear existing content sections to avoid duplicates
DELETE FROM content_sections WHERE agency_id IN (
  SELECT id FROM agencies WHERE is_active = true
);

-- Standard 8 sections for ALL agencies using a single insert with CROSS JOIN
INSERT INTO content_sections (agency_id, name, description, icon, display_order)
SELECT 
  a.id as agency_id,
  s.section_name,
  CASE 
    WHEN a.code = 'army' THEN 'Military ' || s.section_desc
    WHEN a.code = 'navy' THEN 'Naval ' || s.section_desc  
    WHEN a.code = 'airforce' THEN 'Aviation ' || s.section_desc
    WHEN a.code = 'nda' THEN 'Academic ' || s.section_desc
    WHEN a.code = 'dssc' THEN 'Officer ' || s.section_desc
    WHEN a.code = 'polac' THEN 'Police ' || s.section_desc
    WHEN a.code = 'fire' THEN 'Fire service ' || s.section_desc
    WHEN a.code = 'nscdc' THEN 'Civil defense ' || s.section_desc
    WHEN a.code = 'frsc' THEN 'Road safety ' || s.section_desc
    WHEN a.code = 'immigration' THEN 'Immigration ' || s.section_desc
    WHEN a.code = 'customs' THEN 'Customs ' || s.section_desc
    WHEN a.code = 'dss' THEN 'Intelligence ' || s.section_desc
    ELSE s.section_desc
  END as description,
  s.section_icon,
  s.section_order
FROM agencies a
CROSS JOIN (
  VALUES 
    ('General Knowledge', 'knowledge and current affairs', 'lightbulb', 1),
    ('Aptitude Test', 'aptitude and reasoning tests', 'psychology', 2),
    ('Training Insight', 'training and preparation insights', 'fitness_center', 3),
    ('Interview Prep', 'interview preparation materials', 'chat', 4),
    ('Ranks & Structure', 'ranks and organizational structure', 'military_tech', 5),
    ('Physical Fitness', 'physical fitness requirements and training', 'directions_run', 6),
    ('Technical Knowledge', 'technical and specialized knowledge', 'engineering', 7),
    ('Career Guide', 'career guidance and opportunities', 'work', 8)
) AS s(section_name, section_desc, section_icon, section_order)
WHERE a.is_active = true;

-- Verify the update - this should show 8 sections for each agency
SELECT 
  a.name as agency_name,
  COUNT(cs.id) as section_count,
  string_agg(cs.name, ', ' ORDER BY cs.display_order) as sections
FROM agencies a
LEFT JOIN content_sections cs ON a.id = cs.agency_id
WHERE a.is_active = true
GROUP BY a.id, a.name
ORDER BY a.name;
