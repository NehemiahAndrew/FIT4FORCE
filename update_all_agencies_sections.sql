-- =====================================================
-- UPDATE ALL AGENCIES TO HAVE 8 COMPREHENSIVE SECTIONS
-- =====================================================
-- This script adds all 8 categories to every agency for consistency

-- First, clear existing content sections to avoid duplicates
DELETE FROM content_sections WHERE agency_id IN (
  SELECT id FROM agencies WHERE is_active = true
);

-- Standard 8 sections for ALL agencies
-- These sections will be available for every agency

-- Nigerian Army - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'General knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Aptitude and reasoning tests', 'psychology', 2),
  ('Training Insight', 'Military training and preparation insights', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation materials', 'chat', 4),
  ('Ranks & Structure', 'Military ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements and training', 'directions_run', 6),
  ('Technical Knowledge', 'Technical and specialized knowledge', 'engineering', 7),
  ('Career Guide', 'Career guidance and opportunities', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'army';

-- Nigerian Navy - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Naval knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Navy aptitude and technical tests', 'psychology', 2),
  ('Training Insight', 'Naval training and career insights', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and mock sessions', 'chat', 4),
  ('Ranks & Structure', 'Naval ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements and training', 'directions_run', 6),
  ('Technical Knowledge', 'Naval and maritime technical knowledge', 'engineering', 7),
  ('Career Guide', 'Naval career guidance and opportunities', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'navy';

-- Nigerian Air Force - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Aviation knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Air Force aptitude and technical tests', 'psychology', 2),
  ('Training Insight', 'Air Force training programs', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and simulation', 'chat', 4),
  ('Ranks & Structure', 'Air Force ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical screening and fitness requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Aviation and technical knowledge', 'engineering', 7),
  ('Career Guide', 'Air Force career guidance and opportunities', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'airforce';

-- NDA - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Core academic subjects and general knowledge', 'lightbulb', 1),
  ('Aptitude Test', 'Academic aptitude and reasoning tests', 'psychology', 2),
  ('Training Insight', 'Life at Nigerian Defence Academy', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and tips', 'chat', 4),
  ('Ranks & Structure', 'Military ranks and academy structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness and medical requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Academic and technical knowledge', 'engineering', 7),
  ('Career Guide', 'Academic and military career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'nda';

-- DSSC/SSC - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'General knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'DSSC aptitude tests by branch', 'psychology', 2),
  ('Training Insight', 'DSSC training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and mock sessions', 'chat', 4),
  ('Ranks & Structure', 'Officer ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Branch-specific technical knowledge', 'engineering', 7),
  ('Career Guide', 'Professional career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'dssc';

-- POLAC - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Police knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'POLAC entrance examination and aptitude tests', 'psychology', 2),
  ('Training Insight', 'Life at Police Academy and training', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening guide', 'chat', 4),
  ('Ranks & Structure', 'Police ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical and oral screening preparation', 'directions_run', 6),
  ('Technical Knowledge', 'Law enforcement technical knowledge', 'engineering', 7),
  ('Career Guide', 'Police career guidance and opportunities', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'polac';

-- Fire Service - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Fire service knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Fire service recruitment tests', 'psychology', 2),
  ('Training Insight', 'Firefighter training programs', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening info', 'chat', 4),
  ('Ranks & Structure', 'Fire service ranks and structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness and screening requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Fire safety and hazard knowledge', 'engineering', 7),
  ('Career Guide', 'Fire service career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'fire';

-- NSCDC - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Civil defense knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'NSCDC aptitude and reasoning tests', 'psychology', 2),
  ('Training Insight', 'Civil defense training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening', 'chat', 4),
  ('Ranks & Structure', 'NSCDC ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements and training', 'directions_run', 6),
  ('Technical Knowledge', 'Emergency response and civil defense knowledge', 'engineering', 7),
  ('Career Guide', 'Civil defense career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'nscdc';

-- FRSC - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Road safety knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'FRSC aptitude and road safety tests', 'psychology', 2),
  ('Training Insight', 'Road safety training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening', 'chat', 4),
  ('Ranks & Structure', 'FRSC ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness and medical requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Road safety and driving theory knowledge', 'engineering', 7),
  ('Career Guide', 'Road safety career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'frsc';

-- Immigration - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Immigration knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Immigration aptitude and reasoning tests', 'psychology', 2),
  ('Training Insight', 'Immigration training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening', 'chat', 4),
  ('Ranks & Structure', 'Immigration ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Border laws and immigration procedures', 'engineering', 7),
  ('Career Guide', 'Immigration career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'immigration';

-- Customs - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Customs knowledge and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'Customs aptitude and reasoning tests', 'psychology', 2),
  ('Training Insight', 'Customs training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening', 'chat', 4),
  ('Ranks & Structure', 'Customs ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Import/export rules and customs laws', 'engineering', 7),
  ('Career Guide', 'Customs career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'customs';

-- DSS - 8 Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Security intelligence and current affairs', 'lightbulb', 1),
  ('Aptitude Test', 'DSS aptitude and intelligence tests', 'psychology', 2),
  ('Training Insight', 'Intelligence training and preparation', 'fitness_center', 3),
  ('Interview Prep', 'Interview preparation and screening', 'chat', 4),
  ('Ranks & Structure', 'DSS ranks and organizational structure', 'military_tech', 5),
  ('Physical Fitness', 'Physical fitness and security requirements', 'directions_run', 6),
  ('Technical Knowledge', 'Intelligence basics and cyber awareness', 'engineering', 7),
  ('Career Guide', 'Intelligence career guidance', 'work', 8)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'dss';

-- Note: No need to reset sequence for UUID primary keys

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
