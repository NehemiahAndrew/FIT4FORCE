-- =====================================================
-- TEST SCRIPT FOR COMPREHENSIVE STUDY MATERIALS
-- =====================================================
-- This script tests the implementation of study materials
-- and verifies agency-specific content filtering

-- Test 1: Verify all agencies have study materials
SELECT 
  a.name as agency_name,
  a.code as agency_code,
  COUNT(sm.id) as total_materials,
  COUNT(CASE WHEN sm.is_premium = false THEN 1 END) as free_materials,
  COUNT(CASE WHEN sm.is_premium = true THEN 1 END) as premium_materials
FROM agencies a
LEFT JOIN study_materials sm ON a.id = sm.agency_id
GROUP BY a.id, a.name, a.code
ORDER BY a.name;

-- Test 2: Verify content sections for each agency
SELECT 
  a.name as agency_name,
  cs.name as section_name,
  COUNT(sm.id) as materials_count
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
LEFT JOIN study_materials sm ON cs.id = sm.section_id
GROUP BY a.id, a.name, cs.id, cs.name
ORDER BY a.name, cs.name;

-- Test 3: Verify content types distribution
SELECT 
  content_type,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study_materials), 2) as percentage
FROM study_materials
GROUP BY content_type
ORDER BY count DESC;

-- Test 4: Verify difficulty levels distribution
SELECT 
  difficulty_level,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study_materials), 2) as percentage
FROM study_materials
WHERE difficulty_level IS NOT NULL
GROUP BY difficulty_level
ORDER BY count DESC;

-- Test 5: Verify premium vs free content
SELECT 
  is_premium,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM study_materials), 2) as percentage
FROM study_materials
GROUP BY is_premium;

-- Test 6: Sample materials for Nigerian Army
SELECT 
  sm.title,
  sm.description,
  sm.content_type,
  sm.difficulty_level,
  sm.is_premium,
  cs.name as section_name
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
JOIN content_sections cs ON sm.section_id = cs.id
WHERE a.code = 'army'
ORDER BY cs.name, sm.title
LIMIT 10;

-- Test 7: Sample materials for Nigerian Navy
SELECT 
  sm.title,
  sm.description,
  sm.content_type,
  sm.difficulty_level,
  sm.is_premium,
  cs.name as section_name
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
JOIN content_sections cs ON sm.section_id = cs.id
WHERE a.code = 'navy'
ORDER BY cs.name, sm.title
LIMIT 10;

-- Test 8: Verify quiz materials have proper quiz_data
SELECT 
  sm.title,
  sm.content_type,
  CASE 
    WHEN sm.quiz_data IS NOT NULL THEN 'Has Quiz Data'
    ELSE 'Missing Quiz Data'
  END as quiz_status
FROM study_materials sm
WHERE sm.content_type = 'quiz'
ORDER BY sm.title;

-- Test 9: Verify file paths are properly structured
SELECT 
  a.code as agency_code,
  sm.content_type,
  sm.file_path,
  CASE 
    WHEN sm.file_path LIKE a.code || '/%' THEN 'Correct Path Structure'
    ELSE 'Incorrect Path Structure'
  END as path_status
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
WHERE sm.file_path IS NOT NULL
ORDER BY a.code, sm.content_type;

-- Test 10: Verify tags are properly assigned
SELECT 
  a.code as agency_code,
  sm.title,
  array_length(sm.tags, 1) as tag_count,
  sm.tags
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
WHERE sm.tags IS NOT NULL AND array_length(sm.tags, 1) > 0
ORDER BY a.code, tag_count DESC
LIMIT 15;

-- Summary Report
SELECT 
  'COMPREHENSIVE STUDY MATERIALS IMPLEMENTATION TEST RESULTS' as report_title,
  (SELECT COUNT(*) FROM agencies) as total_agencies,
  (SELECT COUNT(*) FROM content_sections) as total_sections,
  (SELECT COUNT(*) FROM study_materials) as total_materials,
  (SELECT COUNT(*) FROM study_materials WHERE content_type = 'pdf') as pdf_materials,
  (SELECT COUNT(*) FROM study_materials WHERE content_type = 'video') as video_materials,
  (SELECT COUNT(*) FROM study_materials WHERE content_type = 'quiz') as quiz_materials,
  (SELECT COUNT(*) FROM study_materials WHERE is_premium = true) as premium_materials,
  (SELECT COUNT(*) FROM study_materials WHERE is_premium = false) as free_materials;
