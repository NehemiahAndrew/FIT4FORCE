-- =====================================================
-- VERIFICATION SCRIPT FOR AGENCY SECTIONS UPDATE
-- =====================================================
-- Run this script after executing update_all_agencies_sections.sql
-- to verify that all agencies now have 8 categories

-- Check section count per agency
SELECT 
  a.name as agency_name,
  a.code as agency_code,
  COUNT(cs.id) as section_count,
  CASE 
    WHEN COUNT(cs.id) = 8 THEN '✅ CORRECT'
    ELSE '❌ MISSING SECTIONS'
  END as status
FROM agencies a
LEFT JOIN content_sections cs ON a.id = cs.agency_id AND cs.is_active = true
WHERE a.is_active = true
GROUP BY a.id, a.name, a.code
ORDER BY a.name;

-- List all sections for each agency
SELECT 
  a.name as agency_name,
  cs.name as section_name,
  cs.display_order,
  cs.description
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
WHERE a.is_active = true AND cs.is_active = true
ORDER BY a.name, cs.display_order;

-- Verify the 8 standard sections exist for each agency
WITH standard_sections AS (
  SELECT unnest(ARRAY[
    'General Knowledge',
    'Aptitude Test',
    'Training Insight',
    'Interview Prep',
    'Ranks & Structure',
    'Physical Fitness',
    'Technical Knowledge',
    'Career Guide'
  ]) as section_name
),
agency_section_matrix AS (
  SELECT 
    a.name as agency_name,
    ss.section_name,
    CASE WHEN cs.id IS NOT NULL THEN '✅' ELSE '❌' END as has_section
  FROM agencies a
  CROSS JOIN standard_sections ss
  LEFT JOIN content_sections cs ON a.id = cs.agency_id AND cs.name = ss.section_name
  WHERE a.is_active = true
)
SELECT 
  agency_name,
  string_agg(has_section || ' ' || section_name, E'\n' ORDER BY section_name) as sections_status
FROM agency_section_matrix
GROUP BY agency_name
ORDER BY agency_name;

-- Count materials per agency (optional - to see content distribution)
SELECT 
  a.name as agency_name,
  COUNT(sm.id) as total_materials,
  COUNT(CASE WHEN sm.is_premium = false THEN 1 END) as free_materials,
  COUNT(CASE WHEN sm.is_premium = true THEN 1 END) as premium_materials
FROM agencies a
LEFT JOIN study_materials sm ON a.id = sm.agency_id AND sm.is_active = true
WHERE a.is_active = true
GROUP BY a.id, a.name
ORDER BY total_materials DESC;
