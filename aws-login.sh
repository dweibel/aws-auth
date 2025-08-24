#!/bin/bash

# AWS SSO Login Script
# Usage: ./aws-sso-login.sh [profile]

PROFILE="${1:-wp-dev}"

echo "Logging into AWS SSO with profile: $PROFILE"
aws sso login --profile "$PROFILE"
echo "✓ Login complete"