# Running Flutter App on Windows Desktop

## Prerequisites

1. **Flutter SDK installed** and added to PATH
2. **Visual Studio 2022** with "Desktop development with C++" workload
3. **Windows 10/11** (64-bit)

## Step 1: Enable Windows Desktop Support

If Windows desktop support is not enabled, run:

```powershell
flutter config --enable-windows-desktop
```

Verify Windows is enabled:
```powershell
flutter devices
```

You should see "Windows (desktop)" in the list.

## Step 2: Install Dependencies

Navigate to the project directory and install dependencies:

```powershell
cd "C:\Dharshan Raj P A\College\Laboratory\Advanced_Python_Programming_Laboratory\Projects-J_Component\Flutter"
flutter pub get
```

## Step 3: Create Windows Project Files (if needed)

If the `windows` folder doesn't exist, create it:

```powershell
flutter create --platforms=windows .
```

This will add Windows platform support to your existing project.

## Step 4: Run the App

### Option A: Run directly
```powershell
flutter run -d windows
```

### Option B: List available devices first
```powershell
flutter devices
flutter run -d windows
```

### Option C: Build and run executable
```powershell
flutter build windows
```

Then run the executable from:
```
build\windows\x64\runner\Release\weather_app.exe
```

## Step 5: Start Flask API Server

**Important**: Before running the Flutter app, start your Flask weather API server:

1. Open your Jupyter notebook (`22-Lab_04-10-2025.ipynb`)
2. Run Cell 5 to start the Flask server:
   ```python
   WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
   ```
3. Keep the Flask server running while using the app

## Troubleshooting

### Error: "Windows desktop support not available"

Install Visual Studio 2022:
- Download: https://visualstudio.microsoft.com/downloads/
- Install "Desktop development with C++" workload
- Restart your computer
- Run `flutter doctor` to verify

### Error: "No devices found"

Enable Windows desktop:
```powershell
flutter config --enable-windows-desktop
flutter doctor
```

### Error: "Unable to connect to Flask API"

1. Make sure Flask server is running on port 5005
2. Test the API in browser: `http://127.0.0.1:5005/weather?city=London`
3. The app will use mock data if API is unavailable (this is expected)

### Error: "geolocator" location not working on Windows

Location services on Windows desktop are limited. The app will:
- Try to get location (may not work on desktop)
- Fall back to showing an error message
- Allow you to search for cities manually

This is normal behavior for Windows desktop apps.

## Quick Start Commands

```powershell
# Navigate to project
cd "C:\Dharshan Raj P A\College\Laboratory\Advanced_Python_Programming_Laboratory\Projects-J_Component\Flutter"

# Enable Windows support (first time only)
flutter config --enable-windows-desktop

# Get dependencies
flutter pub get

# Run the app
flutter run -d windows
```

## Development Tips

1. **Hot Reload**: Press `r` in the terminal while app is running to hot reload
2. **Hot Restart**: Press `R` for hot restart
3. **Quit**: Press `q` to quit

## Building Release Version

To create a release build:

```powershell
flutter build windows --release
```

The executable will be in:
```
build\windows\x64\runner\Release\weather_app.exe
```

You can distribute this `.exe` file (users will need Visual C++ Redistributable installed).

