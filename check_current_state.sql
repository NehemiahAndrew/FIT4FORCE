-- =====================================================
-- DIAGNOSTIC SCRIPT - Check current state
-- =====================================================
-- Run this first to see what agencies exist and their current sections

-- Check what agencies exist
SELECT 
  id,
  name,
  code,
  is_active
FROM agencies 
ORDER BY name;

-- Check current sections per agency
SELECT 
  a.name as agency_name,
  a.code as agency_code,
  COUNT(cs.id) as current_section_count,
  string_agg(cs.name, ', ' ORDER BY cs.display_order) as current_sections
FROM agencies a
LEFT JOIN content_sections cs ON a.id = cs.agency_id
WHERE a.is_active = true
GROUP BY a.id, a.name, a.code
ORDER BY a.name;

-- Check content_sections table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'content_sections'
ORDER BY ordinal_position;
