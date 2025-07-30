
# Email Service Setup and Usage Guide

This guide explains how to set up and use the email functionality in the Fit4Force app for welcome emails and premium upgrade confirmation emails.

## 📧 Email Service Features

The app includes automated email functionality for:

1. **Welcome Email** - Sent automatically when a user signs up
2. **Premium Upgrade Email** - Sent automatically when a user successfully upgrades to premium

## 🚀 Quick Setup

### Step 1: Choose an Email Service Provider

We recommend **EmailJS** for easy setup (free tier available):

1. Go to [EmailJS.com](https://www.emailjs.com)
2. Create a free account
3. Create a new email service (Gmail, Outlook, etc.)
4. Get your **Service ID** and **Public Key**

### Step 2: Create Email Templates

Create these templates in your EmailJS dashboard:

#### Welcome Email Template (`template_welcome`)
- Template ID: `template_welcome`
- Subject: `Welcome to {{app_name}}! 🎯`
- Use the HTML template from `EmailTemplates.welcomeEmailHtml`

#### Premium Upgrade Email Template (`template_premium_upgrade`)
- Template ID: `template_premium_upgrade`
- Subject: `Welcome to {{app_name}} Premium! ⭐`
- Use the HTML template from `EmailTemplates.premiumUpgradeEmailHtml`

### Step 3: Update Configuration

Update the values in `lib/core/config/email_config.dart`:

```dart
class EmailConfig {
  // Replace with your EmailJS credentials
  static const String emailJsServiceId = 'your_service_id_here';
  static const String emailJsPublicKey = 'your_public_key_here';
  
  // Update your app URLs
  static const String appUrl = 'https://yourapp.com';
  static const String loginUrl = 'https://yourapp.com/login';
  
  // Update support emails
  static const String supportEmail = 'support@yourapp.com';
  static const String premiumSupportEmail = 'premium@yourapp.com';
}
```

## � Full Email Body Samples

### 🎯 Welcome Email Content

The welcome email now includes this exciting content structure:

```
Hi [User's First Name],

Welcome to Fit4Force — Nigeria's first all-in-one mobile app built specially for military, paramilitary, and security service aspirants like YOU.

Whether you're preparing for the Nigerian Army, Navy, Air Force, Police, NSCDC, FRSC, or any other force, Fit4Force is your trusted companion.

---

🚀 What You Get (Free Plan):

✅ Access to workout routines
✅ Practice questions & flashcards  
✅ Basic educational content
✅ Motivational tips & career insights

---

🌟 Why Go Premium (Just ₦2,500/month):

📚 Full access to premium study materials (PDFs, quizzes, videos)
💪 Unlock exclusive fitness programs & meal plans
🎯 Access mock exams, flashcards & AI interview prep
🤖 Get support from the AI Assistant Coach & Study Bot
💬 Join the Aspirants' Forum (connect, ask & learn)
🎥 Watch video lessons directly from the app
🏆 Elite military-style workout challenges & competitions
📊 Advanced progress tracking & performance analytics
🎖️ Exclusive webinars with former military officers
📱 Offline access to all premium content
⚡ Priority customer support (24/7)
🔥 Access to "Success Stories" from selected candidates
📈 Personalized study plans based on your target force
🎪 Monthly live Q&A sessions with recruitment experts

> Premium = Everything you need to prepare, succeed & get selected.

💪 "Success in the military starts with the right preparation. You've taken the first step!" 🇳🇬
```

### ⭐ Premium Upgrade Email Content

```
🎉 Congratulations [First Name]!

Your [Monthly/Yearly] Premium subscription is now ACTIVE [+ savings message for yearly]

You're now part of an ELITE community of serious aspirants who are committed to getting SELECTED!

---

📋 Your Subscription Details:
• Plan: [Monthly/Yearly] Premium
• Valid Until: [Date]
• Transaction ID: [Reference]
• Status: ✅ ACTIVE

---

🚀 Your Premium Arsenal (Now Unlocked):

[Detailed breakdown of all premium features organized by categories]

---

🎯 Ready to DOMINATE your preparation?

Log in now and start accessing your premium features. Remember, every day counts in your preparation journey!

💪 Remember: You're not just preparing for a job, you're preparing to serve your nation. 

Make every study session count. Make every workout matter. Your future uniform is waiting! 🇳🇬
```

## 🔧 Usage

### Automatic Email Sending

Emails are sent automatically:

- **Welcome Email**: Triggered during user signup in `SupabaseAuthService.signUp()`
- **Premium Email**: Triggered after successful payment in `PaystackService._handleSuccessfulPayment()`

### Manual Email Sending

You can also send emails manually:

```dart
// Send welcome email
await EmailService.sendWelcomeEmail(
  userEmail: 'user@example.com',
  fullName: 'John Doe',
);

// Send premium upgrade email
await EmailService.sendPremiumUpgradeEmail(
  userEmail: 'user@example.com',
  fullName: 'John Doe',
  expiryDate: DateTime.now().add(Duration(days: 30)),
  isYearly: false,
  transactionReference: 'TXN_123456',
);
```

## 🧪 Testing

### Debug Mode
In debug mode, emails are logged to console instead of being sent. Check the debug output to verify email content.

### Test Widget
Use the `EmailTestWidget` for manual testing:

```dart
// Add to your app for testing (remove in production)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EmailTestWidget(),
  ),
);
```

## 🔧 Configuration Options

### Enable/Disable Emails

```dart
// In email_config.dart
static const bool enableWelcomeEmail = true;
static const bool enablePremiumUpgradeEmail = true;
```

### Customize Email Content

Modify the templates in `email_service.dart` or update the HTML templates in `EmailTemplates` class.

## 🌐 Production Setup

### Alternative Email Services

For production, consider these alternatives:

#### 1. SendGrid
```dart
// Update in email_service.dart
static const String _baseUrl = 'https://api.sendgrid.com/v3/mail/send';
// Add API key authentication
```

#### 2. AWS SES
```dart
// Use AWS SDK for Dart
// Configure SES in AWS console
```

#### 3. Custom Backend
```dart
// Point to your own email API
static const String _baseUrl = 'https://yourapi.com/send-email';
```

### Environment Variables

For production, use environment variables:

```dart
static String get emailApiKey => const String.fromEnvironment(
  'EMAIL_API_KEY',
  defaultValue: 'development_key',
);
```

## 📱 Email Templates

### Template Variables

Both templates support these variables:

**Common Variables:**
- `{{user_name}}` - User's full name
- `{{first_name}}` - User's first name only
- `{{user_email}}` - User's email address
- `{{app_name}}` - App name (Fit4Force)
- `{{app_url}}` - App website URL
- `{{login_url}}` - Login page URL
- `{{support_email}}` - Support email address

**Welcome Email Specific:**
- `{{welcome_message}}` - Personalized welcome message with app introduction
- `{{free_features}}` - List of free plan features
- `{{premium_features}}` - Detailed premium features with benefits
- `{{premium_call_to_action}}` - Premium upgrade call-to-action message

**Premium Email Specific:**
- `{{congratulations_message}}` - Personalized congratulations with subscription type
- `{{subscription_details}}` - Formatted subscription information
- `{{premium_features}}` - Detailed breakdown of unlocked premium features
- `{{call_to_action}}` - Action message to start using premium features
- `{{motivation_message}}` - Motivational message about serving the nation
- `{{expiry_date}}` - Subscription expiry date
- `{{transaction_reference}}` - Payment reference number

## 🎨 Customization

### Styling
- Modify CSS in `EmailTemplates` class
- Update brand colors to match your app
- Add your logo images

### Content
- Update feature lists in `EmailConfig`
- Customize email copy in `email_service.dart`
- Add more template variables as needed

## 🔍 Troubleshooting

### Common Issues

1. **Emails not sending**
   - Check EmailJS service ID and public key
   - Verify template IDs match exactly
   - Check console for error messages

2. **Template not found**
   - Ensure template exists in EmailJS dashboard
   - Check template ID spelling
   - Verify template is published

3. **Invalid email format**
   - Check user email validation
   - Ensure email addresses are properly formatted

### Debug Steps

1. Enable debug mode
2. Check console output for email data
3. Verify EmailJS dashboard for delivery status
4. Test with the `EmailTestWidget`

## 📞 Support

For email service issues:
- Check EmailJS documentation
- Test with simple email first
- Verify all configuration values
- Check network connectivity

## 🚀 Next Steps

1. Set up your EmailJS account
2. Create the email templates
3. Update the configuration
4. Test with the test widget
5. Deploy and monitor email delivery

Happy emailing! 📧✨
