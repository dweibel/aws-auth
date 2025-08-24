#!/bin/bash

# AWS SSO Profile Setup Script
# 
# This script configures AWS SSO profiles for WordPress hosting environments
# and performs initial SSO login. It creates profiles for dev, staging, and
# production environments with appropriate permissions.
#
# Usage: ./setup-aws-sso.sh [profile] [region]
#
# Parameters:
#   profile  - AWS profile to login with after setup (default: wp-dev)
#            Available: wp-dev, wp-staging, wp-prod
#   region   - AWS region to use (default: us-east-1)
#
# Profile Configuration:
# Each profile contains: SSO_URL:ACCOUNT_ID:ROLE_NAME
# - wp-dev: <sso_start_url> → <dev_account_id> → <dev_role_name>
# - wp-staging: <sso_start_url> → <staging_account_id> → <staging_role_name>
# - wp-prod: <sso_start_url> → <prod_account_id> → <prod_role_name>
#
# Examples:
#   ./setup-aws-sso.sh                    # Setup with wp-dev, us-east-1
#   ./setup-aws-sso.sh wp-prod             # Setup with wp-prod, us-east-1
#   ./setup-aws-sso.sh wp-staging eu-west-1  # Setup with wp-staging, eu-west-1
#
# After setup, use:
#   aws s3 ls                              # Uses exported AWS_PROFILE
#   aws --profile wp-prod cloudformation list-stacks
#   export AWS_PROFILE=wp-staging && aws ec2 describe-instances

set -e

# Parse parameters
PROFILE="${1:-wp-dev}"
REGION="${2:-us-east-1}"

# Configuration
SSO_REGION="us-east-1"
DEFAULT_REGION="$REGION"

# Profiles to create
declare -A PROFILES=(
    ["wp-dev"]="<sso_start_url>:<dev_account_id>:<dev_role_name>"
    ["wp-staging"]="<sso_start_url>:<staging_account_id>:<staging_role_name>"
    ["wp-prod"]="<sso_start_url>:<prod_account_id>:<prod_role_name>"
)

echo "Setting up AWS SSO profiles for WordPress hosting..."

# Ensure AWS directory exists
mkdir -p ~/.aws

# Create/update config file
create_config() {
    cat > ~/.aws/config << EOF
[default]
region = $DEFAULT_REGION
output = json

EOF

    for profile in "${!PROFILES[@]}"; do
        IFS=':' read -r profile_sso_url account_id role_name <<< "${PROFILES[$profile]}"
        cat >> ~/.aws/config << EOF
[profile $profile]
sso_start_url = ${profile_sso_url}
sso_region = $SSO_REGION
sso_account_id = $account_id
sso_role_name = $role_name
region = $DEFAULT_REGION
output = json

EOF
    done
}

# Create config
create_config
echo "✓ Created ~/.aws/config with SSO profiles"

# Login to SSO
echo "Logging into AWS SSO..."
aws sso login --profile $PROFILE

echo "✓ AWS SSO setup complete!"
echo ""
echo "Available profiles:"
for profile in "${!PROFILES[@]}"; do
    echo "  - $profile"
done
export AWS_PROFILE="$PROFILE"
export AWS_REGION="$REGION"
echo ""
echo "Active profile: $PROFILE"
echo "Active region: $REGION"
echo ""
echo "Usage: aws s3 ls"
echo "Or: aws --profile $PROFILE s3 ls"
