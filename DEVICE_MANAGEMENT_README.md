# Device Management System - Fit4Force

## Overview

The Device Management System enforces a maximum of 2 concurrent device logins per user account in the Fit4Force Flutter app. This system provides security and prevents account sharing while allowing users to access their account from multiple legitimate devices.

## Features

- **Device Limit Enforcement**: Maximum 2 active devices per user
- **Device Registration**: Automatic device registration during sign-in/sign-up
- **Device Management UI**: User-friendly interface to manage registered devices
- **Device Identification**: Unique device fingerprinting using device characteristics
- **Automatic Cleanup**: Inactive devices are automatically cleaned up after 30 days
- **Security**: Row Level Security (RLS) policies ensure users can only manage their own devices

## Architecture

### Core Components

1. **DeviceIdService** (`lib/core/services/device_id_service.dart`)
   - Generates unique device identifiers
   - Uses device characteristics and installation UUID
   - Caches device ID for performance

2. **DeviceManagementService** (`lib/core/services/device_management_service.dart`)
   - Handles device registration, deactivation, and removal
   - Integrates with Supabase database functions
   - Manages device limit enforcement

3. **UserDeviceModel** (`lib/shared/models/user_device_model.dart`)
   - Data model for device information
   - Includes helper methods for formatting and validation

4. **AuthBloc Integration** (`lib/features/auth/bloc/auth_bloc.dart`)
   - Modified to include device management in authentication flow
   - Handles device limit exceeded scenarios

### Database Schema

The system uses a `user_devices` table in Supabase with the following structure:

```sql
CREATE TABLE user_devices (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    device_id VARCHAR(255) NOT NULL,
    device_name VARCHAR(255) NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(user_id, device_id)
);
```

### Database Functions

- `register_device()`: Registers a new device with limit enforcement
- `deactivate_device()`: Deactivates a device
- `remove_device()`: Completely removes a device
- `get_user_devices()`: Retrieves all devices for a user
- `cleanup_inactive_devices()`: Removes old inactive devices

## User Experience

### Authentication Flow

1. **Sign In/Sign Up**: Device is automatically registered
2. **Device Limit Check**: System checks if user has reached the 2-device limit
3. **Success**: If under limit, authentication completes normally
4. **Limit Exceeded**: User sees a dialog to remove an existing device

### Device Management Screen

Users can access device management through:
- Navigation drawer → "Device Management"
- Direct navigation to `/device-management`

The screen shows:
- List of all registered devices
- Device information (name, type, platform, last login)
- Current device indicator
- Remove device functionality (except for current device)

### Device Limit Dialog

When the device limit is exceeded, users see a dialog with:
- List of currently active devices
- Option to remove a device to make room for the new one
- Link to full device management screen

## Implementation Details

### Device ID Generation

The system generates unique device IDs using:
- Device model and manufacturer
- Platform information
- Installation-specific UUID
- Cryptographic hashing for consistency

```dart
static Future<String> _generateDeviceId() async {
  final deviceInfo = await getDeviceInfo();
  final installationId = await _getOrCreateInstallationId();
  
  final combined = '${deviceInfo['deviceModel']}_'
      '${deviceInfo['manufacturer']}_'
      '${deviceInfo['platform']}_'
      '$installationId';
      
  return sha256.convert(utf8.encode(combined)).toString();
}
```

### Error Handling

The system handles various error scenarios:
- Network connectivity issues
- Database constraint violations
- Malformed responses
- Device information unavailability

### Security Considerations

- **Row Level Security**: Users can only access their own device data
- **Device Fingerprinting**: Prevents simple device ID spoofing
- **Automatic Cleanup**: Removes stale device registrations
- **Audit Trail**: Tracks device login history

## Setup Instructions

### 1. Database Setup

Run the SQL script to set up the database schema:

```bash
# Execute the SQL script in your Supabase dashboard
cat supabase_device_management_setup.sql
```

### 2. Dependencies

Ensure these packages are in your `pubspec.yaml`:

```yaml
dependencies:
  device_info_plus: ^9.1.2
  shared_preferences: ^2.2.2
  crypto: ^3.0.3
  uuid: ^4.5.1
```

### 3. Configuration

Update your Supabase configuration to include the new table:

```dart
// lib/core/config/supabase_config.dart
static const String userDevicesTable = 'user_devices';
```

### 4. Navigation Setup

Add the device management route to your app routes:

```dart
// lib/core/config/app_routes.dart
static const String deviceManagement = '/device-management';

// In getRoutes():
deviceManagement: (context) => const DeviceManagementScreen(),
```

## Testing

Run the device management tests:

```bash
flutter test test/device_management_test.dart
```

The test suite covers:
- Device ID generation consistency
- Model serialization/deserialization
- Error handling scenarios
- Response parsing

## Usage Examples

### Register Current Device

```dart
final response = await DeviceManagementService.registerCurrentDevice(userId);
if (response.success) {
  // Device registered successfully
} else if (response.isDeviceLimitExceeded) {
  // Show device limit dialog
  showDeviceLimitDialog(response.activeDevices);
}
```

### Get User Devices

```dart
final devices = await DeviceManagementService.getUserDevices(userId);
for (final device in devices) {
  print('${device.deviceName} - ${device.platform}');
}
```

### Remove Device

```dart
final success = await DeviceManagementService.removeDevice(userId, deviceId);
if (success) {
  // Device removed successfully
}
```

## Monitoring and Maintenance

### Database Maintenance

Set up a periodic job to clean up inactive devices:

```sql
-- Run this periodically (e.g., daily)
SELECT cleanup_inactive_devices();
```

### Monitoring Queries

```sql
-- Check device distribution
SELECT 
  COUNT(*) as total_users,
  AVG(active_devices) as avg_devices_per_user
FROM user_device_summary;

-- Find users with maximum devices
SELECT user_id, active_devices 
FROM user_device_summary 
WHERE active_devices >= 2;
```

## Troubleshooting

### Common Issues

1. **Device ID Inconsistency**: Clear app data and re-register
2. **Database Constraint Errors**: Check for duplicate device registrations
3. **RLS Policy Issues**: Verify user authentication state
4. **Network Timeouts**: Implement retry logic with exponential backoff

### Debug Information

Enable logging to track device management operations:

```dart
// Add to your logging configuration
Logger.level = Level.debug;
```

## Future Enhancements

- **Device Trust Levels**: Mark trusted devices for extended sessions
- **Geolocation Tracking**: Track device locations for security
- **Push Notifications**: Notify users of new device registrations
- **Admin Dashboard**: Allow administrators to manage user devices
- **Device Analytics**: Track device usage patterns and statistics
