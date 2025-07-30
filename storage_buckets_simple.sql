-- =====================================================
-- Fit4Force Storage Buckets Setup (SIMPLE VERSION)
-- =====================================================

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES
('study-materials', 'study-materials', false),
('profile-images', 'profile-images', true),
('workout-images', 'workout-images', true),
('post-images', 'post-images', false),
('exercise-videos', 'exercise-videos', false)
ON CONFLICT (id) DO NOTHING;

-- Verify buckets were created
SELECT 
  id,
  name,
  public,
  created_at
FROM storage.buckets 
WHERE id IN ('study-materials', 'profile-images', 'workout-images', 'post-images', 'exercise-videos')
ORDER BY name;

-- Show success message
SELECT 'SUCCESS: All 5 storage buckets created!' as result;
