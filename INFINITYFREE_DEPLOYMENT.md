# 🌐 Deploy Fit4Force Legal Documents to InfinityFree

## 📋 **What You'll Need:**
- InfinityFree account (free)
- FTP client (FileZilla recommended)
- Your legal documents from the `docs/` folder

## 🚀 **Step-by-Step Deployment Guide:**

### **Step 1: Set Up InfinityFree Account**

1. **Sign up at InfinityFree:**
   - Go to https://infinityfree.net/
   - Click "Sign Up" and create your account
   - Verify your email address

2. **Create a new website:**
   - Login to your InfinityFree control panel
   - Click "Create Account"
   - Choose a subdomain (e.g., `fit4force-legal.infinityfreeapp.com`)
   - Or use your own domain if you have one

3. **Note your website details:**
   - Website URL: `https://yoursite.infinityfreeapp.com`
   - FTP Hostname: Usually `ftpupload.net`
   - FTP Username: Provided in control panel
   - FTP Password: Provided in control panel

### **Step 2: Prepare Files for Upload**

1. **Copy all files from `docs/` folder:**
   ```
   docs/
   ├── index.html
   ├── terms-of-service.html
   ├── privacy-policy.html
   ├── cookie-policy.html
   ├── disclaimer.html
   ├── contact.html
   ├── refund-policy.html
   ├── data-retention-security.html
   ├── community-policy.html
   └── styles.css
   ```

2. **Remove GitHub-specific files** (not needed for InfinityFree):
   - `_config.yml`
   - `README.md`

### **Step 3: Upload Files via FTP**

#### **Option A: Using FileZilla (Recommended)**

1. **Download FileZilla:**
   - Go to https://filezilla-project.org/
   - Download FileZilla Client (free)

2. **Connect to your InfinityFree account:**
   - Host: `ftpupload.net` (or your specific FTP hostname)
   - Username: Your FTP username from InfinityFree
   - Password: Your FTP password from InfinityFree
   - Port: 21

3. **Upload files:**
   - Navigate to `/htdocs/` folder on the server
   - Upload all files from your `docs/` folder
   - Make sure `index.html` is in the root `/htdocs/` directory

#### **Option B: Using InfinityFree File Manager**

1. **Access File Manager:**
   - Login to InfinityFree control panel
   - Click "File Manager"

2. **Upload files:**
   - Navigate to `/htdocs/` folder
   - Upload all your HTML and CSS files
   - Ensure proper file structure

### **Step 4: Update Flutter App Configuration**

1. **Get your website URL:**
   - Your legal documents will be at: `https://yoursite.infinityfreeapp.com`

2. **Update the Flutter helper:**
   - Open `lib/core/utils/legal_documents_helper.dart`
   - Replace `[YOUR-INFINITYFREE-DOMAIN]` with your actual domain:
   ```dart
   static const String _baseUrl = 'https://yoursite.infinityfreeapp.com';
   ```

### **Step 5: Test Your Deployment**

1. **Visit your website:**
   - Go to `https://yoursite.infinityfreeapp.com`
   - You should see your legal documents index page

2. **Test all pages:**
   - Click each legal document link
   - Ensure all pages load correctly
   - Check mobile responsiveness

3. **Test Flutter integration:**
   - Update your Flutter app with the new URL
   - Test launching legal documents from the app

### **Step 6: Custom Domain (Optional)**

If you have your own domain:

1. **Point your domain to InfinityFree:**
   - Update your domain's nameservers to InfinityFree's
   - Or create A records pointing to InfinityFree's IP

2. **Add domain in InfinityFree:**
   - Go to control panel
   - Add your custom domain
   - Update SSL certificate if needed

### **📁 File Structure on InfinityFree:**

```
/htdocs/
├── index.html                    # Main legal documents page
├── terms-of-service.html         # Terms of Service
├── privacy-policy.html           # Privacy Policy
├── cookie-policy.html            # Cookie Policy
├── disclaimer.html               # Disclaimer
├── contact.html                  # Contact information
├── refund-policy.html            # Refund policy
├── data-retention-security.html  # Data Security Policy
├── community-policy.html         # Community Guidelines
└── styles.css                    # Styling
```

### **🔧 Troubleshooting:**

#### **Common Issues:**

1. **Files not showing:**
   - Check file permissions (755 for folders, 644 for files)
   - Ensure files are in `/htdocs/` directory

2. **CSS not loading:**
   - Verify `styles.css` is uploaded
   - Check file path in HTML files

3. **404 errors:**
   - Ensure file names match exactly (case-sensitive)
   - Check that `index.html` exists in root directory

#### **InfinityFree Limitations:**

- **File size limit:** 10MB per file (your files are much smaller)
- **Bandwidth:** 5GB per month (more than enough for legal documents)
- **Storage:** 5GB total (your files use less than 1MB)

### **🎯 Final Steps:**

1. **Update Flutter app:**
   ```dart
   static const String _baseUrl = 'https://yoursite.infinityfreeapp.com';
   ```

2. **Test all legal document links in your app**

3. **Share your legal documents URL:**
   - Main page: `https://yoursite.infinityfreeapp.com`
   - Individual documents: `https://yoursite.infinityfreeapp.com/privacy-policy.html`

### **📞 Support:**

- **InfinityFree Support:** https://forum.infinityfree.net/
- **FileZilla Help:** https://wiki.filezilla-project.org/

### **✅ Deployment Checklist:**

- [ ] InfinityFree account created
- [ ] Website/subdomain configured
- [ ] FTP credentials obtained
- [ ] All HTML and CSS files uploaded to `/htdocs/`
- [ ] Website accessible at your domain
- [ ] All legal document pages working
- [ ] Flutter app updated with new domain
- [ ] Legal document links tested in app

**Your legal documents are now live and accessible to users!** 🎉
