@echo off
REM call flutter config --no-enable-web
REM call flutter config --no-enable-ios
REM call flutter config --no-enable-android
REM call flutter config --no-enable-macos-desktop
REM call flutter config --no-enable-linux-desktop
REM call flutter config --no-enable-windows-desktop
echo clean flutter
call flutter clean
echo flutter get packages
call flutter pub get