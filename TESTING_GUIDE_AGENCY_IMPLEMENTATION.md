# Testing Guide: Agency-Specific Educational Content Implementation

## 🎯 Testing Overview

This guide provides comprehensive testing steps to verify that the agency-specific educational content system works correctly in the Fit4Force app.

## 🗄️ Prerequisites

### **1. Database Setup**
Before testing, ensure you have:

```sql
-- Run these SQL scripts in your Supabase project:
1. supabase_educational_content_schema.sql
2. supabase_educational_content_rls.sql  
3. supabase_educational_content_data.sql
```

### **2. Storage Buckets**
Verify these buckets exist in Supabase Storage:
- `profile-images` (public)
- `workout-images` (public)
- `post-images` (private)
- `study-materials` (private)
- `exercise-videos` (private)

### **3. Flutter Dependencies**
Ensure all new dependencies are installed:
```bash
flutter pub get
```

## 🧪 Test Cases

### **Test 1: Agency Selection During Sign-Up**

#### **Steps:**
1. Open the app and navigate to sign-up screen
2. Fill in all required fields
3. Check the "Target Agency" dropdown

#### **Expected Results:**
- ✅ Dropdown loads with all 11 agencies
- ✅ Each agency shows both short name and full name
- ✅ Icons display correctly for each agency
- ✅ Validation works (required field)
- ✅ Selection updates the displayed agency info

#### **Test Data:**
```
Test with these agencies:
- Nigerian Army
- Nigerian Navy  
- Nigerian Air Force
- NDA
- DSSC/SSC
- POLAC
- Fire Service
- NSCDC
- Customs Service
- Immigration
- FRSC
```

### **Test 2: Account Creation with Agency**

#### **Steps:**
1. Complete sign-up with "Nigerian Army" selected
2. Check database records after successful registration

#### **Expected Results:**
- ✅ User record created in `users` table
- ✅ User preferences record created in `user_preferences` table
- ✅ `target_agency_id` correctly links to Nigerian Army
- ✅ Default preferences set correctly

#### **Database Verification:**
```sql
-- Check user preferences
SELECT 
  up.*,
  a.name as agency_name,
  a.code as agency_code
FROM user_preferences up
JOIN agencies a ON up.target_agency_id = a.id
WHERE up.user_id = 'your-user-id';
```

### **Test 3: Content Filtering by Agency**

#### **Steps:**
1. Sign up as Nigerian Army aspirant
2. Navigate to prep dashboard
3. Check available categories

#### **Expected Results:**
- ✅ Only Army-specific categories visible:
  - General Knowledge
  - Aptitude Test
  - Screening/Training
  - Ranks & Structure
  - Interview Prep
- ✅ No Navy, Air Force, or other agency categories

#### **Comparison Test:**
1. Create second account with "Nigerian Navy" selected
2. Compare categories with Army account
3. Verify different categories appear

### **Test 4: Study Materials Access**

#### **Steps:**
1. Login as Nigerian Army user
2. Tap on "General Knowledge" category
3. Check displayed materials

#### **Expected Results:**
- ✅ Only Army-related materials visible
- ✅ Materials show correct metadata (agency, category)
- ✅ Premium content properly marked
- ✅ No Navy/Air Force materials visible

#### **RLS Verification:**
```sql
-- This should only return Army materials for Army user
SELECT 
  sm.title,
  a.name as agency,
  cs.name as section
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
JOIN content_sections cs ON sm.section_id = cs.id
WHERE sm.is_active = true;
```

### **Test 5: Premium Content Access**

#### **Steps:**
1. Login as free user (Nigerian Army)
2. Try to access premium materials
3. Update user to premium status
4. Retry access

#### **Expected Results:**
- ✅ Free user sees premium materials but cannot access
- ✅ Premium upgrade prompt appears
- ✅ Premium user can access all content
- ✅ Content filtering still respects agency boundaries

#### **Premium Status Update:**
```sql
-- Make user premium for testing
UPDATE user_preferences 
SET is_premium = true 
WHERE user_id = 'your-user-id';
```

### **Test 6: Progress Tracking**

#### **Steps:**
1. Open a study material
2. Mark as "in progress"
3. Add some progress percentage
4. Check database records

#### **Expected Results:**
- ✅ Progress record created in `user_study_progress`
- ✅ Status updates correctly
- ✅ Progress percentage saves
- ✅ Timestamps update properly

#### **Progress Verification:**
```sql
-- Check progress tracking
SELECT 
  usp.*,
  sm.title as material_title
FROM user_study_progress usp
JOIN study_materials sm ON usp.material_id = sm.id
WHERE usp.user_id = 'your-user-id';
```

### **Test 7: Rating System**

#### **Steps:**
1. Open study material detail screen
2. Rate material (1-5 stars)
3. Add review text
4. Submit rating

#### **Expected Results:**
- ✅ Rating saves to `content_ratings` table
- ✅ Material's average rating updates
- ✅ User can update their rating
- ✅ Rating displays correctly

### **Test 8: Cross-Agency Isolation**

#### **Steps:**
1. Create users for different agencies
2. Try to access each other's content
3. Verify isolation

#### **Expected Results:**
- ✅ Army user cannot see Navy content
- ✅ Navy user cannot see Air Force content
- ✅ API calls return empty for wrong agency
- ✅ Direct URL access blocked by RLS

### **Test 9: Agency Change (Future Feature)**

#### **Steps:**
1. Login as Nigerian Army user
2. Change agency to Nigerian Navy in settings
3. Check content updates

#### **Expected Results:**
- ✅ Content immediately updates to Navy materials
- ✅ Previous progress preserved
- ✅ New agency categories appear
- ✅ Old agency content disappears

## 🔧 Debugging Tools

### **Database Queries for Testing**

```sql
-- Check user's agency
SELECT 
  u.email,
  a.name as agency,
  up.is_premium
FROM users u
JOIN user_preferences up ON u.id = up.user_id
JOIN agencies a ON up.target_agency_id = a.id
WHERE u.email = 'test@example.com';

-- Check content access
SELECT 
  sm.title,
  a.name as agency,
  cs.name as section,
  sm.is_premium
FROM study_materials sm
JOIN agencies a ON sm.agency_id = a.id
JOIN content_sections cs ON sm.section_id = cs.id
WHERE a.code = 'army'
ORDER BY cs.display_order, sm.title;

-- Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('study_materials', 'user_preferences', 'content_sections');
```

### **Flutter Debug Commands**

```dart
// Check user's agency in Flutter
final userAgency = await enhancedService.getUserAgency();
print('User Agency: ${userAgency?['agencies']?['name']}');

// Check available materials
final materials = await enhancedService.getAllMaterials();
print('Available Materials: ${materials.length}');
materials.forEach((m) => print('- ${m.title} (${m.agency})'));

// Check categories
final categories = await enhancedService.getAgencyCategories();
print('Available Categories: ${categories.length}');
categories.forEach((c) => print('- ${c.name}'));
```

## 🚨 Common Issues & Solutions

### **Issue 1: No Content Visible**
**Cause:** User preferences not created or agency ID mismatch
**Solution:** 
```sql
-- Check if user preferences exist
SELECT * FROM user_preferences WHERE user_id = 'user-id';

-- Recreate if missing
INSERT INTO user_preferences (user_id, target_agency_id, is_premium)
SELECT 'user-id', id, false FROM agencies WHERE code = 'army';
```

### **Issue 2: Wrong Content Showing**
**Cause:** RLS policies not working or incorrect agency assignment
**Solution:**
```sql
-- Verify RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'study_materials';

-- Check user's actual agency
SELECT a.code FROM user_preferences up
JOIN agencies a ON up.target_agency_id = a.id
WHERE up.user_id = auth.uid();
```

### **Issue 3: Premium Content Not Working**
**Cause:** Premium status not set or RLS policy issue
**Solution:**
```sql
-- Check premium status
SELECT is_premium FROM user_preferences WHERE user_id = 'user-id';

-- Update premium status
UPDATE user_preferences SET is_premium = true WHERE user_id = 'user-id';
```

## ✅ Test Checklist

- [ ] Agency dropdown loads correctly in sign-up
- [ ] User preferences created on registration
- [ ] Content filtered by agency after login
- [ ] Premium content access controlled properly
- [ ] Progress tracking works for accessible materials
- [ ] Rating system functions correctly
- [ ] Cross-agency isolation enforced
- [ ] Database queries return expected results
- [ ] RLS policies active and working
- [ ] Error handling works for edge cases

## 🎯 Success Criteria

The implementation is successful when:

1. **Users see only their agency's content** throughout the app
2. **Sign-up process includes agency selection** and creates proper records
3. **Content filtering happens automatically** without manual intervention
4. **Premium content access** is properly controlled
5. **Progress tracking and ratings** work within agency boundaries
6. **Database security** prevents cross-agency access
7. **Performance is acceptable** with proper indexing
8. **Error handling** provides clear feedback to users

## 📊 Performance Testing

### **Load Testing Queries**
```sql
-- Test query performance
EXPLAIN ANALYZE 
SELECT sm.* FROM study_materials sm
JOIN user_preferences up ON sm.agency_id = up.target_agency_id
WHERE up.user_id = 'test-user-id' AND sm.is_active = true;

-- Check index usage
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes 
WHERE tablename IN ('study_materials', 'user_preferences');
```

This comprehensive testing guide ensures that the agency-specific educational content system works correctly and provides the expected personalized experience for Fit4Force users.
