#!/usr/bin/env python3
"""
GitHub App Authentication Helper

This script generates an installation access token from GitHub App credentials
and outputs it to stdout for use in bash scripts.

Environment Variables:
    githubAppId: GitHub App ID
    githubAppInstallationId: GitHub App Installation ID
    githubAppPrivateKey: GitHub App Private Key (base64 encoded PEM format)

TODO: This script is not yet functional. It requires:
  - A GitHub App to be created and installed on the ministryofjustice org
  - The App credentials to be stored in AWS Secrets Manager
  - The corresponding secret name to be configured in user-validation.sh
"""

import base64
import os
import sys

from github import Auth, GithubIntegration


class GitHubAppAuthError(Exception):
    """Raised when an installation access token cannot be generated."""


def get_installation_token():
    """
    Generate an installation access token from GitHub App credentials.

    Returns:
        str: The installation access token

    Raises:
        ValueError: If required environment variables are missing
        GitHubAppAuthError: If token generation fails
    """
    # Get credentials from environment. The variable names are camelCase
    # because they come from the upstream script that invokes this helper.
    app_id = os.getenv("githubAppId")
    installation_id = os.getenv("githubAppInstallationId")
    private_key_b64 = os.getenv("githubAppPrivateKey")

    # Validate credentials
    if not app_id:
        raise ValueError("Missing environment variable: githubAppId")
    if not installation_id:
        raise ValueError("Missing environment variable: githubAppInstallationId")
    if not private_key_b64:
        raise ValueError("Missing environment variable: githubAppPrivateKey")

    try:
        # Decode base64-encoded private key
        private_key = base64.b64decode(private_key_b64).decode("utf-8")

        # Create GitHub Integration using new Auth API
        auth = Auth.AppAuth(app_id, private_key)
        integration = GithubIntegration(auth=auth)

        # Get installation access token
        access_token = integration.get_access_token(int(installation_id))

        return access_token.token
    except Exception as e:
        message = f"Failed to generate installation token: {e}"
        raise GitHubAppAuthError(message) from e


def main():
    """Main function to get and print the token."""
    try:
        token = get_installation_token()
    except (GitHubAppAuthError, ValueError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    print(token)
    return 0


if __name__ == "__main__":
    sys.exit(main())
