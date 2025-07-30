# 🚀 **Complete Supabase Setup Guide for Fit4Force**

## **📋 Prerequisites**
- Supabase account created
- Fit4Force project credentials:
  - URL: `https://cgaxdkdvfxwuujnzfllu.supabase.co`
  - Anon Key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnYXhka2R2Znh3dXVqbnpmbGx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxNTkxOTYsImV4cCI6MjA2MzczNTE5Nn0.QbitrTrR7WETP9XVcau7ik6TXBg53RnSyUYS5fun9Tw`

## **🗄️ Database Setup (Required)**

### **Step 1: Run Main Schema**
1. Go to **Supabase Dashboard** → **SQL Editor**
2. Copy and paste the content from `supabase_setup_part1.sql`
3. Click **Run** to create core tables

### **Step 2: Run Additional Tables**
1. In **SQL Editor**, create a new query
2. Copy and paste the content from `supabase_setup_part2.sql`
3. Click **Run** to create additional tables and indexes

### **Step 3: Apply Security Policies**
1. In **SQL Editor**, create a new query
2. Copy and paste the content from `supabase_setup_part3_rls.sql`
3. Click **Run** to apply Row Level Security

## **✅ Verification Steps**

### **Check Tables Created:**
Go to **Table Editor** and verify these tables exist:
- ✅ `users` - User profiles
- ✅ `workouts` - Workout data
- ✅ `exercises` - Exercise library
- ✅ `posts` - Community posts
- ✅ `comments` - Post comments
- ✅ `likes` - User likes
- ✅ `subscriptions` - Premium subscriptions
- ✅ `notifications` - User notifications
- ✅ `progress` - Fitness progress tracking
- ✅ `user_workouts` - Workout sessions

### **Check Sample Data:**
1. Go to **Table Editor** → **workouts**
2. You should see 5 sample workouts
3. Go to **Table Editor** → **exercises**
4. You should see 5 sample exercises

## **🧪 Testing Authentication**

### **Test Signup Flow:**
1. Run the Flutter app: `flutter run -d chrome`
2. Navigate to signup screen
3. Fill in test data:
   ```
   Email: test@fit4force.com
   Password: testpass123
   Full Name: Test User
   Age: 25
   Gender: Male
   Height: 175
   Weight: 70
   Target Agency: Nigerian Army
   ```
4. Click "Create Account"

### **Verify in Supabase:**
1. **Authentication** → **Users**: Check for new user
2. **Table Editor** → **users**: Check for user profile
3. Both should have matching UUIDs

## **📊 Monitoring Dashboard**

### **Key Tables to Monitor:**

#### **Authentication Data:**
- **Location**: Authentication → Users
- **What to check**: Email, created_at, last_sign_in_at

#### **User Profiles:**
- **Location**: Table Editor → users
- **Key fields**: id, email, full_name, target_agency, is_premium

#### **User Activity:**
- **Location**: Table Editor → user_workouts
- **What to check**: Workout completions, progress

#### **Community Engagement:**
- **Location**: Table Editor → posts, comments, likes
- **What to check**: User interactions, content creation

## **🔧 Troubleshooting**

### **Common Issues:**

#### **"User profile not found"**
- **Cause**: Trigger didn't create profile
- **Fix**: Check if `handle_new_user()` trigger exists
- **Manual fix**: Insert user profile manually

#### **"Permission denied"**
- **Cause**: RLS policies blocking access
- **Fix**: Check RLS policies in SQL Editor
- **Debug**: Temporarily disable RLS for testing

#### **"Connection failed"**
- **Cause**: Network or credentials issue
- **Fix**: Verify URL and anon key in config

### **Debug Commands:**

```sql
-- Check if user profile exists
SELECT * FROM public.users WHERE email = 'test@fit4force.com';

-- Check RLS policies
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Disable RLS temporarily (for debugging only)
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;
```

## **🚀 Next Steps After Setup**

### **Immediate (Required):**
1. ✅ Run all 3 SQL setup files
2. ✅ Test signup/signin flow
3. ✅ Verify data appears in dashboard

### **Short Term (Recommended):**
1. 🔄 Implement real-time subscriptions
2. 📁 Set up file storage for images
3. 🔔 Configure push notifications

### **Long Term (Optional):**
1. 📊 Add analytics tracking
2. 🎯 Implement advanced features
3. 🔒 Enhanced security measures

## **📞 Support**

If you encounter issues:
1. Check the troubleshooting section above
2. Verify all SQL scripts ran successfully
3. Check browser console for errors
4. Verify Supabase project is active

## **🎯 Success Indicators**

You'll know the setup is successful when:
- ✅ All tables appear in Supabase dashboard
- ✅ User signup creates both auth user and profile
- ✅ App connects without errors
- ✅ Sample data is visible in tables
- ✅ Authentication flow works end-to-end

---

**🎉 Once complete, your Fit4Force app will have:**
- Full user authentication
- Secure data storage
- Real-time capabilities
- Scalable architecture
- Production-ready backend
