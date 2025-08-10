#!/bin/bash

# Client Migration Helper Script for terraform-aws-cognito-user-pool
# This script helps generate terraform state mv commands for migrating from count to for_each

set -e

echo "=== User Pool Client Migration Helper ==="
echo "This script helps migrate from count-based to for_each-based client management."
echo ""

# Check if terraform is available
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform command not found. Please install Terraform first."
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Warning: jq not found. Some features may not work properly."
    echo "Please install jq for full functionality: https://stedolan.github.io/jq/"
fi

echo "Step 1: Analyzing current Terraform state..."

# Check if terraform state exists
if ! terraform state list &> /dev/null; then
    echo "Error: No Terraform state found. Please run 'terraform init' and 'terraform apply' first."
    exit 1
fi

# Find existing client resources
CLIENT_RESOURCES=$(terraform state list | grep "aws_cognito_user_pool_client.client\[" || true)

if [ -z "$CLIENT_RESOURCES" ]; then
    echo "No existing client resources found in state."
    echo "This might mean:"
    echo "  1. You haven't created any clients yet"
    echo "  2. You're already using the for_each pattern"
    echo "  3. Your clients are managed by a different resource name"
    exit 0
fi

echo "Found existing client resources:"
echo "$CLIENT_RESOURCES"
echo ""

echo "Step 2: Please provide your client configuration details..."

# Array to store client info
declare -a CLIENT_NAMES
declare -a CLIENT_INDICES

# Parse existing resources to get indices
while IFS= read -r resource; do
    if [[ $resource =~ aws_cognito_user_pool_client\.client\[([0-9]+)\] ]]; then
        index="${BASH_REMATCH[1]}"
        CLIENT_INDICES+=("$index")

        echo -n "Enter the name for client[$index] (leave empty if no name is specified): "
        read -r client_name
        CLIENT_NAMES+=("$client_name")
    fi
done <<< "$CLIENT_RESOURCES"

echo ""
echo "Step 3: Generating migration commands..."

# Generate migration commands
MIGRATION_COMMANDS=()

for i in "${!CLIENT_INDICES[@]}"; do
    index="${CLIENT_INDICES[$i]}"
    name="${CLIENT_NAMES[$i]}"

    if [ -n "$name" ]; then
        # Client has a name
        new_key="${name}_${index}"
    else
        # Client has no name
        new_key="client_${index}"
    fi

    old_resource="aws_cognito_user_pool_client.client[${index}]"
    new_resource="aws_cognito_user_pool_client.client[\"${new_key}\"]"

    migration_cmd="terraform state mv '${old_resource}' '${new_resource}'"
    MIGRATION_COMMANDS+=("$migration_cmd")
done

echo ""
echo "=== Generated Migration Commands ==="
echo ""

for cmd in "${MIGRATION_COMMANDS[@]}"; do
    echo "$cmd"
done

echo ""
echo "=== Migration Instructions ==="
echo "1. Review the commands above carefully"
echo "2. Run each command in order:"
echo ""

for cmd in "${MIGRATION_COMMANDS[@]}"; do
    echo "   $cmd"
done

echo ""
echo "3. After running all commands, verify with:"
echo "   terraform plan"
echo ""
echo "4. The plan should show no changes for client resources"
echo ""

# Offer to run commands automatically
echo -n "Would you like to run these commands automatically? (y/N): "
read -r AUTO_RUN

if [[ $AUTO_RUN =~ ^[Yy]$ ]]; then
    echo ""
    echo "Running migration commands..."

    for cmd in "${MIGRATION_COMMANDS[@]}"; do
        echo "Executing: $cmd"
        if eval "$cmd"; then
            echo "✓ Success"
        else
            echo "✗ Failed"
            echo "Please run the remaining commands manually."
            exit 1
        fi
    done

    echo ""
    echo "✓ All migration commands completed successfully!"
    echo ""
    echo "Running terraform plan to verify..."
    terraform plan

    echo ""
    echo "Migration complete! Check the plan output above."
    echo "If you see any client resources being created/destroyed, please review your configuration."

else
    echo ""
    echo "Migration commands have been generated above."
    echo "Please run them manually and then verify with 'terraform plan'."
fi

echo ""
echo "For more information, see: MIGRATION_GUIDE.md"
echo "If you encounter issues, please create an issue at:"
echo "https://github.com/lgallard/terraform-aws-cognito-user-pool/issues"
