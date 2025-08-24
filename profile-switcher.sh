#!/bin/bash

# AWS Profile Switcher for WordPress Hosting
# Usage: source profile-switcher.sh

# Profile switching functions
aws_dev() {
    export AWS_PROFILE=wp-dev
    echo "Switched to WordPress DEV environment"
    aws sts get-caller-identity 2>/dev/null || echo "Run: aws sso login --profile wp-dev"
}

aws_staging() {
    export AWS_PROFILE=wp-staging
    echo "Switched to WordPress STAGING environment"
    aws sts get-caller-identity 2>/dev/null || echo "Run: aws sso login --profile wp-staging"
}

aws_prod() {
    export AWS_PROFILE=wp-prod
    echo "Switched to WordPress PRODUCTION environment"
    aws sts get-caller-identity 2>/dev/null || echo "Run: aws sso login --profile wp-prod"
}

# Login function
aws_login() {
    if [ -z "$1" ]; then
        echo "Usage: aws_login [wp-dev|wp-staging|wp-prod]"
        return 1
    fi
    aws sso login --profile $1
}

# Status function
aws_status() {
    echo "Current AWS Profile: ${AWS_PROFILE:-default}"
    aws sts get-caller-identity 2>/dev/null || echo "Not authenticated"
}

echo "WordPress AWS Profile Switcher loaded"
echo "Commands: aws_dev, aws_staging, aws_prod, aws_login, aws_status"