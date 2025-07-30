@echo off
echo.
echo 🌐 Preparing Fit4Force Legal Documents for InfinityFree
echo ========================================================
echo.

REM Check if docs directory exists
if not exist "docs" (
    echo ❌ Error: 'docs' directory not found!
    echo    Make sure you're running this script from the project root.
    pause
    exit /b 1
)

REM Create output directory
if exist "infinityfree_upload" (
    echo 🗑️  Removing existing infinityfree_upload directory...
    rmdir /s /q "infinityfree_upload"
)

mkdir "infinityfree_upload"
echo 📁 Created infinityfree_upload directory
echo.

REM Copy files (exclude GitHub-specific files)
echo 📄 Copying legal document files...

copy "docs\index.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\index.html" echo ✅ Copied: index.html

copy "docs\terms-of-service.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\terms-of-service.html" echo ✅ Copied: terms-of-service.html

copy "docs\privacy-policy.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\privacy-policy.html" echo ✅ Copied: privacy-policy.html

copy "docs\cookie-policy.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\cookie-policy.html" echo ✅ Copied: cookie-policy.html

copy "docs\disclaimer.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\disclaimer.html" echo ✅ Copied: disclaimer.html

copy "docs\contact.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\contact.html" echo ✅ Copied: contact.html

copy "docs\refund-policy.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\refund-policy.html" echo ✅ Copied: refund-policy.html

copy "docs\data-retention-security.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\data-retention-security.html" echo ✅ Copied: data-retention-security.html

copy "docs\community-policy.html" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\community-policy.html" echo ✅ Copied: community-policy.html

copy "docs\styles.css" "infinityfree_upload\" >nul 2>&1
if exist "infinityfree_upload\styles.css" echo ✅ Copied: styles.css

echo.
echo ========================================================
echo 📋 DEPLOYMENT SUMMARY
echo ========================================================
echo 📁 Files prepared in: infinityfree_upload\
echo.
echo 📝 Files ready for upload:
dir /b "infinityfree_upload"
echo.
echo 🚀 NEXT STEPS:
echo 1. Upload all files from 'infinityfree_upload' folder to your InfinityFree /htdocs/ directory
echo 2. Use FileZilla or InfinityFree File Manager
echo 3. Update your Flutter app with your InfinityFree domain URL
echo 4. Test all legal document links
echo.
echo 📖 For detailed instructions, see: INFINITYFREE_DEPLOYMENT.md
echo 🎉 Your legal documents are ready for InfinityFree deployment!
echo.
pause
