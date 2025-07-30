@echo off
echo Testing Fit4Force SSL Connection Fix...
echo.
echo 1. Cleaning Flutter project...
flutter clean

echo.
echo 2. Getting dependencies...
flutter pub get

echo.
echo 3. Building Android APK with SSL fixes...
flutter build apk --debug

echo.
echo 4. Running on connected device...
flutter run --debug

pause
