# Flutter Setup Guide for Windows

## Step 1: Install Flutter

### Option A: Using Git (Recommended)

1. **Download Flutter SDK**:
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download the latest Flutter SDK zip file
   - Extract it to a location like `C:\src\flutter` (avoid spaces in path)

2. **Add Flutter to PATH**:
   - Open "Environment Variables" in Windows
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
   - Click "OK" on all dialogs
   - **Restart PowerShell/Terminal** for changes to take effect

### Option B: Using Chocolatey (If you have it installed)

```powershell
choco install flutter
```

### Option C: Using Scoop (If you have it installed)

```powershell
scoop install flutter
```

## Step 2: Verify Installation

Open a **new** PowerShell window and run:

```powershell
flutter doctor
```

This will check your Flutter installation and show what else you need to set up.

## Step 3: Install Required Dependencies

Flutter doctor will tell you what's missing. Common requirements:

1. **Android Studio** (for Android development):
   - Download from: https://developer.android.com/studio
   - Install Android Studio
   - Open Android Studio and install Android SDK
   - Accept Android licenses: `flutter doctor --android-licenses`

2. **VS Code** (optional but recommended):
   - Download from: https://code.visualstudio.com/
   - Install Flutter extension from VS Code marketplace

## Step 4: After Flutter is Installed

Once Flutter is in your PATH, navigate to the project and run:

```powershell
cd "C:\Dharshan Raj P A\College\Laboratory\Advanced_Python_Programming_Laboratory\Projects-J_Component\Flask\weather_app"
flutter pub get
```

## Quick Test

After installation, verify Flutter works:

```powershell
flutter --version
```

## Troubleshooting

### If PATH changes don't work:
1. Close ALL PowerShell/Command Prompt windows
2. Open a NEW PowerShell window
3. Try `flutter --version` again

### If you get "git not found":
- Install Git from: https://git-scm.com/download/win
- Add Git to PATH during installation

### Alternative: Use Flutter from Full Path

If you can't add Flutter to PATH, you can use the full path:

```powershell
C:\src\flutter\bin\flutter.exe pub get
```

(Replace `C:\src\flutter` with your actual Flutter installation path)

