# Fit4Force - Nigerian Military Recruitment Preparation App

![Fit4Force Logo](assets/images/fit4force_logo.png)

## 📱 Project Overview

**Fit4Force** is a comprehensive Flutter mobile application designed to help Nigerian military aspirants prepare for recruitment into various security agencies. The app combines study materials, fitness training, community features, and AI-powered learning assistance to provide a complete preparation experience.

### 🎯 Target Agencies
- **Nigerian Army** - Land forces recruitment preparation
- **Nigerian Navy** - Naval forces recruitment preparation
- **Nigerian Air Force** - Air force recruitment preparation
- **Nigerian Defence Academy (NDA)** - Officer cadet training preparation
- **Defence Space Staff College (DSSC/SSC)** - Staff college preparation
- **Police Academy (POLAC)** - Police force recruitment preparation
- **Fire Service** - Federal fire service recruitment preparation
- **Nigerian Security and Civil Defence Corps (NSCDC)** - Civil defence preparation
- **Nigeria Customs Service** - Customs recruitment preparation
- **Nigeria Immigration Service** - Immigration recruitment preparation
- **Federal Road Safety Corps (FRSC)** - Road safety corps preparation

### ✨ Key Features
- **📚 Study Materials**: Agency-specific educational content (PDFs, videos)
- **💪 Fitness Training**: Workout categories with exercise demonstrations
- **👥 Community**: Forums, study groups, and success stories
- **🤖 AI Learning Assistant**: Premium DeepSeek R1 AI integration for personalized learning
- **📊 Progress Tracking**: Performance analytics and study progress monitoring
- **⏰ Pomodoro Timer**: Focused study sessions with break management
- **🏆 Achievement System**: Badges and milestones for motivation
- **💳 Premium Subscription**: Advanced features for ₦2,500/month

## 📁 Content Management

### 📚 Study Materials Management

#### File Format Requirements
- **PDFs**: `.pdf` format, max 50MB per file
- **Videos**: `.mp4`, `.mov`, `.avi` formats, max 200MB per file
- **Images**: `.png`, `.jpg`, `.jpeg` formats for thumbnails

#### Folder Structure
```
assets/
├── content/
│   ├── nigerian_army/
│   │   ├── general_knowledge/
│   │   ├── aptitude_test/
│   │   ├── training_insight/
│   │   └── physical_fitness/
│   ├── navy/
│   │   ├── general_knowledge/
│   │   ├── aptitude_test/
│   │   ├── training_insight/
│   │   └── physical_fitness/
│   └── [other_agencies]/
│       ├── general_knowledge/
│       ├── aptitude_test/
│       ├── training_insight/
│       └── physical_fitness/
```

#### Naming Conventions
```
Format: [agency]_[category]_[topic]_[version].[extension]
Examples:
- nigerian_army_general_knowledge_history_v1.pdf
- navy_aptitude_test_mathematics_v2.pdf
- air_force_training_insight_pilot_basics_v1.mp4
```

#### Adding New Study Materials

1. **Place files in correct directory**:
```bash
# Example: Adding Nigerian Army general knowledge material
cp new_material.pdf assets/content/nigerian_army/general_knowledge/
```

2. **Update pubspec.yaml**:
```yaml
flutter:
  assets:
    - assets/content/nigerian_army/general_knowledge/
    - assets/content/navy/aptitude_test/
    # Add new directories as needed
```

3. **Update study material service**:
```dart
// In lib/features/prep/services/enhanced_study_material_service.dart
final List<StudyMaterial> _nigerianArmyMaterials = [
  StudyMaterial(
    id: 'na_gk_001',
    title: 'Nigerian History Overview',
    category: 'General Knowledge',
    agency: 'Nigerian Army',
    filePath: 'assets/content/nigerian_army/general_knowledge/nigerian_army_general_knowledge_history_v1.pdf',
    fileType: 'PDF',
    description: 'Comprehensive overview of Nigerian history for recruitment preparation',
    difficulty: 'Intermediate',
    estimatedReadTime: 45,
  ),
  // Add more materials here
];
```

4. **Supabase Storage Integration**:
```dart
// Upload to Supabase storage bucket
final storageService = SupabaseStorageService();
await storageService.uploadFile(
  bucketName: 'study-materials',
  filePath: localFilePath,
  fileName: 'nigerian_army_general_knowledge_history_v1.pdf',
);
```

### 🏋️ Workout Images Management

#### Image Requirements
- **Format**: PNG or JPG
- **Dimensions**: 800x600px (recommended)
- **Size**: Max 2MB per image
- **Quality**: High resolution for clear exercise demonstrations

#### Exercise Images Folder Structure
```
assets/
├── images/
│   ├── exercises/
│   │   ├── fat_loss_hiit/
│   │   │   ├── jumping_jacks.png
│   │   │   ├── mountain_climbers.png
│   │   │   ├── burpees.png
│   │   │   └── high_knees.png
│   │   ├── strength_building/
│   │   │   ├── push_ups.png
│   │   │   ├── pull_ups.png
│   │   │   ├── squats.png
│   │   │   └── lunges.png
│   │   ├── military_fitness/
│   │   │   ├── bear_crawls.png
│   │   │   ├── sandbag_carries.png
│   │   │   ├── tire_flips.png
│   │   │   └── wall_climbs.png
│   │   └── core_flexibility/
│   │       ├── plank.png
│   │       ├── russian_twists.png
│   │       ├── bicycle_crunches.png
│   │       └── leg_raises.png
```

#### Adding New Exercise Images

1. **Add images to appropriate category folder**:
```bash
# Example: Adding new strength building exercise
cp deadlifts.png assets/images/exercises/strength_building/
```

2. **Update pubspec.yaml**:
```yaml
flutter:
  assets:
    - assets/images/exercises/fat_loss_hiit/
    - assets/images/exercises/strength_building/
    - assets/images/exercises/military_fitness/
    - assets/images/exercises/core_flexibility/
```

3. **Link images to exercises in code**:
```dart
// In lib/features/fitness/screens/fitness_screen.dart
final exercises = [
  {
    'name': 'Deadlifts',
    'category': 'Strength Building',
    'image': 'assets/images/exercises/strength_building/deadlifts.png',
    'description': 'Compound exercise targeting multiple muscle groups',
    'sets': 3,
    'reps': '8-12',
    'restTime': '90 seconds',
  },
  // Add more exercises here
];
```

4. **Create exercise model**:
```dart
// In lib/features/fitness/models/exercise_model.dart
class ExerciseModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final String description;
  final int sets;
  final String reps;
  final String restTime;
  final String? videoUrl;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.sets,
    required this.reps,
    required this.restTime,
    this.videoUrl,
  });
}
```

## 🛠️ Technical Setup

### Prerequisites
- **Flutter SDK**: 3.24.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Android Studio**: Latest version with Android SDK 34+
- **NDK**: Version 27.0.12077973
- **CMake**: For tflite_flutter AI functionality
- **Git**: For version control

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.5.6
  tflite_flutter: ^0.10.4
  http: ^1.2.1
  path: ^1.9.0
  uuid: ^4.4.0
  logger: ^2.3.0
  connectivity_plus: ^6.0.3
  wakelock_plus: ^1.2.5
```

### Installation Steps

1. **Clone the repository**:
```bash
git clone https://github.com/your-repo/fit4force.git
cd fit4force
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Configure Supabase**:
```dart
// In lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://cgaxdkdvfxwuujnzfllu.supabase.co';
  static const String supabaseAnonKey = 'your_anon_key_here';
  static const String supabaseServiceRoleKey = 'your_service_role_key_here';
}
```

4. **Set up asset directories**:
```bash
mkdir -p assets/images/exercises/{fat_loss_hiit,strength_building,military_fitness,core_flexibility}
mkdir -p assets/content/{nigerian_army,navy,air_force,nda,dssc,polac,fire_service,nscdc,customs,immigration,frsc}/{general_knowledge,aptitude_test,training_insight,physical_fitness}
```

### Building Android APK

1. **Configure Android settings**:
```bash
# In android/app/build.gradle
android {
    compileSdkVersion 34
    ndkVersion "27.0.12077973"

    defaultConfig {
        targetSdkVersion 34
        minSdkVersion 26
    }
}
```

2. **Build APK**:
```bash
flutter build apk --release
```

3. **Build App Bundle** (for Play Store):
```bash
flutter build appbundle --release
```

## 🏗️ Development Guidelines

### Code Structure
```
lib/
├── core/                 # Core functionality
│   ├── config/          # Configuration files
│   ├── services/        # Core services
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── home/           # Dashboard
│   ├── prep/           # Study preparation
│   ├── fitness/        # Workout features
│   ├── community/      # Social features
│   └── ai/             # AI functionality
└── shared/             # Shared components
    ├── models/         # Data models
    ├── services/       # Shared services
    └── widgets/        # Reusable widgets
```

### Adding New Features

1. **Create feature directory**:
```bash
mkdir -p lib/features/new_feature/{models,screens,services,widgets}
```

2. **Follow naming conventions**:
```dart
// Screens: [feature_name]_screen.dart
// Services: [feature_name]_service.dart
// Models: [feature_name]_model.dart
// Widgets: [feature_name]_widget.dart
```

3. **Use dependency injection**:
```dart
// Register in lib/core/di/service_locator.dart
void setupServiceLocator() {
  serviceLocator.registerLazySingleton<NewFeatureService>(
    () => NewFeatureService(),
  );
}
```

### Testing Procedures

1. **Unit Tests**:
```bash
flutter test
```

2. **Integration Tests**:
```bash
flutter test integration_test/
```

3. **Device Testing**:
```bash
flutter run -d [device_id]
```

## 📦 Asset Management

### Complete Directory Structure
```
assets/
├── images/
│   ├── fit4force_logo.png
│   ├── fit4force_shield.png
│   ├── exercises/
│   ├── icons/
│   └── content/
├── animations/
├── fonts/
└── content/
    ├── nigerian_army/
    ├── navy/
    ├── air_force/
    ├── nda/
    ├── dssc/
    ├── polac/
    ├── fire_service/
    ├── nscdc/
    ├── customs/
    ├── immigration/
    └── frsc/
```

### File Size Limitations
- **Images**: Max 2MB per file
- **PDFs**: Max 50MB per file
- **Videos**: Max 200MB per file
- **Total app size**: Keep under 150MB for optimal download

### Optimization Recommendations

1. **Image Optimization**:
```bash
# Use tools like ImageOptim or TinyPNG
# Compress images before adding to assets
```

2. **PDF Optimization**:
```bash
# Use PDF compression tools
# Remove unnecessary metadata
# Optimize for mobile viewing
```

3. **Video Optimization**:
```bash
# Use H.264 codec
# Resolution: 720p maximum
# Bitrate: 1-2 Mbps for good quality/size balance
```

### Backup Procedures

1. **Version Control**:
```bash
git add assets/
git commit -m "Add new study materials for [agency]"
git push origin main
```

2. **Supabase Backup**:
```bash
# Regular database backups
# Storage bucket synchronization
# Environment configuration backup
```

## 🚀 Deployment Process

### Development Deployment
```bash
flutter run -d chrome  # Web testing
flutter run -d android # Android testing
```

### Production Deployment
```bash
# Build release APK
flutter build apk --release --target-platform android-arm64

# Build for Play Store
flutter build appbundle --release
```

### Environment Configuration
```dart
// lib/core/config/environment_config.dart
class EnvironmentConfig {
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String deepSeekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');
}
```

## 🔧 Troubleshooting

### Common Issues

1. **Build Errors**:
```bash
flutter clean
flutter pub get
flutter build apk
```

2. **Asset Loading Issues**:
```yaml
# Ensure assets are properly declared in pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/content/
```

3. **Supabase Connection Issues**:
```dart
// Check network connectivity
// Verify API keys
// Test with simple query
```

## 📞 Support

For technical support or content management questions:
- **Email**: fit4force1@gmail.com
- **Company**: Nehemiah Technologies
- **Documentation**: Check inline code comments
- **Issues**: Create GitHub issues for bugs

---

**© 2025 Nehemiah Technologies. All rights reserved.**
