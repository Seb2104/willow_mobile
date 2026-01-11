@echo off
setlocal enabledelayedexpansion

:: Check if we're in a git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if !errorlevel! neq 0 (
    echo Not in a git repository.
    echo.
    set /p "create_repo=Do you want to create a new git repository here? (y/n): "
    if /i "!create_repo!"=="y" (
        echo.
        echo Initializing new git repository...
        git init
        if !errorlevel! equ 0 (
            echo ✓ Git repository created successfully!
            echo.
        ) else (
            echo ✗ Failed to create git repository
            pause
            exit /b 1
        )
    ) else (
        echo Operation cancelled.
        pause
        exit /b 1
    )
)

:: Get commit count with error handling
set "commit_count=0"
for /f "tokens=*" %%i in ('git rev-list --count HEAD 2^>nul') do set "commit_count=%%i"
if "!commit_count!"=="" set "commit_count=0"

:: Add 1 to get the next commit number
set /a "next_commit_number=!commit_count! + 1"

:: Show current git status
echo.
echo Current repository status:
git status --short

:: Prompt for commit message directly
echo.
echo Enter commit message for commit #!next_commit_number!:
set /p "commit_message="

:: Check if message is empty
if "!commit_message!"=="" (
    echo Error: Commit message cannot be empty
    pause
    exit /b 1
)

:: Create the final commit message
set "final_message=#!next_commit_number! - !commit_message!"

:: Add all changes and commit
echo.
echo Adding all changes...
git add .

echo Committing with message: !final_message!
git commit -m "!final_message!"

if !errorlevel! equ 0 (
    echo Successfully committed!
) else (
    echo Commit failed!
)

pause