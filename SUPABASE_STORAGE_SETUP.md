55555555555555555# Supabase Storage Setup for Fit4Force

## 🗂️ Storage Buckets Configuration

### Required Buckets

1. **profile-images** (Public)
   - User profile pictures
   - Max file size: 5MB
   - Allowed types: JPG, PNG, WebP

2. **workout-images** (Public)
   - Exercise demonstration images
   - Max file size: 10MB
   - Allowed types: JPG, PNG, WebP

3. **post-images** (Private)
   - Community post images
   - Max file size: 10MB
   - Allowed types: JPG, PNG, WebP

4. **exercise-videos** (Private)
   - Exercise demonstration videos
   - Max file size: 100MB
   - Allowed types: MP4, WebM, MOV

5. **study-materials** (Private)
   - Educational documents and materials
   - Max file size: 50MB
   - Allowed types: PDF, DOC, DOCX, TXT

6. **admin-content** (Private)
   - Admin-only content uploads
   - Max file size: 100MB
   - All file types allowed

## 🔐 Row Level Security (RLS) Policies

### 1. Profile Images Bucket Policies

```sql
-- Allow users to upload their own profile images
CREATE POLICY "Users can upload their own profile images" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to update their own profile images
CREATE POLICY "Users can update their own profile images" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to delete their own profile images
CREATE POLICY "Users can delete their own profile images" ON storage.objects
FOR DELETE USING (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow public read access to profile images
CREATE POLICY "Public read access to profile images" ON storage.objects
FOR SELECT USING (bucket_id = 'profile-images');
```

### 2. Workout Images Bucket Policies

```sql
-- Allow authenticated users to upload workout images
CREATE POLICY "Authenticated users can upload workout images" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'workout-images' 
  AND auth.role() = 'authenticated'
);

-- Allow public read access to workout images
CREATE POLICY "Public read access to workout images" ON storage.objects
FOR SELECT USING (bucket_id = 'workout-images');
```

### 3. Post Images Bucket Policies

```sql
-- Allow users to upload images for their own posts
CREATE POLICY "Users can upload post images" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'post-images' 
  AND auth.role() = 'authenticated'
);

-- Allow users to view post images
CREATE POLICY "Authenticated users can view post images" ON storage.objects
FOR SELECT USING (
  bucket_id = 'post-images' 
  AND auth.role() = 'authenticated'
);
```

### 4. Study Materials Bucket Policies (Admin Only)

```sql
-- Only admins can upload study materials
CREATE POLICY "Admins can upload study materials" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'study-materials' 
  AND EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- Authenticated users can view study materials
CREATE POLICY "Authenticated users can view study materials" ON storage.objects
FOR SELECT USING (
  bucket_id = 'study-materials' 
  AND auth.role() = 'authenticated'
);

-- Only admins can delete study materials
CREATE POLICY "Admins can delete study materials" ON storage.objects
FOR DELETE USING (
  bucket_id = 'study-materials' 
  AND EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);
```

### 5. Exercise Videos Bucket Policies (Admin Only)

```sql
-- Only admins can upload exercise videos
CREATE POLICY "Admins can upload exercise videos" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'exercise-videos' 
  AND EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);

-- Authenticated users can view exercise videos
CREATE POLICY "Authenticated users can view exercise videos" ON storage.objects
FOR SELECT USING (
  bucket_id = 'exercise-videos' 
  AND auth.role() = 'authenticated'
);
```

## 📋 Required Database Tables

### 1. User Roles Table

```sql
CREATE TABLE user_roles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'admin', 'super_admin')),
  assigned_by UUID REFERENCES auth.users(id),
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Enable RLS
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own role" ON user_roles
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Super admins can manage all roles" ON user_roles
FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role = 'super_admin'
  )
);
```

### 2. Study Materials Metadata Table

```sql
CREATE TABLE study_materials (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_name TEXT NOT NULL,
  category TEXT NOT NULL,
  target_agency TEXT NOT NULL,
  is_premium_only BOOLEAN DEFAULT FALSE,
  description TEXT,
  tags TEXT[],
  uploaded_by UUID REFERENCES auth.users(id),
  file_size BIGINT,
  content_type TEXT,
  public_url TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE study_materials ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Authenticated users can view active study materials" ON study_materials
FOR SELECT USING (
  auth.role() = 'authenticated' 
  AND status = 'active'
);

CREATE POLICY "Admins can manage study materials" ON study_materials
FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  )
);
```

### 3. Admin Access Logs Table

```sql
CREATE TABLE admin_access_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  permission TEXT NOT NULL,
  ip_address INET,
  user_agent TEXT,
  success BOOLEAN NOT NULL,
  error TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE admin_access_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policy
CREATE POLICY "Super admins can view access logs" ON admin_access_logs
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role = 'super_admin'
  )
);
```

## 🚀 Setup Instructions

### Step 1: Create Storage Buckets

1. Go to your Supabase dashboard
2. Navigate to **Storage** → **Buckets**
3. Create each bucket with these settings:

```javascript
// Example bucket creation (via Supabase Dashboard or API)
const buckets = [
  { name: 'profile-images', public: true },
  { name: 'workout-images', public: true },
  { name: 'post-images', public: false },
  { name: 'exercise-videos', public: false },
  { name: 'study-materials', public: false },
  { name: 'admin-content', public: false }
];
```

### Step 2: Enable RLS on Storage

1. Go to **Authentication** → **Policies**
2. Find **storage.objects** table
3. Enable RLS if not already enabled
4. Add the policies listed above

### Step 3: Create Database Tables

1. Go to **SQL Editor**
2. Run the SQL commands for each table above
3. Verify tables are created with proper RLS policies

### Step 4: Create Initial Super Admin

```sql
-- Insert your admin user (replace with actual user ID)
INSERT INTO user_roles (user_id, role, assigned_by)
VALUES ('your-user-id-here', 'super_admin', 'your-user-id-here');
```

### Step 5: Test Upload Functionality

1. Test profile image upload as regular user
2. Test study material upload as admin
3. Verify access controls work correctly

## 🔧 Flutter Integration

### Initialize Storage Service

```dart
// In your main.dart or app initialization
await EnhancedStorageService().initializeBuckets();
```

### Upload Examples

```dart
// Profile image upload
final storageService = EnhancedStorageService();
final imageUrl = await storageService.uploadProfileImage(
  userId,
  imageData,
  fileName,
  onProgress: (progress) => print('Progress: ${progress * 100}%'),
);

// Study material upload (admin only)
final documentUrl = await storageService.uploadStudyMaterial(
  fileName,
  fileData,
  category: 'mathematics',
  targetAgency: 'nigerian_army',
  isPremiumOnly: false,
  description: 'Mathematics past questions',
  tags: ['math', 'past-questions', 'algebra'],
);
```

## 🛡️ Security Best Practices

1. **Always validate file types and sizes on the client side**
2. **Use RLS policies to enforce server-side security**
3. **Regularly audit admin access logs**
4. **Implement file scanning for malicious content**
5. **Use signed URLs for private content**
6. **Set appropriate cache headers**
7. **Monitor storage usage and costs**

## 📊 Monitoring and Analytics

### Storage Usage Query

```sql
SELECT 
  bucket_id,
  COUNT(*) as file_count,
  SUM(metadata->>'size')::bigint as total_size_bytes
FROM storage.objects 
GROUP BY bucket_id;
```

### Admin Activity Query

```sql
SELECT 
  u.email,
  al.permission,
  al.success,
  al.timestamp
FROM admin_access_logs al
JOIN auth.users u ON al.user_id = u.id
ORDER BY al.timestamp DESC
LIMIT 100;
```

This setup provides a secure, scalable file upload system for the Fit4Force app with proper admin controls and user access management.
