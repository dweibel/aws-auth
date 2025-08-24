@echo off
REM AWS SSO Profile Setup Script for Windows
REM Usage: setup-aws-sso.bat

setlocal enabledelayedexpansion

REM Configuration
if "%SSO_START_URL%"=="" set SSO_START_URL=https://iyba.awsapps.com/start
if "%SSO_REGION%"=="" set SSO_REGION=us-east-1
if "%DEFAULT_REGION%"=="" set DEFAULT_REGION=us-east-1

echo Setting up AWS SSO profiles for WordPress hosting...

REM Ensure AWS directory exists
if not exist "%USERPROFILE%\.aws" mkdir "%USERPROFILE%\.aws"

REM Create config file
(
echo [default]
echo region = %DEFAULT_REGION%
echo output = json
echo.
echo [profile wp-dev]
echo sso_start_url = %SSO_START_URL%
echo sso_region = %SSO_REGION%
echo sso_account_id = ^<dev_account_id^>
echo sso_role_name = ^<dev_role_name^>
echo region = %DEFAULT_REGION%
echo output = json
echo.
echo [profile wp-staging]
echo sso_start_url = %SSO_START_URL%
echo sso_region = %SSO_REGION%
echo sso_account_id = ^<staging_account_id^>
echo sso_role_name = ^<staging_role_name^>
echo region = %DEFAULT_REGION%
echo output = json
echo.
echo [profile wp-prod]
echo sso_start_url = %SSO_START_URL%
echo sso_region = %SSO_REGION%
echo sso_account_id = ^<prod_account_id^>
echo sso_role_name = ^<prod_role_name^>
echo region = %DEFAULT_REGION%
echo output = json
) > "%USERPROFILE%\.aws\config"

echo ✓ Created ~/.aws/config with SSO profiles

REM Login to SSO
echo Logging into AWS SSO...
aws sso login --profile wp-dev

echo ✓ AWS SSO setup complete!
echo.
echo Available profiles:
echo   - wp-dev
echo   - wp-staging  
echo   - wp-prod
echo.
echo Usage: aws --profile wp-dev s3 ls
echo Or: set AWS_PROFILE=wp-dev