@echo off
REM Quick start script for Docker setup on Windows
REM Usage: start.bat [dev|prod]

set MODE=%1
if "%MODE%"=="" set MODE=dev

echo Starting Flask Food Delivery App in %MODE% mode...

REM Check if .env file exists
if not exist .env (
    echo Creating .env file from env.example...
    copy env.example .env
    echo.
    echo WARNING: Please edit .env file and update SECRET_KEY, DB_PASSWORD, and REDIS_PASSWORD before continuing!
    echo Press any key to continue or Ctrl+C to exit...
    pause >nul
)

REM Start services
if "%MODE%"=="prod" (
    echo Starting in PRODUCTION mode...
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
) else (
    echo Starting in DEVELOPMENT mode...
    docker-compose up -d --build
)

REM Wait for services to be healthy
echo.
echo Waiting for services to be healthy...
timeout /t 10 /nobreak >nul

REM Check service status
echo.
echo Service Status:
docker-compose ps

echo.
echo Application should be available at: http://localhost
echo Health check: http://localhost/health
echo.
echo View logs with: docker-compose logs -f
echo Stop services with: docker-compose down

