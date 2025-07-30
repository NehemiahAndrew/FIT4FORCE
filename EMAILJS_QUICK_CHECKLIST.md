# ✅ EmailJS Setup Checklist - Get Your FREE Email Service Running

## 📋 Quick Setup Checklist (15 Minutes Max!)

### ☐ **Step 1: Create EmailJS Account**
- [ ] Go to [EmailJS.com](https://www.emailjs.com)
- [ ] Sign up with Google (fastest option)
- [ ] Choose **FREE plan** (200 emails/month)

### ☐ **Step 2: Connect Your Email Service**
- [ ] Click **"Add New Service"**
- [ ] Choose **Gmail** (recommended)
- [ ] Connect your Gmail account
- [ ] **SAVE YOUR SERVICE ID** (looks like: service_xxxxxxx)

### ☐ **Step 3: Create Welcome Email Template**
- [ ] Go to **"Email Templates"**
- [ ] Click **"Create New Template"**
- [ ] Set Template ID: `template_welcome`
- [ ] Set Subject: `Welcome to {{app_name}}! 🎯`
- [ ] Copy the HTML from the setup guide
- [ ] **Test and Save**

### ☐ **Step 4: Create Premium Email Template**
- [ ] Create another template
- [ ] Set Template ID: `template_premium_upgrade`
- [ ] Set Subject: `Welcome to {{app_name}} Premium! ⭐`
- [ ] Copy the HTML from the setup guide
- [ ] **Test and Save**

### ☐ **Step 5: Get Your Credentials**
- [ ] Go to **"Account"** → **"General"**
- [ ] **COPY YOUR PUBLIC KEY** (starts with: user_xxxxxxx)
- [ ] **COPY YOUR SERVICE ID** (from step 2)

### ☐ **Step 6: Update Your App**
- [ ] Open `lib/core/config/email_config.dart`
- [ ] Replace `emailJsServiceId` with your Service ID
- [ ] Replace `emailJsPublicKey` with your Public Key
- [ ] Update your app URLs and support emails

### ☐ **Step 7: Test Everything**
- [ ] Run your app in debug mode
- [ ] Create a test account (check console for email logs)
- [ ] Check your actual email inbox
- [ ] Test premium upgrade flow

## 🚀 **Your Credentials Template**

Copy this and fill in your actual values:

```dart
// In lib/core/config/email_config.dart
class EmailConfig {
  static const String emailJsServiceId = 'service_YOUR_ID_HERE';
  static const String emailJsPublicKey = 'user_YOUR_KEY_HERE';
  
  // Update these with your actual info
  static const String supportEmail = 'your-email@gmail.com';
  static const String appUrl = 'https://yourapp.com';
  static const String loginUrl = 'https://yourapp.com/login';
}
```

## 🎯 **Quick Test Commands**

After setup, test with these:

```dart
// Test welcome email (add this temporarily to your app)
await EmailService.sendWelcomeEmail(
  userEmail: 'your-test-email@gmail.com',
  fullName: 'Test User',
);

// Test premium email
await EmailService.sendPremiumUpgradeEmail(
  userEmail: 'your-test-email@gmail.com',
  fullName: 'Test User',
  expiryDate: DateTime.now().add(Duration(days: 30)),
  isYearly: false,
  transactionReference: 'TEST_123',
);
```

## 🔥 **What You Get with FREE EmailJS:**

✅ **200 emails/month** (plenty to start)
✅ **Professional email delivery**
✅ **No backend server needed**
✅ **Real-time analytics**
✅ **Multiple email services** (Gmail, Outlook, etc.)
✅ **Custom templates**
✅ **API integration** (already coded in your app!)

## 🚨 **Troubleshooting Tips:**

**Email not sending?**
- Check Service ID and Public Key are correct
- Verify template IDs match exactly: `template_welcome` and `template_premium_upgrade`
- Make sure Gmail service is connected and active

**Template errors?**
- Copy HTML exactly from the guide
- Test templates in EmailJS dashboard first
- Check all variable names are correct

**App integration issues?**
- Enable debug mode to see console logs
- Check if `http` package is in pubspec.yaml (it is!)
- Verify email config file has correct values

## 🎉 **Ready to Go LIVE?**

Once everything works:
1. Your welcome emails will be sent automatically when users sign up
2. Premium emails will be sent when users upgrade
3. Monitor your EmailJS dashboard for delivery stats
4. Scale up your plan if you need more emails

**You're about to have the most LIT email system for a Nigerian military prep app! 🇳🇬💪**

---

**Need help? Drop a message and I'll help you troubleshoot! 🚀**
