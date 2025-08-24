@echo off
REM AWS SSO Login Script
REM Usage: aws-sso-login.bat [profile]

set PROFILE=%1
if "%PROFILE%"=="" set PROFILE=wp-dev

echo Logging into AWS SSO with profile: %PROFILE%
aws sso login --profile %PROFILE%
echo Login complete