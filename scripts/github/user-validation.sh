#!/usr/bin/env bash

# TODO: This script is not yet functional.
# Prerequisites before enabling:
#   1. Create a GitHub App for container-platform-github-access
#   2. Store the App credentials in AWS Secrets Manager under a secret
#      named "github/container-platform-access-github-app" (or similar)
#   3. Update GITHUB_SECRET below with the correct secret name
#   4. Create configuration/users.yaml with team member details
#   5. Add PyGithub to a requirements file for auth_helper.py

# GITHUB_SECRET="${GITHUB_SECRET:-"github/container-platform-access-github-app"}"
# USER_MANIFEST="${USER_MANIFEST:-"configuration/users.yaml"}"
#
# # Get GitHub App credentials from AWS Secrets Manager
# githubAppId=$(aws secretsmanager get-secret-value --secret-id "${GITHUB_SECRET}" --query SecretString --output text | jq -r '.app_id')
# export githubAppId
#
# githubAppInstallationId=$(aws secretsmanager get-secret-value --secret-id "${GITHUB_SECRET}" --query SecretString --output text | jq -r '.installation_id')
# export githubAppInstallationId
#
# githubAppPrivateKey=$(aws secretsmanager get-secret-value --secret-id "${GITHUB_SECRET}" --query SecretString --output text | jq -r '.private_key')
# export githubAppPrivateKey
#
# # Generate installation access token using Python helper
# GH_TOKEN=$(python3 scripts/github/auth_helper.py)
# export GH_TOKEN
#
# # Load team members
# teamMembers=$(yq --output-format=json "${USER_MANIFEST}")
# export teamMembers
#
# echo "${teamMembers}" | jq -c '.[]' | while IFS= read -r user; do
# 	memberName=$(echo "${user}" | jq -r '.name')
# 	export memberName
# 	memberGitHub=$(echo "${user}" | jq -r '.github')
# 	export memberGitHub
#
# 	echo "Processing user [ ${memberName} ]"
# 	githubMembershipStatus=$(gh api /orgs/ministryofjustice/memberships/"${memberGitHub}")
#
# 	# Check if the user is an active member
# 	if [[ "$(echo "${githubMembershipStatus}" | jq -r '.state')" == "active" ]]; then
# 		echo "  User found in GitHub organisation"
# 	elif [[ "$(echo "${githubMembershipStatus}" | jq -r '.status')" == "404" ]]; then
# 		echo "  User not found in GitHub organisation"
# 		exit 1
# 	fi
# done

echo "GitHub user validation is not yet configured for this repository."
echo "See scripts/github/user-validation.sh for prerequisites."
exit 0
