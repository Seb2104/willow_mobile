@echo off
setlocal enabledelayedexpansion

echo [DEBUG] Script started
echo [DEBUG] Checking git repository...

:: Check if we're in a git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if !errorlevel! equ 0 goto :git_repo_exists

echo Not in a git repository.
echo.
set /p "create_repo=Do you want to create a new git repository here? ^(y/n^): "
if /i "!create_repo!" neq "y" (
    echo Operation cancelled.
    pause
    exit /b 1
)

echo.
echo Initializing new git repository...
git init
if !errorlevel! neq 0 (
    echo Failed to create git repository
    pause
    exit /b 1
)
echo Git repository created successfully!
echo.

:git_repo_exists

:: Check if remote exists
git remote -v >nul 2>&1
git remote get-url origin >nul 2>&1
if !errorlevel! equ 0 goto :remote_exists

echo No remote repository configured.
echo.

:: Check if GitHub CLI is available
gh --version >nul 2>&1
if !errorlevel! neq 0 goto :manual_remote

set /p "create_github_repo=Do you want to create a new GitHub repository? ^(y/n^): "
if /i "!create_github_repo!" neq "y" goto :manual_remote

echo.
:: Get current directory name as default repo name
for %%I in (.) do set "default_repo_name=%%~nxI"
set /p "repo_name=Enter repository name [!default_repo_name!]: "
if "!repo_name!"=="" set "repo_name=!default_repo_name!"

echo.
set /p "repo_visibility=Make repository public or private? ^(public/private^) [private]: "
if "!repo_visibility!"=="" set "repo_visibility=private"

echo.
echo Creating GitHub repository '!repo_name!' ^(!repo_visibility!^)...

if /i "!repo_visibility!"=="public" (
    gh repo create !repo_name! --!repo_visibility! --source=. --remote=origin
) else (
    gh repo create !repo_name! --private --source=. --remote=origin
)

if !errorlevel! neq 0 (
    echo ✗ Failed to create GitHub repository
    echo Falling back to manual remote setup...
    goto :manual_remote
)

echo ✓ GitHub repository created and remote added successfully!
echo.
goto :remote_exists

:manual_remote
set /p "add_remote=Do you want to add a remote repository manually? ^(y/n^): "
if /i "!add_remote!" neq "y" (
    echo Cannot push without a remote repository.
    pause
    exit /b 1
)

echo.
set /p "remote_url=Enter the remote repository URL ^(e.g., https://github.com/user/repo.git^): "
if "!remote_url!"=="" (
    echo ✗ Remote URL cannot be empty
    pause
    exit /b 1
)

echo Adding remote 'origin'...
git remote add origin !remote_url!
if !errorlevel! neq 0 (
    echo ✗ Failed to add remote
    pause
    exit /b 1
)

echo ✓ Remote added successfully!
echo.

:remote_exists

echo [DEBUG] About to push...
echo Pushing current branch to GitHub...

echo [DEBUG] Getting branch name...
:: Get the current branch name
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i

echo [DEBUG] Branch variable set
echo Current branch: !CURRENT_BRANCH!

:: Push the current branch to origin (GitHub)
git push origin !CURRENT_BRANCH!

:: Check if the push was successful
if !ERRORLEVEL! equ 0 (
    echo.
    echo ✓ Successfully pushed !CURRENT_BRANCH! to GitHub!
) else (
    echo.
    echo ✗ Failed to push to GitHub. Error code: !ERRORLEVEL!
    echo Please check your Git configuration and network connection.
)

pause