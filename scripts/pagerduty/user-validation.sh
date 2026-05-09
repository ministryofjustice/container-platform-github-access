#!/usr/bin/env bash

# TODO: This script is not yet functional.
# Prerequisites before enabling:
#   1. Obtain a PagerDuty API key for container-platform-github-access
#   2. Store the key in AWS Secrets Manager under a secret
#      named "pagerduty/api-key" (or similar)
#   3. Update PAGERDUTY_SECRET below with the correct secret name
#   4. Create configuration/users.yaml with team member details (including pagerduty ID)

# PAGERDUTY_SECRET="${PAGERDUTY_SECRET:-"pagerduty/api-key"}"
# USER_MANIFEST="${USER_MANIFEST:-"configuration/users.yaml"}"
#
# # Get PagerDuty API Key from AWS Secrets Manager
# pagerdutyApiKey=$(aws secretsmanager get-secret-value --secret-id "${PAGERDUTY_SECRET}" --query SecretString --output text)
# export pagerdutyApiKey
#
# # Load team members
# teamMembers=$(yq --output-format=json "${USER_MANIFEST}")
# export teamMembers
#
# echo "${teamMembers}" | jq -c '.[]' | while IFS= read -r user; do
# 	memberName=$(echo "${user}" | jq -r '.name')
# 	export memberName
# 	memberPagerDuty=$(echo "${user}" | jq -r '.pagerduty')
# 	export memberPagerDuty
#
# 	echo "Processing user [ ${memberName} ]"
#
# 	# Check if PagerDuty key is populated
# 	if [[ "${memberPagerDuty}" == "null" ]]; then
# 		echo "  No PagerDuty user ID specified, skipping"
# 		continue
# 	fi
#
# 	# Lookup user info by PagerDuty ID
# 	pagerdutyUserInfo=$(
# 		curl \
# 			--silent \
# 			--header "Authorization: Token token=${pagerdutyApiKey}" \
# 			"https://api.pagerduty.com/users/${memberPagerDuty}"
# 	)
# 	export pagerdutyUserInfo
#
# 	if [[ "${pagerdutyUserInfo}" == *"Not Found"* ]]; then
# 		echo "  User ID not found in PagerDuty"
# 		exit 1
# 	else
# 		echo "  User ID found in PagerDuty"
# 	fi
# done

echo "PagerDuty user validation is not yet configured for this repository."
echo "See scripts/pagerduty/user-validation.sh for prerequisites."
exit 0
