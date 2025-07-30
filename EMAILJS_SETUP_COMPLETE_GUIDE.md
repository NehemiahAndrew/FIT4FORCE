# 📧 Complete EmailJS Setup Guide - 100% FREE

## 🎯 Why EmailJS is Perfect for Fit4Force

- **FREE Plan**: 200 emails/month (perfect for getting started)
- **No Backend Needed**: Sends emails directly from your Flutter app
- **Easy Integration**: Already coded into your app - just need credentials
- **Professional**: Real email delivery, not just notifications

## 🚀 Step 1: Create EmailJS Account

1. Go to **[EmailJS.com](https://www.emailjs.com)**
2. Click **"Sign Up"** (top right)
3. Choose **"Continue with Google"** or use email
4. **Select FREE plan** (200 emails/month)

## 🔧 Step 2: Set Up Email Service

1. **Dashboard** → Click **"Add New Service"**
2. **Choose Gmail** (recommended) or Outlook
3. **Connect your Gmail account**:
   - Click "Connect Account"
   - Sign in with your Gmail
   - Allow EmailJS access
4. **Service ID** will be generated (copy this!)

## 📝 Step 3: Create Email Templates

### Welcome Email Template

1. **Dashboard** → **"Email Templates"** → **"Create New Template"**
2. **Template ID**: `template_welcome`
3. **Subject**: `Welcome to {{app_name}}! 🎯`
4. **Content**: Copy this HTML template:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Fit4Force! 🎯</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f5f5f5; line-height: 1.6; }
        .container { max-width: 600px; margin: 0 auto; background-color: white; }
        .header { background: linear-gradient(135deg, #4A80F0, #1A56E0); color: white; padding: 40px 20px; text-align: center; }
        .logo { font-size: 32px; font-weight: bold; margin-bottom: 10px; }
        .tagline { font-size: 14px; opacity: 0.9; }
        .content { padding: 30px 20px; }
        .welcome-section { margin-bottom: 30px; white-space: pre-line; }
        .features-section { background-color: #f8f9fa; padding: 25px; border-radius: 12px; margin: 25px 0; border-left: 5px solid #4A80F0; }
        .premium-section { background: linear-gradient(135deg, #FFD700, #FFA500); color: #333; padding: 25px; border-radius: 12px; margin: 25px 0; }
        .cta-button { display: inline-block; background: linear-gradient(135deg, #4A80F0, #1A56E0); color: white; padding: 15px 30px; text-decoration: none; border-radius: 25px; margin: 20px 0; font-weight: bold; font-size: 16px; }
        .motivational { background-color: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; font-style: italic; color: #2d5a2d; }
        .footer { background-color: #333; color: white; padding: 20px; text-align: center; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🎯 Fit4Force</div>
            <div class="tagline">Nigeria's Premier Military & Paramilitary Prep App</div>
        </div>
        
        <div class="content">
            <div class="welcome-section">{{welcome_message}}</div>
            
            <div class="features-section">
                <div style="font-size: 15px;">{{free_features}}</div>
            </div>
            
            <div class="premium-section">
                <div style="font-size: 15px; line-height: 1.7;">{{premium_features}}</div>
                
                <div style="margin-top: 20px; padding: 15px; background-color: rgba(255,255,255,0.9); border-radius: 8px; text-align: center;">
                    <strong style="font-size: 16px;">{{premium_call_to_action}}</strong>
                </div>
            </div>
            
            <div style="text-align: center;">
                <a href="{{login_url}}" class="cta-button">🚀 Start Your Journey Now</a>
            </div>
            
            <div class="motivational">
                💪 "Success in the military starts with the right preparation. You've taken the first step!" 🇳🇬
            </div>
            
            <p>Need help? Contact us at <a href="mailto:{{support_email}}">{{support_email}}</a></p>
            <p><strong>The Fit4Force Team</strong> 💪</p>
        </div>
        
        <div class="footer">
            <p>&copy; 2025 Fit4Force. All rights reserved.</p>
            <p><strong>Building tomorrow's heroes, one workout at a time.</strong> 🇳🇬</p>
        </div>
    </div>
</body>
</html>
```

### Premium Upgrade Email Template

1. **Create New Template**
2. **Template ID**: `template_premium_upgrade`
3. **Subject**: `Welcome to {{app_name}} Premium! ⭐`
4. **Content**: Copy this HTML template:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Fit4Force Premium! ⭐</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f5f5f5; line-height: 1.6; }
        .container { max-width: 600px; margin: 0 auto; background-color: white; }
        .header { background: linear-gradient(135deg, #FFD700, #FFA500); color: #333; padding: 40px 20px; text-align: center; }
        .premium-badge { background-color: rgba(255,255,255,0.9); padding: 10px 20px; border-radius: 20px; display: inline-block; margin-bottom: 15px; font-weight: bold; }
        .content { padding: 30px 20px; }
        .congratulations { background: linear-gradient(135deg, #4A80F0, #1A56E0); color: white; padding: 25px; border-radius: 12px; margin: 20px 0; text-align: center; white-space: pre-line; }
        .subscription-details { background-color: #f8f9fa; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 5px solid #FFD700; white-space: pre-line; }
        .features-grid { background: linear-gradient(135deg, #4A80F0, #1A56E0); color: white; padding: 25px; border-radius: 12px; margin: 20px 0; }
        .cta-section { background-color: #e8f5e8; padding: 25px; border-radius: 12px; margin: 20px 0; text-align: center; white-space: pre-line; }
        .cta-button { display: inline-block; background: linear-gradient(135deg, #4A80F0, #1A56E0); color: white; padding: 15px 30px; text-decoration: none; border-radius: 25px; margin: 15px 0; font-weight: bold; font-size: 16px; }
        .motivation { background: linear-gradient(135deg, #008000, #006400); color: white; padding: 20px; border-radius: 12px; margin: 20px 0; text-align: center; white-space: pre-line; }
        .footer { background-color: #333; color: white; padding: 20px; text-align: center; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="premium-badge">⭐ PREMIUM MEMBER ⭐</div>
            <h1>You're Now ELITE! 🏆</h1>
        </div>
        
        <div class="content">
            <div class="congratulations">{{congratulations_message}}</div>
            
            <div class="subscription-details">
                <h3>📋 Subscription Confirmed:</h3>
                {{subscription_details}}
            </div>
            
            <div class="features-grid">
                <h3 style="text-align: center; color: #FFD700; margin-bottom: 20px;">🎯 Your Premium Arsenal:</h3>
                <div style="font-size: 14px; line-height: 1.8;">{{premium_features}}</div>
            </div>
            
            <div class="cta-section">
                {{call_to_action}}
                <br>
                <a href="{{login_url}}" class="cta-button">🚀 Access Premium Features</a>
            </div>
            
            <div class="motivation">{{motivation_message}}</div>
            
            <p style="text-align: center;"><strong>Welcome to the ELITE circle!</strong><br>The Fit4Force Premium Team 💪🇳🇬</p>
        </div>
        
        <div class="footer">
            <p>&copy; 2025 Fit4Force Premium. All rights reserved.</p>
            <p><strong>Building tomorrow's heroes, one workout at a time.</strong> 🇳🇬</p>
        </div>
    </div>
</body>
</html>
```

## 🔑 Step 4: Get Your Credentials

1. **Dashboard** → **"Account"** → **"General"**
2. **Copy your Public Key** (starts with "user_...")
3. **Copy your Service ID** (from the service you created)

## ⚙️ Step 5: Update Your App Configuration

Open `lib/core/config/email_config.dart` and update:

```dart
class EmailConfig {
  // Replace with your actual EmailJS credentials
  static const String emailJsServiceId = 'service_xxxxxxx'; // Your Service ID here
  static const String emailJsPublicKey = 'user_xxxxxxxxxx'; // Your Public Key here
  
  // Template IDs (must match exactly)
  static const String welcomeTemplateId = 'template_welcome';
  static const String premiumUpgradeTemplateId = 'template_premium_upgrade';
  
  // Your app settings
  static const String supportEmail = 'support@fit4force.com';
  static const String premiumSupportEmail = 'premium@fit4force.com';
  static const String appUrl = 'https://fit4force.com';
  static const String loginUrl = 'https://fit4force.com/login';
}
```

## 🧪 Step 6: Test Your Email Integration

1. **Build and run your app**
2. **Create a test account** (this should trigger welcome email)
3. **Check your email** to see if the welcome email arrived
4. **Test premium upgrade** by upgrading a test account

## 🎉 Step 7: Go Live!

Once everything works:
1. **Switch from debug mode** to production in your app
2. **Monitor email delivery** in EmailJS dashboard
3. **Check spam folders** initially to ensure delivery
4. **Scale up** if you need more than 200 emails/month

## 💰 EmailJS Pricing (when you scale)

- **FREE**: 200 emails/month
- **Personal**: $15/month - 1,000 emails/month
- **Team**: $50/month - 10,000 emails/month

## 🔧 Alternative FREE Options

### Option 2: Supabase Email (100% Free)
- Use Supabase Edge Functions
- Completely free with your existing Supabase setup
- Requires more coding but unlimited emails

### Option 3: Firebase Functions + SendGrid
- Firebase has free tier
- SendGrid gives 100 free emails/day
- More complex setup but very reliable

## 📞 Need Help?

If you get stuck:
1. Check the EmailJS documentation
2. Test with simple templates first
3. Verify your service is connected properly
4. Check browser network tab for API calls

**Ready to send those LIT emails? Let's make it happen!** 🚀📧
