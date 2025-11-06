# Flask CORS Setup for Web

To enable your Flutter web app to communicate with the Flask API, you need to add CORS (Cross-Origin Resource Sharing) support to your Flask server.

## Option 1: Using flask-cors (Recommended)

### Step 1: Install flask-cors

In your Jupyter notebook, run:

```python
!pip install flask-cors
```

### Step 2: Update Cell 5 in your notebook

Replace the code in Cell 5 with:

```python
# Program 2: Weather Information Web Application with CORS support
from flask import Flask, request           # Flask and request handling
from flask_cors import CORS                # CORS support for web
import random                               # For generating random weather values

WeatherApplication = Flask(__name__)       # Create Flask app
CORS(WeatherApplication)                   # Enable CORS for all routes


@WeatherApplication.route('/')             # Home page route
def WelcomePageFunction():                  # Welcome page handler
    return "Welcome to the Flask Weather App!\n\nUse /weather?city=YourCity to get weather info."  


@WeatherApplication.route('/weather')      # Weather endpoint route
def WeatherInformationFunction():          # Generate weather data for requested city
    CityNameInput = request.args.get('city', 'Unknown')  # Get city from URL parameter
    
    # Available weather conditions
    WeatherConditionList = ["Sunny", "Cloudy", "Rainy", "Windy", "Stormy", "Clear Night"]  
    
    RandomWeatherCondition = random.choice(WeatherConditionList)  # Pick random condition
    RandomTemperature = random.randint(20, 38)  # Temperature range: 20-38°C
    RandomHumidity = random.randint(40, 90)     # Humidity: 40-90%
    RandomWindSpeed = round(random.uniform(2.0, 12.0), 1)  # Wind speed with 1 decimal
    
    # Format the complete weather report
    WeatherReportOutput = (
        f"Weather Report for {CityNameInput}\n"
        f"Condition: {RandomWeatherCondition}\n"
        f"Temperature: {RandomTemperature}°C\n"
        f"Humidity: {RandomHumidity}%\n"
        f"Wind Speed: {RandomWindSpeed} km/h\n"
    )
    
    return WeatherReportOutput


if __name__ == '__main__':                 # Run the application
    WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
```

## Option 2: Manual CORS Headers (No extra package)

If you don't want to install flask-cors, update Cell 5 with:

```python
# Program 2: Weather Information Web Application with Manual CORS
from flask import Flask, request           # Flask and request handling
import random                               # For generating random weather values

WeatherApplication = Flask(__name__)       # Create Flask app


@WeatherApplication.after_request
def after_request(response):
    """Add CORS headers to all responses"""
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response


@WeatherApplication.route('/')             # Home page route
def WelcomePageFunction():                  # Welcome page handler
    return "Welcome to the Flask Weather App!\n\nUse /weather?city=YourCity to get weather info."  


@WeatherApplication.route('/weather')      # Weather endpoint route
def WeatherInformationFunction():          # Generate weather data for requested city
    CityNameInput = request.args.get('city', 'Unknown')  # Get city from URL parameter
    
    # Available weather conditions
    WeatherConditionList = ["Sunny", "Cloudy", "Rainy", "Windy", "Stormy", "Clear Night"]  
    
    RandomWeatherCondition = random.choice(WeatherConditionList)  # Pick random condition
    RandomTemperature = random.randint(20, 38)  # Temperature range: 20-38°C
    RandomHumidity = random.randint(40, 90)     # Humidity: 40-90%
    RandomWindSpeed = round(random.uniform(2.0, 12.0), 1)  # Wind speed with 1 decimal
    
    # Format the complete weather report
    WeatherReportOutput = (
        f"Weather Report for {CityNameInput}\n"
        f"Condition: {RandomWeatherCondition}\n"
        f"Temperature: {RandomTemperature}°C\n"
        f"Humidity: {RandomHumidity}%\n"
        f"Wind Speed: {RandomWindSpeed} km/h\n"
    )
    
    return WeatherReportOutput


if __name__ == '__main__':                 # Run the application
    WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
```

## Testing CORS

After updating your Flask server, test it:

1. Start the Flask server (run Cell 5)
2. Open browser console (F12)
3. Test the API:
   ```javascript
   fetch('http://localhost:5005/weather?city=London')
     .then(r => r.text())
     .then(console.log)
   ```
4. If you see the weather data, CORS is working!

## Important Notes

- **Option 1 (flask-cors)** is cleaner and more configurable
- **Option 2 (manual headers)** works without extra packages but is less flexible
- Both allow all origins (`*`) - for production, specify allowed origins
- Make sure Flask server is running on `127.0.0.1:5005` or `localhost:5005`

