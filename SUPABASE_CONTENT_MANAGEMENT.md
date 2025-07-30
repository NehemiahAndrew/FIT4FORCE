# Supabase Dashboard Content Management for Fit4Force

## 🎯 Overview

All educational content, study materials, exercise images, and videos for the Fit4Force app are managed exclusively through the Supabase dashboard. The Flutter app only consumes and displays this content - it does NOT provide admin upload interfaces.

## 📁 Content Management Workflow

### 1. **Study Materials Management**

#### Upload Process via Supabase Dashboard:

1. **Navigate to Storage**
   - Go to your Supabase project dashboard
   - Click **Storage** in the left sidebar
   - Select the **study-materials** bucket

2. **Organize by Structure**
   ```
   study-materials/
   ├── mathematics/
   │   ├── nigerian_army/
   │   ├── nigerian_navy/
   │   └── all/
   ├── english/
   │   ├── nigerian_army/
   │   └── all/
   ├── current_affairs/
   └── military_knowledge/
   ```

3. **Upload Files**
   - Click **Upload file** button
   - Select your PDF, DOC, DOCX, or TXT files
   - Upload to appropriate category/agency folder

4. **Add Metadata to Database**
   - Go to **Table Editor** → **study_materials** table
   - Click **Insert** → **Row**
   - Fill in the metadata:

   ```sql
   INSERT INTO study_materials (
     file_path,
     file_name,
     category,
     target_agency,
     is_premium_only,
     description,
     tags,
     uploaded_by,
     file_size,
     content_type,
     public_url,
     status
   ) VALUES (
     'study-materials/mathematics/nigerian_army/2024_algebra_questions.pdf',
     'Algebra Past Questions 2024',
     'mathematics',
     'nigerian_army',
     false,
     'Comprehensive algebra questions from previous Nigerian Army recruitment exams',
     ARRAY['mathematics', 'algebra', 'past-questions', 'nigerian-army'],
     'admin-user-id',
     2048576,
     'application/pdf',
     'https://your-project.supabase.co/storage/v1/object/public/study-materials/mathematics/nigerian_army/2024_algebra_questions.pdf',
     'active'
   );
   ```

### 2. **Exercise Images Management**

#### Upload Process:

1. **Navigate to workout-images bucket**
   - Go to **Storage** → **workout-images**
   - Create folder structure:
   ```
   workout-images/
   ├── exercises/
   │   ├── push-ups/
   │   ├── sit-ups/
   │   ├── running/
   │   └── weight-training/
   └── demonstrations/
   ```

2. **Upload Exercise Images**
   - Upload high-quality demonstration images
   - Use descriptive file names
   - Recommended size: 1200x800px or similar

3. **Update Exercise Database**
   - Go to **Table Editor** → **exercises** table
   - Update exercise records with image URLs:

   ```sql
   UPDATE exercises 
   SET 
     image_url = 'https://your-project.supabase.co/storage/v1/object/public/workout-images/exercises/push-ups/proper_form.jpg',
     demonstration_images = ARRAY[
       'https://your-project.supabase.co/storage/v1/object/public/workout-images/exercises/push-ups/step1.jpg',
       'https://your-project.supabase.co/storage/v1/object/public/workout-images/exercises/push-ups/step2.jpg'
     ]
   WHERE name = 'Push-ups';
   ```

### 3. **Exercise Videos Management**

#### Upload Process:

1. **Navigate to exercise-videos bucket**
   - Go to **Storage** → **exercise-videos**
   - Create folder structure:
   ```
   exercise-videos/
   ├── cardio/
   ├── strength/
   ├── flexibility/
   └── military-specific/
   ```

2. **Upload Video Files**
   - Upload MP4, WebM, or MOV files
   - Keep file sizes reasonable (under 100MB)
   - Use descriptive names

3. **Update Exercise Database**
   ```sql
   UPDATE exercises 
   SET 
     video_url = 'https://your-project.supabase.co/storage/v1/object/public/exercise-videos/strength/proper_pushup_form.mp4',
     video_duration = 120
   WHERE name = 'Push-ups';
   ```

## 🗂️ Database Tables for Content Management

### Study Materials Table Structure

```sql
CREATE TABLE study_materials (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN (
    'general', 'mathematics', 'english', 'current_affairs', 
    'military_knowledge', 'physical_fitness', 'interview_prep', 'aptitude_tests'
  )),
  target_agency TEXT NOT NULL CHECK (target_agency IN (
    'all', 'nigerian_army', 'nigerian_navy', 'nigerian_air_force', 
    'nigerian_police', 'civil_defence', 'immigration', 'customs', 'fire_service'
  )),
  is_premium_only BOOLEAN DEFAULT FALSE,
  description TEXT,
  tags TEXT[],
  uploaded_by UUID REFERENCES auth.users(id),
  file_size BIGINT,
  content_type TEXT,
  public_url TEXT NOT NULL,
  download_count INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Exercises Table Structure

```sql
CREATE TABLE exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
  description TEXT,
  instructions TEXT[],
  image_url TEXT,
  demonstration_images TEXT[],
  video_url TEXT,
  video_duration INTEGER, -- in seconds
  equipment_needed TEXT[],
  muscle_groups TEXT[],
  target_agencies TEXT[],
  is_premium_only BOOLEAN DEFAULT FALSE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🔧 Content Management Best Practices

### File Naming Conventions

1. **Study Materials**
   ```
   YYYY_subject_agency_type.extension
   Examples:
   - 2024_mathematics_army_pastquestions.pdf
   - 2024_english_navy_grammar.docx
   - 2024_currentaffairs_all_general.pdf
   ```

2. **Exercise Images**
   ```
   exercise_name_type_number.extension
   Examples:
   - pushups_form_demonstration.jpg
   - situps_step1.jpg
   - running_proper_technique.png
   ```

3. **Exercise Videos**
   ```
   exercise_name_type.extension
   Examples:
   - pushups_proper_form.mp4
   - running_technique_guide.mp4
   - military_drill_basic.mp4
   ```

### Content Organization Tips

1. **Use Consistent Folder Structure**
   - Always organize by category first, then agency
   - Keep folder names lowercase with underscores
   - Use descriptive but concise names

2. **Optimize File Sizes**
   - Compress images before upload (recommended: under 2MB)
   - Optimize videos for web (recommended: under 50MB)
   - Use appropriate formats (PDF for documents, JPG/PNG for images, MP4 for videos)

3. **Maintain Metadata**
   - Always add database entries for uploaded content
   - Use descriptive titles and descriptions
   - Add relevant tags for searchability
   - Set appropriate premium/free status

## 📱 How Flutter App Consumes Content

### Study Materials Display

The Flutter app retrieves study materials using:

```dart
final userStorage = UserStorageService();
final materials = await userStorage.getStudyMaterials(
  category: 'mathematics',
  targetAgency: 'nigerian_army',
  isPremiumOnly: false,
);
```

### Exercise Images Display

```dart
final exerciseImages = await userStorage.getWorkoutImages(
  workoutId: 'pushups-exercise',
);
```

### Exercise Videos Display

```dart
final exerciseVideos = await userStorage.getExerciseVideos(
  exerciseId: 'pushups-exercise',
);
```

## 🔐 Access Control

### Storage Bucket Policies

Ensure these RLS policies are in place:

```sql
-- Study materials: Read-only for authenticated users
CREATE POLICY "Authenticated users can view study materials" ON storage.objects
FOR SELECT USING (
  bucket_id = 'study-materials' 
  AND auth.role() = 'authenticated'
);

-- Workout images: Public read access
CREATE POLICY "Public read access to workout images" ON storage.objects
FOR SELECT USING (bucket_id = 'workout-images');

-- Exercise videos: Authenticated read access
CREATE POLICY "Authenticated users can view exercise videos" ON storage.objects
FOR SELECT USING (
  bucket_id = 'exercise-videos' 
  AND auth.role() = 'authenticated'
);
```

## 📊 Content Analytics

### Track Content Usage

Add these columns to track content performance:

```sql
-- Add to study_materials table
ALTER TABLE study_materials ADD COLUMN download_count INTEGER DEFAULT 0;
ALTER TABLE study_materials ADD COLUMN last_accessed TIMESTAMP WITH TIME ZONE;

-- Add to exercises table  
ALTER TABLE exercises ADD COLUMN view_count INTEGER DEFAULT 0;
ALTER TABLE exercises ADD COLUMN last_viewed TIMESTAMP WITH TIME ZONE;
```

### Monitor Popular Content

```sql
-- Most downloaded study materials
SELECT file_name, category, target_agency, download_count
FROM study_materials 
WHERE status = 'active'
ORDER BY download_count DESC
LIMIT 10;

-- Most viewed exercises
SELECT name, category, view_count
FROM exercises 
WHERE status = 'active'
ORDER BY view_count DESC
LIMIT 10;
```

## 🚀 Content Deployment Workflow

1. **Prepare Content**
   - Create/gather educational materials
   - Optimize file sizes and formats
   - Prepare metadata information

2. **Upload via Supabase Dashboard**
   - Upload files to appropriate storage buckets
   - Follow naming conventions
   - Organize in proper folder structure

3. **Add Database Metadata**
   - Insert records in appropriate tables
   - Set correct categories and agencies
   - Configure premium/free access

4. **Test in Flutter App**
   - Verify content appears correctly
   - Test download/viewing functionality
   - Check access controls work properly

5. **Monitor and Update**
   - Track content usage analytics
   - Update content based on user feedback
   - Remove outdated materials

This approach ensures clean separation between content management (Supabase dashboard) and content consumption (Flutter app), making it easier to manage and scale educational content for Nigerian military aspirants.
