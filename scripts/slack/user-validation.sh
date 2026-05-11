#!/usr/bin/env bash

# TODO: This script is not yet functional.
# Prerequisites before enabling:
#   1. Create a Slack App/Bot token for container-platform-github-access
#   2. Store the token in AWS Secrets Manager under a secret
#      named "slack/container-platform-access-token" (or similar)
#   3. Update SLACK_SECRET below with the correct secret name
#   4. Create configuration/users.yaml with team member details (including slack ID)

# SLACK_SECRET="${SLACK_SECRET:-"slack/container-platform-access-token"}"
# USER_MANIFEST="${USER_MANIFEST:-"configuration/users.yaml"}"
#
# # Get Slack token from AWS Secrets Manager
# slackAccessToken=$(aws secretsmanager get-secret-value --secret-id "${SLACK_SECRET}" --query SecretString --output text)
# export slackAccessToken
#
# # Load team members
# teamMembers=$(yq --output-format=json "${USER_MANIFEST}")
# export teamMembers
#
# echo "${teamMembers}" | jq -c '.[]' | while IFS= read -r user; do
# 	memberName=$(echo "${user}" | jq -r '.name')
# 	export memberName
# 	memberSlack=$(echo "${user}" | jq -r '.slack')
# 	export memberSlack
#
# 	echo "Processing user [ ${memberName} ]"
#
# 	# Lookup user info by Slack ID
# 	slackUserInfo=$(
# 		curl \
# 			--silent \
# 			--header "Authorization: Bearer ${slackAccessToken}" \
# 			"https://slack.com/api/users.info?include_locale=true&user=${memberSlack}"
# 	)
# 	export slackUserInfo
#
# 	# Check if user exists
# 	if [[ "$(echo "${slackUserInfo}" | jq -r '.ok')" == "true" ]]; then
# 		echo "  User found in Slack"
# 	else
# 		echo "  Issue looking up user in Slack - $(echo "${slackUserInfo}" | jq -r '.error')"
# 		exit 1
# 	fi
#
# 	# Check if user is active
# 	if [[ "$(echo "${slackUserInfo}" | jq -r '.user.deleted')" == "false" ]]; then
# 		echo "  User is active in Slack"
# 	else
# 		echo "  User is deactivated in Slack"
# 		exit 1
# 	fi
# done

echo "Slack user validation is not yet configured for this repository."
echo "See scripts/slack/user-validation.sh for prerequisites."
exit 0
