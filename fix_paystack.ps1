# PowerShell script to fix Flutter packages

# Create backup directory
$backupDir = Join-Path $env:TEMP "FlutterPackageBackup"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
    Write-Host "Created backup directory at $backupDir"
}

# Files to fix
$filesToFix = @(
    "lib\src\widgets\pin_widget.dart",
    "lib\src\widgets\checkout\checkout_widget.dart",
    "lib\src\widgets\checkout\bank_checkout.dart",
    "lib\src\widgets\custom_dialog.dart",
    "lib\src\widgets\sucessful_widget.dart",
    "lib\src\widgets\otp_widget.dart",
    "lib\src\widgets\buttons.dart",
    "lib\src\widgets\input\pin_field.dart",
    "lib\src\widgets\input\base_field.dart"
)

# Create backups and apply fixes
foreach ($file in $filesToFix) {
    $filePath = Join-Path $paystackPath $file
    $backupPath = Join-Path $backupDir (Split-Path $file -Leaf)

    if (Test-Path $filePath) {
        # Create backup
        Copy-Item -Path $filePath -Destination $backupPath -Force
        Write-Host "Created backup of $file"

        # Read file content
        $content = Get-Content -Path $filePath -Raw

        # Apply fixes
        $content = $content -replace "headline6", "titleLarge"
        $content = $content -replace "subtitle1", "titleMedium"
        $content = $content -replace "bodyText1", "bodyLarge"
        $content = $content -replace "accentColor", "colorScheme.secondary"
        $content = $content -replace "vsync: this,", ""
        $content = $content -replace ".copyWith\(accentColor: Colors.white\)", ".copyWith(colorScheme: ColorScheme.dark(secondary: Colors.white))"

        # Write fixed content
        Set-Content -Path $filePath -Value $content
        Write-Host "Applied fixes to $file"
    } else {
        Write-Host "File $file not found, skipping..."
    }
}

Write-Host "Fixes applied successfully!"

Write-Host "Done."
