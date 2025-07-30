-- =====================================================
-- Fit4Force Educational Content Sample Data
-- Based on the provided content table
-- =====================================================

-- =====================================================
-- 1. POPULATE CONTENT SECTIONS FOR EACH AGENCY
-- =====================================================

-- Nigerian Army Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'General knowledge and current affairs', 'book', 1),
  ('Aptitude Test', 'Aptitude and reasoning tests', 'brain', 2),
  ('Screening/Training', 'Physical screening and training guides', 'fitness', 3),
  ('Ranks & Structure', 'Military ranks and organizational structure', 'hierarchy', 4),
  ('Interview Prep', 'Interview preparation and mock sessions', 'chat', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'army';

-- Nigerian Navy Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'Naval knowledge and current affairs', 'book', 1),
  ('Aptitude Test', 'Navy aptitude and technical tests', 'brain', 2),
  ('Training Insight', 'Naval training and career insights', 'anchor', 3),
  ('Interview Prep', 'Navy interview preparation', 'chat', 4),
  ('Physical Fitness', 'Navy physical fitness requirements', 'fitness', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'navy';

-- Nigerian Air Force Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Aptitude Test', 'Air Force aptitude and technical tests', 'brain', 1),
  ('Technical Knowledge', 'Aviation and technical knowledge', 'plane', 2),
  ('Training Insight', 'Air Force training programs', 'graduation-cap', 3),
  ('Physical Screening', 'Physical fitness and medical screening', 'fitness', 4),
  ('Interview Simulation', 'Interview preparation and simulation', 'chat', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'airforce';

-- NDA Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Papers', 'Core academic subjects', 'book', 1),
  ('Full Practice Exam', 'Complete practice examinations', 'test', 2),
  ('Campus Life', 'Life at Nigerian Defence Academy', 'university', 3),
  ('Interview Board', 'Interview preparation and tips', 'chat', 4),
  ('Experience Sharing', 'Candidate experiences and insights', 'users', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'nda';

-- DSSC/SSC Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Aptitude Test', 'DSSC aptitude tests by branch', 'brain', 1),
  ('Mock Exam', 'Practice examinations', 'test', 2),
  ('Career Guide', 'Professional career guidance', 'briefcase', 3),
  ('Program Info', 'DSSC program information', 'info', 4),
  ('Mistakes to Avoid', 'Common mistakes and how to avoid them', 'warning', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'dssc';

-- POLAC Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Entrance Exam', 'POLAC entrance examination', 'test', 1),
  ('Mock Test', 'Practice tests and mock exams', 'brain', 2),
  ('Campus Life', 'Life at Police Academy', 'university', 3),
  ('Experience Insight', 'Graduate experiences and tips', 'users', 4),
  ('Screening Guide', 'Physical and oral screening preparation', 'fitness', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'polac';

-- Fire Service Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Recruitment Exam', 'Fire service recruitment tests', 'test', 1),
  ('Fire Knowledge', 'Fire safety and hazard knowledge', 'fire', 2),
  ('Training Insight', 'Firefighter training programs', 'graduation-cap', 3),
  ('Screening Info', 'Screening process and requirements', 'info', 4),
  ('Job Life Demo', 'Day-to-day life of fire officers', 'calendar', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'fire';

-- NSCDC Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('General Knowledge', 'History, security, and civics', 'book', 1),
  ('CBT Practice', 'Computer-based test practice', 'computer', 2),
  ('Corps Insight', 'Understanding NSCDC operations', 'shield', 3),
  ('Recruitment Guide', 'Application to final list process', 'list', 4),
  ('Interview Simulation', 'Mock interview sessions', 'chat', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'nscdc';

-- Customs Service Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Recruitment Exam', 'Customs recruitment aptitude tests', 'test', 1),
  ('CBT Practice', 'Computer-based test practice', 'computer', 2),
  ('Career Insight', 'Customs duties and career path', 'briefcase', 3),
  ('Application Process', 'Step-by-step application guide', 'list', 4),
  ('Screening Tips', 'Screening process tips and advice', 'info', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'customs';

-- Immigration Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Recruitment Exam', 'Immigration service examinations', 'test', 1),
  ('CBT Practice', 'Computer-based test practice', 'computer', 2),
  ('Application Guide', 'Document requirements and process', 'file', 3),
  ('Screening Overview', 'Post-exam screening process', 'search', 4),
  ('Interview Simulation', 'Immigration officer role preparation', 'chat', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'immigration';

-- FRSC Sections
INSERT INTO content_sections (agency_id, name, description, icon, display_order) 
SELECT a.id, section_name, section_desc, section_icon, section_order
FROM agencies a,
(VALUES 
  ('Recruitment Exam', 'FRSC recruitment examinations', 'test', 1),
  ('Road Safety', 'Traffic signs and road safety rules', 'road', 2),
  ('Corps Insight', 'FRSC roles and responsibilities', 'info', 3),
  ('Mock Test', 'Technical and general practice tests', 'brain', 4),
  ('Physical Screening', 'Physical screening requirements', 'fitness', 5)
) AS sections(section_name, section_desc, section_icon, section_order)
WHERE a.code = 'frsc';

-- =====================================================
-- 2. POPULATE STUDY MATERIALS (SAMPLE DATA)
-- =====================================================

-- Nigerian Army Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at)
SELECT 
  a.id,
  cs.id,
  material_title,
  material_desc,
  material_type,
  material_path,
  material_premium,
  material_difficulty,
  material_tags,
  NOW() - INTERVAL '1 day'
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('General Knowledge', 'Nigerian Army DSSC Aptitude Test Past Questions (2024)', 'Comprehensive past questions for DSSC aptitude test', 'pdf', 'army/general/dssc_aptitude_2024.pdf', false, 'intermediate', ARRAY['army', 'dssc', 'aptitude', 'past-questions']),
  ('Aptitude Test', 'Army Recruitment CBT Practice Test (Timed)', 'Timed computer-based test practice', 'quiz', NULL, false, 'intermediate', ARRAY['army', 'cbt', 'practice', 'timed']),
  ('Screening/Training', 'How to Ace the Nigerian Army Screening Exercise', 'Complete guide to army screening process', 'video', 'army/screening/screening_guide.mp4', false, 'beginner', ARRAY['army', 'screening', 'guide', 'exercise']),
  ('Ranks & Structure', 'Essential Guide to Army Ranks, Training & Roles', 'Comprehensive guide to military hierarchy', 'pdf', 'army/ranks/ranks_structure.pdf', false, 'beginner', ARRAY['army', 'ranks', 'structure', 'hierarchy']),
  ('Interview Prep', 'Mock Interview: Why Do You Want to Join the Nigerian Army?', 'Interactive interview preparation', 'interactive_video', 'army/interview/mock_interview.mp4', true, 'intermediate', ARRAY['army', 'interview', 'mock', 'preparation'])
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Nigerian Navy Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at)
SELECT 
  a.id,
  cs.id,
  material_title,
  material_desc,
  material_type,
  material_path,
  material_premium,
  material_difficulty,
  material_tags,
  NOW() - INTERVAL '1 day'
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('General Knowledge', 'Nigerian Navy Recruitment Past Questions (General Knowledge)', 'Navy recruitment general knowledge questions', 'pdf', 'navy/general/recruitment_past_questions.pdf', false, 'intermediate', ARRAY['navy', 'recruitment', 'general-knowledge', 'past-questions']),
  ('Aptitude Test', 'Navy Aptitude Practice Test (Mock Exam Mode)', 'Comprehensive navy aptitude practice', 'quiz', NULL, false, 'intermediate', ARRAY['navy', 'aptitude', 'practice', 'mock-exam']),
  ('Training Insight', 'Video Tour: What to Expect at NN Basic Training School', 'Inside look at navy basic training', 'video', 'navy/training/basic_training_tour.mp4', false, 'beginner', ARRAY['navy', 'training', 'basic', 'school']),
  ('Interview Prep', 'Top 20 Interview Questions for Nigerian Navy Applicants', 'Common navy interview questions and answers', 'pdf', 'navy/interview/top_20_questions.pdf', true, 'intermediate', ARRAY['navy', 'interview', 'questions', 'preparation']),
  ('Physical Fitness', 'Nigerian Navy Physical Fitness Readiness Checklist', 'Complete fitness preparation guide', 'pdf', 'navy/fitness/readiness_checklist.pdf', false, 'beginner', ARRAY['navy', 'fitness', 'physical', 'checklist'])
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Nigerian Air Force Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at)
SELECT 
  a.id,
  cs.id,
  material_title,
  material_desc,
  material_type,
  material_path,
  material_premium,
  material_difficulty,
  material_tags,
  NOW() - INTERVAL '1 day'
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Aptitude Test', 'Air Force Recruitment Past Questions & Answers (2023 Update)', 'Updated air force recruitment questions', 'pdf', 'airforce/aptitude/recruitment_2023.pdf', false, 'intermediate', ARRAY['airforce', 'recruitment', 'past-questions', '2023']),
  ('Technical Knowledge', 'Mock CBT Test: Nigerian Air Force Technical Aptitude', 'Technical aptitude computer-based test', 'quiz', NULL, true, 'advanced', ARRAY['airforce', 'technical', 'cbt', 'aptitude']),
  ('Training Insight', 'Inside NAF Training School: Reality or Myth?', 'Real insights into air force training', 'video', 'airforce/training/naf_training_reality.mp4', false, 'beginner', ARRAY['airforce', 'training', 'school', 'insight']),
  ('Physical Screening', 'Top 10 Tips to Succeed in NAF Physical Screening', 'Physical screening success tips', 'video', 'airforce/screening/physical_tips.mp4', false, 'intermediate', ARRAY['airforce', 'physical', 'screening', 'tips']),
  ('Interview Simulation', 'NAF Recruitment Interview Simulation (Choose Your Response)', 'Interactive interview simulation', 'interactive_video', 'airforce/interview/simulation.mp4', true, 'advanced', ARRAY['airforce', 'interview', 'simulation', 'interactive'])
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;

-- Continue with other agencies...
-- (Due to length constraints, I'll provide a few more examples)

-- NDA Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at)
SELECT 
  a.id,
  cs.id,
  material_title,
  material_desc,
  material_type,
  material_path,
  material_premium,
  material_difficulty,
  material_tags,
  NOW() - INTERVAL '1 day'
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('General Papers', 'NDA Past Questions (English, Maths, Physics)', 'Core academic subjects past questions', 'pdf', 'nda/general/core_subjects.pdf', false, 'intermediate', ARRAY['nda', 'english', 'mathematics', 'physics']),
  ('Full Practice Exam', 'NDA Exam Simulator – Full-Length Practice Test', 'Complete NDA practice examination', 'quiz', NULL, true, 'advanced', ARRAY['nda', 'practice', 'exam', 'simulator']),
  ('Campus Life', 'Life at NDA: Training, Discipline & Routine', 'Inside look at NDA campus life', 'video', 'nda/campus/life_at_nda.mp4', false, 'beginner', ARRAY['nda', 'campus', 'life', 'training']),
  ('Interview Board', 'Secrets to Cracking the NDA Interview Board', 'Interview board preparation guide', 'pdf', 'nda/interview/board_secrets.pdf', true, 'advanced', ARRAY['nda', 'interview', 'board', 'secrets']),
  ('Experience Sharing', 'NDA Screening Experience Compilation (Past Candidates)', 'Real candidate experiences', 'video', 'nda/experience/candidate_stories.mp4', false, 'intermediate', ARRAY['nda', 'experience', 'screening', 'candidates'])
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags)
WHERE a.code = 'nda' AND cs.name = materials.section_name;

-- =====================================================
-- 3. UPDATE MATERIAL ANALYTICS (SAMPLE DATA)
-- =====================================================

-- Add some realistic view counts and ratings
UPDATE study_materials SET 
  view_count = floor(random() * 1000) + 100,
  download_count = floor(random() * 500) + 50,
  average_rating = (random() * 2 + 3)::numeric(3,2), -- Random rating between 3.0 and 5.0
  total_ratings = floor(random() * 50) + 10
WHERE published_at IS NOT NULL;

-- =====================================================
-- 4. CREATE SAMPLE QUIZ DATA
-- =====================================================

-- Update quiz materials with sample quiz data
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
-- VERIFICATION QUERIES
-- =====================================================

-- Verify data insertion
SELECT 
  a.name as agency,
  COUNT(cs.id) as sections_count,
  COUNT(sm.id) as materials_count,
  COUNT(CASE WHEN sm.is_premium = false THEN 1 END) as free_materials,
  COUNT(CASE WHEN sm.is_premium = true THEN 1 END) as premium_materials
FROM agencies a
LEFT JOIN content_sections cs ON a.id = cs.agency_id
LEFT JOIN study_materials sm ON cs.id = sm.section_id
GROUP BY a.id, a.name
ORDER BY a.display_order;
