@echo off
echo.
echo 📧 =================================
echo    Fit4Force Email Setup Helper
echo =================================
echo.
echo This script will help you set up EmailJS for your app.
echo.
echo ✅ STEP 1: Create EmailJS Account
echo    Go to: https://emailjs.com
echo    Sign up for FREE (200 emails/month)
echo.
pause
echo.
echo ✅ STEP 2: Connect Gmail Service  
echo    In EmailJS dashboard:
echo    - Click "Add New Service"
echo    - Choose "Gmail"
echo    - Connect your Gmail account
echo    - Copy the SERVICE ID that's generated
echo.
pause
echo.
echo ✅ STEP 3: Create Email Templates
echo    Create these 2 templates with EXACT IDs:
echo    1. template_welcome
echo    2. template_premium_upgrade
echo.
echo    📋 Template content is in: EMAILJS_SETUP_COMPLETE_GUIDE.md
echo.
pause
echo.
echo ✅ STEP 4: Get Your Public Key
echo    In EmailJS dashboard:
echo    - Go to "Integration" tab
echo    - Copy your PUBLIC KEY
echo.
pause
echo.
echo ✅ STEP 5: Update Your App Config
echo    Edit: lib\core\config\email_config.dart
echo    Replace:
echo    - emailJsServiceId: 'your_service_id_here'
echo    - emailJsPublicKey: 'your_public_key_here'
echo.
pause
echo.
echo ✅ STEP 6: Test Your Setup
echo    Run your app and:
echo    - Sign up with a test account
echo    - Check console for email logs
echo    - Check your email inbox
echo.
echo.
echo 🎉 DONE! Your email system is ready!
echo.
echo 📚 For detailed guide: EMAILJS_SETUP_COMPLETE_GUIDE.md
echo 📋 For quick reference: EMAILJS_QUICK_CHECKLIST.md
echo.
pause
