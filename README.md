# AWS SSO Authentication Setup

This directory contains scripts to automate AWS SSO configuration for the WordPress hosting platform.

## Quick Setup

### Linux/macOS
```bash
# Make script executable
chmod +x setup-aws-sso.sh

# Basic setup (uses wp-dev profile, us-east-1 region)
./setup-aws-sso.sh

# Setup with specific profile and region
./setup-aws-sso.sh wp-prod eu-west-1
```

### Windows
```cmd
# Set your SSO details (optional - defaults provided)
set SSO_START_URL=<sso_start_url>
set SSO_REGION=us-east-1

# Run setup
setup-aws-sso.bat
```

## Script Parameters

### setup-aws-sso.sh
```bash
./setup-aws-sso.sh [profile] [region]
```

**Parameters:**
- `profile` - AWS profile to login with after setup (default: wp-dev)
  - Available: wp-dev, wp-staging, wp-prod
- `region` - AWS region to use (default: us-east-1)

**Profile Configuration:**
Each profile is pre-configured with specific SSO URL, account ID, and role:
- wp-dev: <sso_start_url> → <dev_account_id> → <dev_role_name>
- wp-staging: <sso_start_url> → <staging_account_id> → <staging_role_name>  
- wp-prod: <sso_start_url> → <prod_account_id> → <prod_role_name>

**Examples:**
```bash
./setup-aws-sso.sh                      # wp-dev, us-east-1
./setup-aws-sso.sh wp-prod               # wp-prod, us-east-1  
./setup-aws-sso.sh wp-staging eu-west-1  # wp-staging, eu-west-1
```

## Profile Switcher

Load the profile switcher for easy environment switching:

```bash
# Source the switcher
source profile-switcher.sh

# Switch environments
aws_dev      # Switch to development
aws_staging  # Switch to staging  
aws_prod     # Switch to production

# Check status
aws_status

# Login to specific profile
aws_login wp-dev
```

## Quick Login

For simple SSO login without the profile switcher:

```bash
# Linux/macOS
./aws-login.sh [profile]     # Defaults to wp-dev
./aws-login.sh wp-prod       # Login to specific profile
```

```cmd
# Windows
aws-login.bat [profile]      # Defaults to wp-dev
aws-login.bat wp-prod        # Login to specific profile
```

## Profiles Created

- **wp-dev**: Development environment (Account: <dev_account_id>, Role: <dev_role_name>)
- **wp-staging**: Staging environment (Account: <staging_account_id>, Role: <staging_role_name>)
- **wp-prod**: Production environment (Account: <prod_account_id>, Role: <prod_role_name>)

## Usage in Scripts

```bash
# Use specific profile
aws --profile wp-prod cloudformation list-stacks

# Or set environment variable
export AWS_PROFILE=wp-dev
aws s3 ls
```

## Security Notes

- SSO provides temporary credentials that auto-expire
- No long-lived access keys stored on disk
- MFA can be enforced through SSO configuration