-- =====================================================
-- COMPREHENSIVE STUDY MATERIALS FOR FIT4FORCE APP
-- =====================================================
-- This file contains extensive study materials for all agencies
-- organized by categories and difficulty levels

-- =====================================================
-- 1. NIGERIAN ARMY COMPREHENSIVE MATERIALS
-- =====================================================

-- General Knowledge Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('General Knowledge', 'Nigerian History and Independence (1960-2024)', 'Complete guide to Nigerian history from independence to present', 'pdf', 'army/general/nigerian_history_complete.pdf', false, 'beginner', ARRAY['army', 'history', 'independence', 'nigeria'], 0, 2500000),
  ('General Knowledge', 'Current Affairs: Nigeria and West Africa (2024)', 'Latest current affairs covering Nigeria and regional developments', 'pdf', 'army/general/current_affairs_2024.pdf', false, 'intermediate', ARRAY['army', 'current-affairs', 'west-africa', '2024'], 0, 1800000),
  ('General Knowledge', 'Nigerian Constitution and Government Structure', 'Comprehensive guide to Nigerian constitution and governance', 'pdf', 'army/general/constitution_government.pdf', false, 'intermediate', ARRAY['army', 'constitution', 'government', 'structure'], 0, 2200000),
  ('General Knowledge', 'Geography of Nigeria: States, Capitals, and Resources', 'Complete geographical overview of Nigeria', 'pdf', 'army/general/geography_nigeria.pdf', false, 'beginner', ARRAY['army', 'geography', 'states', 'resources'], 0, 3000000),
  ('General Knowledge', 'Interactive Nigeria Map Quiz', 'Test your knowledge of Nigerian geography', 'quiz', NULL, false, 'beginner', ARRAY['army', 'geography', 'quiz', 'interactive'], 1200, 0)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Mathematics Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Mathematics', 'Basic Mathematics for Military Recruitment', 'Fundamental math concepts for army recruitment', 'pdf', 'army/math/basic_mathematics.pdf', false, 'beginner', ARRAY['army', 'mathematics', 'basic', 'recruitment'], 0, 1500000),
  ('Mathematics', 'Algebra and Equations Practice Set', 'Comprehensive algebra practice with solutions', 'pdf', 'army/math/algebra_practice.pdf', false, 'intermediate', ARRAY['army', 'algebra', 'equations', 'practice'], 0, 1200000),
  ('Mathematics', 'Geometry and Mensuration for Army Tests', 'Geometry concepts commonly tested in army exams', 'pdf', 'army/math/geometry_mensuration.pdf', false, 'intermediate', ARRAY['army', 'geometry', 'mensuration', 'tests'], 0, 1800000),
  ('Mathematics', 'Timed Mathematics Practice Test', 'Simulated math test with time constraints', 'quiz', NULL, false, 'intermediate', ARRAY['army', 'mathematics', 'timed', 'practice'], 3600, 0),
  ('Mathematics', 'Advanced Mathematics for Officers', 'Higher-level math for officer candidates', 'pdf', 'army/math/advanced_mathematics.pdf', true, 'advanced', ARRAY['army', 'mathematics', 'advanced', 'officers'], 0, 2500000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- English Language Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('English Language', 'Grammar Fundamentals for Military Communication', 'Essential grammar rules for effective military communication', 'pdf', 'army/english/grammar_fundamentals.pdf', false, 'beginner', ARRAY['army', 'english', 'grammar', 'communication'], 0, 1400000),
  ('English Language', 'Vocabulary Building for Army Personnel', 'Military and general vocabulary enhancement', 'pdf', 'army/english/vocabulary_building.pdf', false, 'intermediate', ARRAY['army', 'english', 'vocabulary', 'military'], 0, 1600000),
  ('English Language', 'Reading Comprehension Practice Tests', 'Multiple reading passages with questions', 'pdf', 'army/english/reading_comprehension.pdf', false, 'intermediate', ARRAY['army', 'english', 'reading', 'comprehension'], 0, 2000000),
  ('English Language', 'Essay Writing for Military Applications', 'Guide to writing effective essays and reports', 'pdf', 'army/english/essay_writing.pdf', true, 'advanced', ARRAY['army', 'english', 'essay', 'writing'], 0, 1800000),
  ('English Language', 'English Language Proficiency Test', 'Comprehensive English assessment', 'quiz', NULL, false, 'intermediate', ARRAY['army', 'english', 'proficiency', 'test'], 2700, 0)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Aptitude Test Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Aptitude Test', 'Logical Reasoning and Pattern Recognition', 'Develop logical thinking skills for aptitude tests', 'pdf', 'army/aptitude/logical_reasoning.pdf', false, 'intermediate', ARRAY['army', 'aptitude', 'logical', 'reasoning'], 0, 1700000),
  ('Aptitude Test', 'Numerical Reasoning Practice', 'Number sequences and mathematical reasoning', 'pdf', 'army/aptitude/numerical_reasoning.pdf', false, 'intermediate', ARRAY['army', 'aptitude', 'numerical', 'reasoning'], 0, 1500000),
  ('Aptitude Test', 'Verbal Reasoning and Critical Thinking', 'Enhance verbal reasoning abilities', 'pdf', 'army/aptitude/verbal_reasoning.pdf', false, 'intermediate', ARRAY['army', 'aptitude', 'verbal', 'reasoning'], 0, 1600000),
  ('Aptitude Test', 'Full Aptitude Practice Exam', 'Complete aptitude test simulation', 'quiz', NULL, true, 'advanced', ARRAY['army', 'aptitude', 'practice', 'exam'], 5400, 0),
  ('Aptitude Test', 'Speed and Accuracy Training', 'Improve test-taking speed and accuracy', 'interactive_video', 'army/aptitude/speed_training.mp4', true, 'advanced', ARRAY['army', 'aptitude', 'speed', 'accuracy'], 1800, 150000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Physical Fitness Materials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT 
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES 
  ('Physical Fitness', 'Army Physical Fitness Standards and Requirements', 'Official fitness standards for army recruitment', 'pdf', 'army/fitness/fitness_standards.pdf', false, 'beginner', ARRAY['army', 'fitness', 'standards', 'requirements'], 0, 1200000),
  ('Physical Fitness', 'Pre-Recruitment Fitness Training Program', '12-week fitness preparation program', 'pdf', 'army/fitness/training_program.pdf', false, 'intermediate', ARRAY['army', 'fitness', 'training', 'program'], 0, 2800000),
  ('Physical Fitness', 'Nutrition Guide for Military Fitness', 'Dietary guidelines for optimal physical performance', 'pdf', 'army/fitness/nutrition_guide.pdf', true, 'intermediate', ARRAY['army', 'fitness', 'nutrition', 'diet'], 0, 2200000),
  ('Physical Fitness', 'Exercise Demonstration Videos', 'Proper form and technique for fitness tests', 'video', 'army/fitness/exercise_demos.mp4', false, 'beginner', ARRAY['army', 'fitness', 'exercise', 'demonstration'], 2400, 200000000),
  ('Physical Fitness', 'Mental Preparation for Physical Tests', 'Psychological strategies for fitness success', 'video', 'army/fitness/mental_prep.mp4', true, 'advanced', ARRAY['army', 'fitness', 'mental', 'preparation'], 1800, 120000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- =====================================================
-- 2. NIGERIAN NAVY COMPREHENSIVE MATERIALS
-- =====================================================

-- General Knowledge Materials for Navy
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('General Knowledge', 'Maritime History of Nigeria', 'Naval history and maritime heritage of Nigeria', 'pdf', 'navy/general/maritime_history.pdf', false, 'beginner', ARRAY['navy', 'maritime', 'history', 'nigeria'], 0, 2200000),
  ('General Knowledge', 'Ocean Geography and Navigation Basics', 'Understanding oceans, seas, and basic navigation', 'pdf', 'navy/general/ocean_geography.pdf', false, 'intermediate', ARRAY['navy', 'ocean', 'geography', 'navigation'], 0, 2800000),
  ('General Knowledge', 'International Maritime Law Fundamentals', 'Basic principles of maritime law and regulations', 'pdf', 'navy/general/maritime_law.pdf', true, 'advanced', ARRAY['navy', 'maritime', 'law', 'international'], 0, 3200000),
  ('General Knowledge', 'Naval Terminology and Vocabulary', 'Essential naval terms and maritime vocabulary', 'pdf', 'navy/general/naval_terminology.pdf', false, 'beginner', ARRAY['navy', 'terminology', 'vocabulary', 'maritime'], 0, 1500000),
  ('General Knowledge', 'Navy Knowledge Assessment Quiz', 'Test your naval general knowledge', 'quiz', NULL, false, 'intermediate', ARRAY['navy', 'knowledge', 'assessment', 'quiz'], 1800, 0)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Mathematics for Navy
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mathematics', 'Navigation Mathematics and Calculations', 'Mathematical concepts for naval navigation', 'pdf', 'navy/math/navigation_math.pdf', false, 'intermediate', ARRAY['navy', 'mathematics', 'navigation', 'calculations'], 0, 2000000),
  ('Mathematics', 'Trigonometry for Naval Applications', 'Trigonometric principles in naval operations', 'pdf', 'navy/math/trigonometry_naval.pdf', true, 'advanced', ARRAY['navy', 'trigonometry', 'naval', 'applications'], 0, 2400000),
  ('Mathematics', 'Statistics and Data Analysis for Navy', 'Statistical methods in naval operations', 'pdf', 'navy/math/statistics_navy.pdf', true, 'advanced', ARRAY['navy', 'statistics', 'data', 'analysis'], 0, 2200000),
  ('Mathematics', 'Basic Mathematics for Navy Recruitment', 'Fundamental math for navy entrance exams', 'pdf', 'navy/math/basic_math_navy.pdf', false, 'beginner', ARRAY['navy', 'mathematics', 'basic', 'recruitment'], 0, 1600000),
  ('Mathematics', 'Navy Mathematics Practice Test', 'Comprehensive math assessment for navy', 'quiz', NULL, false, 'intermediate', ARRAY['navy', 'mathematics', 'practice', 'test'], 3000, 0)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- =====================================================
-- 3. NDA (NIGERIAN DEFENCE ACADEMY) MATERIALS
-- =====================================================

-- Academic Subjects for NDA
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('General Papers', 'Physics for NDA Entrance Examination', 'Comprehensive physics syllabus for NDA', 'pdf', 'nda/physics/nda_physics_complete.pdf', false, 'advanced', ARRAY['nda', 'physics', 'entrance', 'examination'], 0, 3500000),
  ('General Papers', 'Chemistry Fundamentals for NDA', 'Essential chemistry concepts for NDA exam', 'pdf', 'nda/chemistry/nda_chemistry.pdf', false, 'advanced', ARRAY['nda', 'chemistry', 'fundamentals', 'exam'], 0, 3200000),
  ('General Papers', 'Advanced Mathematics for NDA', 'Higher mathematics for NDA candidates', 'pdf', 'nda/math/advanced_mathematics_nda.pdf', false, 'advanced', ARRAY['nda', 'mathematics', 'advanced', 'candidates'], 0, 4000000),
  ('General Papers', 'English Language and Literature', 'Comprehensive English for NDA entrance', 'pdf', 'nda/english/english_literature_nda.pdf', false, 'advanced', ARRAY['nda', 'english', 'literature', 'entrance'], 0, 2800000),
  ('General Papers', 'NDA Full Practice Examination', 'Complete NDA entrance exam simulation', 'quiz', NULL, true, 'advanced', ARRAY['nda', 'practice', 'examination', 'simulation'], 10800, 0)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'nda' AND cs.name = materials.section_name;

-- =====================================================
-- 4. COMPREHENSIVE QUIZ DATA IMPLEMENTATION
-- =====================================================

-- Update quiz materials with comprehensive quiz data
UPDATE study_materials
SET quiz_data = '{
  "questions": [
    {
      "question": "What is the capital of Nigeria?",
      "options": ["Lagos", "Abuja", "Kano", "Port Harcourt"],
      "correct": 1,
      "explanation": "Abuja has been the capital of Nigeria since 1991, replacing Lagos.",
      "category": "Geography",
      "difficulty": "beginner"
    },
    {
      "question": "In which year did Nigeria gain independence?",
      "options": ["1958", "1960", "1963", "1965"],
      "correct": 1,
      "explanation": "Nigeria gained independence from British colonial rule on October 1, 1960.",
      "category": "History",
      "difficulty": "beginner"
    },
    {
      "question": "What is the motto of the Nigerian Army?",
      "options": ["Victory in Unity", "To Serve Nigeria", "Duty and Honor", "Strength and Courage"],
      "correct": 0,
      "explanation": "The Nigerian Army motto is Victory in Unity, emphasizing teamwork and national service.",
      "category": "Military Knowledge",
      "difficulty": "intermediate"
    },
    {
      "question": "Which of the following is NOT a state in Nigeria?",
      "options": ["Osun", "Ekiti", "Kwara", "Benin"],
      "correct": 3,
      "explanation": "Benin is a neighboring country, not a state in Nigeria. The others are all Nigerian states.",
      "category": "Geography",
      "difficulty": "intermediate"
    },
    {
      "question": "What does ECOWAS stand for?",
      "options": ["Economic Community of West African States", "East Coast of West African States", "Economic Council of West African States", "European Community of West African States"],
      "correct": 0,
      "explanation": "ECOWAS stands for Economic Community of West African States, a regional economic union.",
      "category": "Current Affairs",
      "difficulty": "intermediate"
    }
  ],
  "duration": 1800,
  "passing_score": 70,
  "total_questions": 5,
  "instructions": "Answer all questions within the time limit. Each question carries equal marks.",
  "time_per_question": 360
}'
WHERE content_type = 'quiz' AND title LIKE '%Knowledge%Quiz%';

-- Update mathematics quiz data
UPDATE study_materials
SET quiz_data = '{
  "questions": [
    {
      "question": "If 2x + 5 = 15, what is the value of x?",
      "options": ["5", "10", "7.5", "12.5"],
      "correct": 0,
      "explanation": "2x + 5 = 15, so 2x = 10, therefore x = 5.",
      "category": "Algebra",
      "difficulty": "beginner"
    },
    {
      "question": "What is the area of a circle with radius 7 cm? (Use π = 22/7)",
      "options": ["154 cm²", "44 cm²", "22 cm²", "308 cm²"],
      "correct": 0,
      "explanation": "Area = πr² = (22/7) × 7² = (22/7) × 49 = 154 cm²",
      "category": "Geometry",
      "difficulty": "intermediate"
    },
    {
      "question": "What is 15% of 200?",
      "options": ["30", "25", "35", "20"],
      "correct": 0,
      "explanation": "15% of 200 = (15/100) × 200 = 30",
      "category": "Percentage",
      "difficulty": "beginner"
    }
  ],
  "duration": 3000,
  "passing_score": 60,
  "total_questions": 3,
  "instructions": "Solve all mathematical problems. Show your working where necessary.",
  "time_per_question": 1000
}'
WHERE content_type = 'quiz' AND title LIKE '%Mathematics%Test%';

-- =====================================================
-- COMPREHENSIVE STUDY MATERIALS FOR ALL AGENCIES
-- Based on the detailed study content plan
-- =====================================================

-- =====================================================
-- ARMY COMPREHENSIVE MATERIALS
-- =====================================================

-- Army General Knowledge
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('General Knowledge', 'History of Nigerian Army', 'Complete history of the Nigerian Army from formation to present day', 'pdf', 'army/general/nigerian_army_history.pdf', false, 'beginner', ARRAY['army', 'history', 'formation', 'military'], 0, 2800000),
  ('General Knowledge', 'Army Rank Structure', 'Detailed guide to Nigerian Army ranks, insignia, and hierarchy', 'pdf', 'army/general/army_rank_structure.pdf', false, 'beginner', ARRAY['army', 'ranks', 'hierarchy', 'insignia'], 0, 2200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Army Fitness Guide
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Physical Fitness', 'Army Workout Routine', 'Complete workout routine designed for army fitness standards', 'video', 'army/fitness/army_workout_routine.mp4', false, 'intermediate', ARRAY['army', 'workout', 'routine', 'fitness'], 2400, 180000000),
  ('Physical Fitness', 'Endurance Training Tips', 'Professional tips for building military-grade endurance', 'video', 'army/fitness/endurance_training_tips.mp4', false, 'intermediate', ARRAY['army', 'endurance', 'training', 'tips'], 1800, 120000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Army Current Affairs
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Current Affairs', '2024-2025 Nigeria News Summary', 'Comprehensive summary of major Nigerian news and events for 2024-2025', 'pdf', 'army/current/nigeria_news_2024_2025.pdf', false, 'intermediate', ARRAY['army', 'current-affairs', '2024', '2025', 'nigeria'], 0, 3200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Army Aptitude Test
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Aptitude Test', 'Army Verbal & Numerical Reasoning', 'Comprehensive verbal and numerical reasoning practice for army aptitude tests', 'pdf', 'army/aptitude/verbal_numerical_reasoning.pdf', false, 'intermediate', ARRAY['army', 'verbal', 'numerical', 'reasoning'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- Army Mock Tests
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mock Exams', 'Army General Mock Test Set A', 'Complete mock examination set A for army recruitment preparation', 'pdf', 'army/mock/army_mock_test_set_a.pdf', false, 'intermediate', ARRAY['army', 'mock', 'test', 'examination'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'army' AND cs.name = materials.section_name;

-- =====================================================
-- NAVY COMPREHENSIVE MATERIALS
-- =====================================================

-- Navy Naval Basics
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Naval Basics', 'Naval Terms & Terminology', 'Comprehensive guide to naval terms, maritime vocabulary, and naval terminology', 'pdf', 'navy/basics/naval_terms_terminology.pdf', false, 'beginner', ARRAY['navy', 'terms', 'terminology', 'maritime'], 0, 2400000),
  ('Naval Basics', 'Duties of Navy Officers', 'Detailed overview of naval officer duties, responsibilities, and chain of command', 'pdf', 'navy/basics/navy_officer_duties.pdf', false, 'intermediate', ARRAY['navy', 'officers', 'duties', 'responsibilities'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Navy Current Affairs
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Current Affairs', 'Maritime News', 'Latest maritime news, naval developments, and international maritime affairs', 'pdf', 'navy/current/maritime_news.pdf', false, 'intermediate', ARRAY['navy', 'maritime', 'news', 'international'], 0, 2600000),
  ('Current Affairs', 'Nigeria Naval Operations', 'Recent Nigerian Navy operations, missions, and achievements', 'pdf', 'navy/current/nigeria_naval_operations.pdf', false, 'intermediate', ARRAY['navy', 'operations', 'missions', 'nigeria'], 0, 2400000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Navy English & Comprehension
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('English Language', 'Naval Passage Practice Test', 'Reading comprehension practice with naval-themed passages and questions', 'pdf', 'navy/english/naval_passage_practice.pdf', false, 'intermediate', ARRAY['navy', 'english', 'comprehension', 'practice'], 0, 2200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Navy Video Tutorials
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Video Tutorials', 'Life on a Naval Base', 'Documentary-style video showing daily life and operations on a Nigerian naval base', 'video', 'navy/videos/life_naval_base.mp4', false, 'beginner', ARRAY['navy', 'base', 'life', 'operations'], 3600, 250000000),
  ('Video Tutorials', 'Navy Training Highlights', 'Highlights of Nigerian Navy training programs and exercises', 'video', 'navy/videos/navy_training_highlights.mp4', false, 'intermediate', ARRAY['navy', 'training', 'exercises', 'highlights'], 2700, 180000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- Navy Mock Test
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mock Exams', 'Navy Mock Questions', 'Comprehensive mock examination questions for Nigerian Navy recruitment', 'pdf', 'navy/mock/navy_mock_questions.pdf', false, 'intermediate', ARRAY['navy', 'mock', 'questions', 'recruitment'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'navy' AND cs.name = materials.section_name;

-- =====================================================
-- AIR FORCE COMPREHENSIVE MATERIALS
-- =====================================================

-- Air Force General Knowledge
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('General Knowledge', 'History of Nigerian Air Force', 'Complete history of the Nigerian Air Force from establishment to modern operations', 'pdf', 'airforce/general/naf_history.pdf', false, 'beginner', ARRAY['airforce', 'history', 'establishment', 'operations'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;

-- Air Force Aircraft Knowledge
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Aircraft Knowledge', 'Aircraft Identification & Functions', 'Comprehensive guide to aircraft types, identification, and their specific functions', 'pdf', 'airforce/aircraft/aircraft_identification_functions.pdf', false, 'intermediate', ARRAY['airforce', 'aircraft', 'identification', 'functions'], 0, 3200000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;

-- Air Force Mental Test
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mental Test', 'Logical Reasoning Exercises', 'Advanced logical reasoning exercises designed for air force mental aptitude tests', 'pdf', 'airforce/mental/logical_reasoning_exercises.pdf', false, 'advanced', ARRAY['airforce', 'logical', 'reasoning', 'mental'], 0, 2600000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;

-- Air Force Fitness & Endurance
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Physical Fitness', 'Air Force Running Drill', 'Specialized running drills and techniques for air force fitness standards', 'video', 'airforce/fitness/running_drill.mp4', false, 'intermediate', ARRAY['airforce', 'running', 'drill', 'fitness'], 2100, 150000000),
  ('Physical Fitness', 'Core Workout', 'Core strengthening workout specifically designed for air force personnel', 'video', 'airforce/fitness/core_workout.mp4', false, 'intermediate', ARRAY['airforce', 'core', 'workout', 'strength'], 1800, 120000000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;

-- Air Force Mock Exams
INSERT INTO study_materials (agency_id, section_id, title, description, content_type, file_path, is_premium, difficulty_level, tags, published_at, duration, file_size)
SELECT
  a.id, cs.id, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, NOW() - INTERVAL '1 day', material_duration, material_size
FROM agencies a
JOIN content_sections cs ON a.id = cs.agency_id
CROSS JOIN (VALUES
  ('Mock Exams', 'NAF Entry Mock Test', 'Complete Nigerian Air Force entry mock examination with detailed solutions', 'pdf', 'airforce/mock/naf_entry_mock_test.pdf', false, 'intermediate', ARRAY['airforce', 'naf', 'entry', 'mock'], 0, 2800000)
) AS materials(section_name, material_title, material_desc, material_type, material_path, material_premium, material_difficulty, material_tags, material_duration, material_size)
WHERE a.code = 'airforce' AND cs.name = materials.section_name;
