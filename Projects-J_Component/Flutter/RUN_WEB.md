# Running Flutter App on Web

## Prerequisites

1. **Flutter SDK installed** and added to PATH
2. **Chrome browser** (recommended for development)
3. **Flask API server** running (for API calls)

## Step 1: Enable Web Support

Enable web support in Flutter (one-time setup):

```powershell
flutter config --enable-web
```

Verify web is enabled:
```powershell
flutter devices
```

You should see "Chrome (web)" in the list.

## Step 2: Install Dependencies

Navigate to the project directory and install dependencies:

```powershell
cd "C:\Dharshan Raj P A\College\Laboratory\Advanced_Python_Programming_Laboratory\Projects-J_Component\Flutter"
flutter pub get
```

## Step 3: Create Web Project Files (if needed)

If the `web` folder doesn't exist, create it:

```powershell
flutter create --platforms=web .
```

This will add web platform support to your existing project.

## Step 4: Configure CORS for Flask API

**Important**: Web browsers enforce CORS (Cross-Origin Resource Sharing) policies. You need to configure your Flask server to allow requests from the Flutter web app.

### Update Flask Server (in your Jupyter notebook)

Modify Cell 5 in `22-Lab_04-10-2025.ipynb` to add CORS support:

```python
# Program 2: Weather Information Web Application with CORS support
from flask import Flask, request
from flask_cors import CORS
import random

WeatherApplication = Flask(__name__)
CORS(WeatherApplication)  # Enable CORS for all routes

@WeatherApplication.route('/')
def WelcomePageFunction():
    return "Welcome to the Flask Weather App!\n\nUse /weather?city=YourCity to get weather info."

@WeatherApplication.route('/weather')
def WeatherInformationFunction():
    CityNameInput = request.args.get('city', 'Unknown')
    
    WeatherConditionList = ["Sunny", "Cloudy", "Rainy", "Windy", "Stormy", "Clear Night"]
    
    RandomWeatherCondition = random.choice(WeatherConditionList)
    RandomTemperature = random.randint(20, 38)
    RandomHumidity = random.randint(40, 90)
    RandomWindSpeed = round(random.uniform(2.0, 12.0), 1)
    
    WeatherReportOutput = (
        f"Weather Report for {CityNameInput}\n"
        f"Condition: {RandomWeatherCondition}\n"
        f"Temperature: {RandomTemperature}°C\n"
        f"Humidity: {RandomHumidity}%\n"
        f"Wind Speed: {RandomWindSpeed} km/h\n"
    )
    
    return WeatherReportOutput

if __name__ == '__main__':
    WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
```

**Install flask-cors**:
```python
!pip install flask-cors
```

### Alternative: Simple CORS without flask-cors

If you don't want to install flask-cors, add headers manually:

```python
from flask import Flask, request, Response
import random

WeatherApplication = Flask(__name__)

@WeatherApplication.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

# ... rest of your code
```

## Step 5: Update API Service for Web

The web version needs to handle CORS. Update `lib/services/weather_api_service.dart` if needed. The current implementation should work, but you may need to adjust the base URL.

For web, you might need to use `http://localhost:5005` instead of `http://127.0.0.1:5005`:

```dart
static const String baseUrl = 'http://localhost:5005';
```

## Step 6: Run the App on Web

### Option A: Run in Chrome (recommended)

```powershell
flutter run -d chrome
```

### Option B: Run in any available browser

```powershell
flutter run -d web-server
```

Then open the URL shown in the terminal (usually `http://localhost:port`)

### Option C: Build for web

```powershell
flutter build web
```

Then serve the files:
- The built files will be in `build/web/`
- You can use any web server to serve them
- Or use Python's built-in server:
  ```powershell
  cd build/web
  python -m http.server 8000
  ```
- Open `http://localhost:8000` in your browser

## Step 7: Start Flask API Server

**Before running the Flutter app**, start your Flask weather API server:

1. Open your Jupyter notebook (`22-Lab_04-10-2025.ipynb`)
2. Run Cell 5 to start the Flask server:
   ```python
   WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
   ```
3. Keep the Flask server running while using the app

## Troubleshooting

### Error: "Web support not available"

Enable web support:
```powershell
flutter config --enable-web
flutter doctor
```

### Error: CORS policy blocked

1. Make sure Flask server has CORS enabled (see Step 4)
2. Check browser console for CORS errors
3. Try using `http://localhost:5005` instead of `http://127.0.0.1:5005`

### Error: "Unable to connect to Flask API"

1. Make sure Flask server is running on port 5005
2. Test the API in browser: `http://127.0.0.1:5005/weather?city=London`
3. The app will use mock data if API is unavailable (this is expected)

### Error: Location services not working

Location services on web require HTTPS (except for localhost). For development:
- Use `http://localhost` (not `127.0.0.1`)
- Or use the search feature to find cities manually

### Port already in use

If port is already in use:
```powershell
flutter run -d chrome --web-port=8080
```

## Quick Start Commands

```powershell
# 1. Enable web support (first time only)
flutter config --enable-web

# 2. Navigate to project
cd "C:\Dharshan Raj P A\College\Laboratory\Advanced_Python_Programming_Laboratory\Projects-J_Component\Flutter"

# 3. Get dependencies
flutter pub get

# 4. Create web files (if needed)
flutter create --platforms=web .

# 5. Run the app
flutter run -d chrome
```

## Development Tips

1. **Hot Reload**: Press `r` in the terminal while app is running
2. **Hot Restart**: Press `R` for hot restart
3. **Quit**: Press `q` to quit
4. **Browser DevTools**: Press `d` to open DevTools
5. **Clear Cache**: Press `c` to clear web cache

## Building for Production

To create a production build:

```powershell
flutter build web --release
```

The built files will be in `build/web/`. You can deploy these to any web server.

## Important Notes

1. **CORS is required**: Web browsers block cross-origin requests by default. Your Flask server must allow requests from the web app.

2. **Location Services**: May not work on web without HTTPS. Use the search feature as an alternative.

3. **Shared Preferences**: Works on web using browser's localStorage.

4. **Performance**: Web builds are larger than mobile builds. First build may take longer.

