-- =====================================================
-- REMAINING AGENCIES COMPREHENSIVE STUDY MATERIALS
-- =====================================================

-- =====================================================
-- NSCDC (NIGERIAN SECURITY AND CIVIL DEFENCE CORPS)
-- =====================================================

-- NSCDC Civics & Ethics
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Civics & Ethics', 'Civil Defense Duties', 'Comprehensive guide to civil defense duties and community protection responsibilities', 'pdf', 'nscdc/civics/civil_defense_duties.pdf', false, 'beginner', ARRAY['nscdc', 'civil', 'defense', 'duties'], 0, 2400000),
  ('Civics & Ethics', 'Community Safety', 'Community safety protocols, emergency response, and public protection measures', 'pdf', 'nscdc/civics/community_safety.pdf', false, 'intermediate', ARRAY['nscdc', 'community', 'safety', 'protection'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nscdc' AND cs.name = materials.section_name;

-- NSCDC General Knowledge
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('General Knowledge', 'NSCDC Structure', 'Organizational structure, hierarchy, and operational framework of NSCDC', 'pdf', 'nscdc/general/nscdc_structure.pdf', false, 'beginner', ARRAY['nscdc', 'structure', 'organization', 'hierarchy'], 0, 2200000),
  ('General Knowledge', 'Laws They Enforce', 'Comprehensive guide to laws and regulations enforced by NSCDC', 'pdf', 'nscdc/general/laws_enforced.pdf', false, 'intermediate', ARRAY['nscdc', 'laws', 'enforcement', 'regulations'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nscdc' AND cs.name = materials.section_name;

-- NSCDC Emergency Response
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Emergency Response', 'Basic Fire Safety and Evacuation Drills', 'Essential fire safety procedures and evacuation protocols for emergency situations', 'pdf', 'nscdc/emergency/fire_safety_evacuation.pdf', false, 'intermediate', ARRAY['nscdc', 'fire', 'safety', 'evacuation'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nscdc' AND cs.name = materials.section_name;

-- NSCDC Mock Test
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Mock Exams', 'NSCDC Sample Quiz', 'Comprehensive sample quiz for NSCDC recruitment examination preparation', 'pdf', 'nscdc/mock/nscdc_sample_quiz.pdf', false, 'intermediate', ARRAY['nscdc', 'sample', 'quiz', 'recruitment'], 0, 2200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nscdc' AND cs.name = materials.section_name;

-- NSCDC Fitness Tips
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Physical Fitness', 'Beginner to Intermediate Fitness Program', 'Progressive fitness program designed for NSCDC physical requirements', 'video', 'nscdc/fitness/beginner_intermediate_program.mp4', false, 'beginner', ARRAY['nscdc', 'fitness', 'beginner', 'program'], 2700, 180000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nscdc' AND cs.name = materials.section_name;

-- =====================================================
-- POLAC (POLICE ACADEMY)
-- =====================================================

-- POLAC Police Duties
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Police Duties', 'Rights of a Police Officer', 'Comprehensive guide to police officer rights, powers, and legal authority', 'pdf', 'polac/duties/police_officer_rights.pdf', false, 'intermediate', ARRAY['polac', 'police', 'rights', 'authority'], 0, 2600000),
  ('Police Duties', 'Code of Conduct', 'Professional code of conduct and ethical standards for police officers', 'pdf', 'polac/duties/code_of_conduct.pdf', false, 'beginner', ARRAY['polac', 'code', 'conduct', 'ethics'], 0, 2200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'polac' AND cs.name = materials.section_name;

-- POLAC Current Affairs
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Current Affairs', 'Internal Security Issues 2025', 'Current internal security challenges and policing strategies in Nigeria for 2025', 'pdf', 'polac/current/internal_security_2025.pdf', false, 'intermediate', ARRAY['polac', 'security', 'internal', '2025'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'polac' AND cs.name = materials.section_name;

-- POLAC Law & Constitution
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Law & Constitution', 'Nigerian Constitution Summary', 'Comprehensive summary of the Nigerian Constitution relevant to law enforcement', 'pdf', 'polac/law/constitution_summary.pdf', false, 'intermediate', ARRAY['polac', 'constitution', 'law', 'enforcement'], 0, 3200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'polac' AND cs.name = materials.section_name;

-- POLAC Aptitude Prep
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Aptitude Test', 'Reasoning and Comprehension', 'Advanced reasoning and comprehension exercises for police academy entrance', 'pdf', 'polac/aptitude/reasoning_comprehension.pdf', false, 'intermediate', ARRAY['polac', 'reasoning', 'comprehension', 'aptitude'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'polac' AND cs.name = materials.section_name;

-- POLAC Mock Test
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Mock Exams', 'POLAC Practice Paper A', 'Complete practice paper A for Police Academy entrance examination', 'pdf', 'polac/mock/polac_practice_paper_a.pdf', false, 'intermediate', ARRAY['polac', 'practice', 'paper', 'entrance'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'polac' AND cs.name = materials.section_name;

-- =====================================================
-- FRSC (FEDERAL ROAD SAFETY CORPS)
-- =====================================================

-- FRSC Road Safety
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Road Safety', 'Road Signs', 'Comprehensive guide to Nigerian road signs, traffic symbols, and their meanings', 'pdf', 'frsc/safety/road_signs.pdf', false, 'beginner', ARRAY['frsc', 'road', 'signs', 'traffic'], 0, 2200000),
  ('Road Safety', 'FRSC Traffic Guidelines', 'Official FRSC traffic guidelines, regulations, and enforcement procedures', 'pdf', 'frsc/safety/traffic_guidelines.pdf', false, 'intermediate', ARRAY['frsc', 'traffic', 'guidelines', 'enforcement'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'frsc' AND cs.name = materials.section_name;

-- FRSC Driving Theory
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Driving Theory', 'Basic Driving Test Prep', 'Comprehensive preparation material for basic driving theory test', 'pdf', 'frsc/driving/basic_driving_prep.pdf', false, 'beginner', ARRAY['frsc', 'driving', 'theory', 'test'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'frsc' AND cs.name = materials.section_name;

-- FRSC Mental Alertness
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mental Alertness', 'Decision Making While Driving', 'Mental alertness and decision-making skills for safe driving and traffic management', 'pdf', 'frsc/mental/decision_making_driving.pdf', false, 'intermediate', ARRAY['frsc', 'mental', 'decision', 'driving'], 0, 2200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'frsc' AND cs.name = materials.section_name;

-- FRSC First Aid
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('First Aid', 'Handling Road Accident Victims', 'Essential first aid procedures for handling road accident victims and emergency response', 'pdf', 'frsc/firstaid/road_accident_victims.pdf', false, 'intermediate', ARRAY['frsc', 'first-aid', 'accident', 'emergency'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'frsc' AND cs.name = materials.section_name;

-- FRSC Mock Quiz
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mock Exams', 'FRSC Entry Test', 'Complete FRSC entry test with questions covering all relevant topics', 'pdf', 'frsc/mock/frsc_entry_test.pdf', false, 'intermediate', ARRAY['frsc', 'entry', 'test', 'mock'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'frsc' AND cs.name = materials.section_name;
