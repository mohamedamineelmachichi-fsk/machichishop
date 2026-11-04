@echo off
cd /d "%~dp0"
if not exist .env.local (
  echo FIRST: copy .env.example to .env.local and fill in your Supabase public key.
  pause
  exit /b 1
)
where npm >nul 2>nul
if errorlevel 1 (
 echo Install Node.js LTS first: https://nodejs.org/
 pause
 exit /b 1
)
if not exist node_modules (
  call npm install
  if errorlevel 1 (pause & exit /b 1)
)
call npm run dev
pause
