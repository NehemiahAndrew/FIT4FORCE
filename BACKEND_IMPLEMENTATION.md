# Fit4Force Backend Implementation

## 🎯 Overview

This document outlines the comprehensive Supabase backend implementation for the Fit4Force Flutter app, including real-time subscriptions, file storage, and push notifications.

## 🏗️ Architecture

### Core Services

1. **RealtimeService** (`lib/core/services/realtime_service.dart`)
   - Manages real-time subscriptions for live data updates
   - Handles community posts, comments, likes, workout progress, and leaderboards
   - Automatic subscription cleanup to prevent memory leaks

2. **StorageService** (`lib/core/services/storage_service.dart`)
   - Manages file uploads/downloads for images and media
   - Automatic image compression and optimization
   - Organized storage buckets for different file types

3. **NotificationService** (`lib/core/services/notification_service.dart`)
   - Handles push notifications via Supabase Edge Functions
   - User preference management
   - Notification history and read/unread tracking

4. **BackendServiceManager** (`lib/core/services/backend_service_manager.dart`)
   - Centralized coordinator for all backend services
   - Health monitoring and statistics
   - User subscription management

## 🔄 Real-time Features

### Community Real-time Updates
```dart
// Subscribe to posts
final postsStream = RealtimeService().subscribeToPosts();
postsStream.listen((update) {
  // Handle new posts, updates, deletions
});

// Subscribe to comments for a specific post
final commentsStream = RealtimeService().subscribeToComments(postId);
```

### Workout Progress Tracking
```dart
// Real-time workout progress for a user
final progressStream = RealtimeService().subscribeToWorkoutProgress(userId);
progressStream.listen((update) {
  // Update UI with live progress data
});
```

### Study Group Messages
```dart
// Real-time messages in study groups
final messagesStream = RealtimeService().subscribeToStudyGroupMessages(groupId);
```

## 📁 File Storage

### Storage Buckets
- `profile-images`: User avatars (5MB limit, public)
- `workout-images`: Exercise demonstration images (10MB limit, public)
- `post-images`: Community post images (10MB limit)
- `exercise-videos`: Video demonstrations (100MB limit)
- `documents`: Study materials (50MB limit)
- `study-materials`: Educational content (50MB limit)

### Usage Examples
```dart
final storageService = StorageService();

// Upload profile image with automatic compression
final imageUrl = await storageService.uploadProfileImage(
  userId, 
  imageData, 
  'profile.jpg'
);

// Upload workout video
final videoUrl = await storageService.uploadExerciseVideo(
  exerciseId, 
  videoData, 
  'demo.mp4'
);
```

### File Upload Widget
```dart
FileUploadWidget(
  uploadType: FileUploadType.profileImage,
  entityId: userId,
  onUploadComplete: (url) {
    // Handle successful upload
  },
  onUploadError: (error) {
    // Handle upload error
  },
)
```

## 🔔 Push Notifications

### Notification Types
- Community posts and replies
- Workout reminders
- Study group activities
- Achievement badges
- Premium subscription updates

### Implementation
```dart
final notificationService = NotificationService();

// Send workout reminder
await notificationService.sendWorkoutReminder(
  userId, 
  'Morning Cardio', 
  DateTime.now().add(Duration(hours: 1))
);

// Send achievement notification
await notificationService.sendAchievementNotification(
  userId, 
  'First Workout Complete!', 
  'You completed your first workout session'
);
```

### User Preferences
```dart
NotificationPreferencesWidget(
  userId: currentUserId,
  onPreferencesChanged: (preferences) {
    // Handle preference updates
  },
)
```

## 🧪 Development Testing

### Backend Test Suite
The `BackendTestSuite` class provides comprehensive testing for development:

```dart
// Run all backend tests (DEBUG MODE ONLY)
final testSuite = BackendTestSuite();
final results = await testSuite.runTests();
testSuite.logTestResults(results);

// Quick health check
final isHealthy = await testSuite.quickHealthCheck();
```

### Test Coverage
- Supabase connection verification
- Service manager initialization
- Database operations (CRUD)
- Real-time subscription functionality
- Storage operations
- Notification service

## 🔧 Configuration

### Supabase Setup
```dart
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
  
  // Table names
  static const String usersTable = 'users';
  static const String workoutsTable = 'workouts';
  // ... other tables
}
```

### Initialization
```dart
// In main.dart
await SupabaseConfig.initialize();
await BackendServiceManager().initialize();
```

## 📊 Database Schema

### Required Tables
- `users`: User profiles and preferences
- `workouts`: Workout definitions
- `exercises`: Exercise library
- `user_workouts`: User workout sessions
- `posts`: Community posts
- `comments`: Post comments
- `likes`: Post likes
- `notifications`: Push notifications
- `study_groups`: Study group information
- `study_group_messages`: Group messages
- `progress`: User progress tracking

### Storage Policies
```sql
-- Example RLS policy for profile images
CREATE POLICY "Users can upload their own profile images" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'profile-images' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## 🚀 Production Deployment

### Environment Variables
```dart
// Use environment-specific configurations
static String get supabaseUrl {
  return const String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: productionUrl,
  );
}
```

### Security Considerations
- Row Level Security (RLS) enabled on all tables
- Proper storage bucket policies
- API key rotation strategy
- User authentication required for sensitive operations

## 🔍 Monitoring & Analytics

### Service Statistics
```dart
final stats = await BackendServiceManager().getServiceStatistics();
// Returns comprehensive service health and usage data
```

### Health Checks
```dart
final health = await BackendServiceManager().healthCheck();
// Returns status of all backend services
```

## 📱 User Experience

### Seamless Integration
- Real-time updates without manual refresh
- Automatic image optimization for mobile
- Offline capability where applicable
- Progress indicators for file uploads
- User-friendly error handling

### Performance Optimization
- Image compression before upload
- Lazy loading of real-time subscriptions
- Automatic cleanup of unused subscriptions
- Efficient data pagination

## 🛠️ Development Guidelines

### Testing Approach
1. **Development Testing**: Use `BackendTestSuite` for comprehensive testing
2. **User Testing**: Focus on user-facing features, not backend internals
3. **Production**: All debug features automatically disabled

### Code Organization
- Services in `lib/core/services/`
- Testing in `lib/core/testing/`
- Widgets in `lib/shared/widgets/`
- Configuration in `lib/core/config/`

### Best Practices
- Always check `kDebugMode` for development features
- Use proper error handling and logging
- Implement cleanup for real-time subscriptions
- Follow Supabase security best practices
- Keep user-facing and development features separate

## 🎯 Next Steps

1. **Database Setup**: Create tables and configure RLS policies
2. **Edge Functions**: Deploy notification functions to Supabase
3. **Storage Policies**: Configure bucket access controls
4. **Testing**: Run comprehensive backend tests
5. **Integration**: Connect with existing app features
6. **Deployment**: Configure production environment

This implementation provides a robust, scalable backend for the Fit4Force app while maintaining clear separation between development tools and user-facing features.
