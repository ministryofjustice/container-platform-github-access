#!/usr/bin/env bash

# TODO: This script is not yet functional.
# Prerequisites before enabling:
#   1. Create an Entra (Azure AD) App Registration for container-platform-github-access
#   2. Store the credentials in AWS Secrets Manager under a secret
#      named "entra/container-platform-access" (or similar)
#   3. Update ENTRA_SECRET below with the correct secret name
#   4. Create configuration/users.yaml with team member details (including email)

# ENTRA_SECRET="${ENTRA_SECRET:-"entra/container-platform-access"}"
# USER_MANIFEST="${USER_MANIFEST:-"configuration/users.yaml"}"
#
# # Get Entra credentials from AWS Secrets Manager
# entraClientId=$(aws secretsmanager get-secret-value --secret-id "${ENTRA_SECRET}" --query SecretString --output text | jq -r '.client_id')
# export entraClientId
#
# entraClientSecret=$(aws secretsmanager get-secret-value --secret-id "${ENTRA_SECRET}" --query SecretString --output text | jq -r '.client_secret')
# export entraClientSecret
#
# entraTenantId=$(aws secretsmanager get-secret-value --secret-id "${ENTRA_SECRET}" --query SecretString --output text | jq -r '.tenant_id')
# export entraTenantId
#
# # Get access token
# entraAccessToken=$(
# 	curl \
# 		--silent \
# 		--data grant_type=client_credentials \
# 		--data client_id="${entraClientId}" \
# 		--data client_secret="${entraClientSecret}" \
# 		--data scope="https://graph.microsoft.com/.default" \
# 		"https://login.microsoftonline.com/${entraTenantId}/oauth2/v2.0/token" | jq -r '.access_token'
# )
# export entraAccessToken
#
# # Load team members
# teamMembers=$(yq --output-format=json "${USER_MANIFEST}")
# export teamMembers
#
# echo "${teamMembers}" | jq -c '.[]' | while IFS= read -r user; do
# 	memberName=$(echo "${user}" | jq -r '.name')
# 	export memberName
# 	memberEmail=$(echo "${user}" | jq -r '.email')
# 	export memberEmail
# 	memberUPN=$(echo "${memberEmail}" | cut -d'@' -f1)
# 	export memberUPN
# 	memberSuffix=$(echo "${memberEmail}" | cut -d'@' -f2)
# 	export memberSuffix
#
# 	echo "Processing user [ ${memberName} ]"
#
# 	# Lookup user ID by UPN + suffix
# 	entraUserId=$(
# 		curl \
# 			--silent \
# 			--header "Authorization: Bearer ${entraAccessToken}" \
# 			"https://graph.microsoft.com/v1.0/users?%24filter=userPrincipalName+eq+%27${memberUPN}@${memberSuffix}%27" | jq -r '.value[0].id'
# 	)
# 	export entraUserId
#
# 	# Check if user exists
# 	if [[ "${entraUserId}" == "null" ]]; then
# 		echo "  User not found in Entra"
# 		exit 1
# 	else
# 		echo "  User found in Entra"
# 	fi
#
# 	# Get user status
# 	entraUserStatus=$(
# 		curl \
# 			--silent \
# 			--header "Authorization: Bearer ${entraAccessToken}" \
# 			"https://graph.microsoft.com/v1.0/users/${entraUserId}?%24select=accountEnabled" | jq -r '.accountEnabled'
# 	)
# 	export entraUserStatus
#
# 	# Check if user is enabled
# 	if [[ "${entraUserStatus}" = "true" ]]; then
# 		echo "  User is enabled in Entra"
# 	else
# 		echo "  User is disabled in Entra"
# 		exit 1
# 	fi
# done

echo "Entra user validation is not yet configured for this repository."
echo "See scripts/entra/user-validation.sh for prerequisites."
exit 0
