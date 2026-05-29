# Container Platform GitHub Access

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/container-platform-github-access/badge)](https://github-community.service.justice.gov.uk/repository-standards/container-platform-github-access)

Infrastructure as Code repository for managing the Container Platform team's GitHub repositories

## Runbooks

- [Repository setup and architecture](runbooks/repo-setup-and-architecture.md)
- [Creating new repositories](runbooks/creating-new-repos.md)
- [Importing existing repositories](runbooks/importing-existing-repos.md)
- [Troubleshooting](runbooks/troubleshooting.md)

## Running Locally

> [!IMPORTANT]
> Only [@ministryofjustice/cloud-platform-engineers](https://github.com/orgs/ministryofjustice/teams/cloud-platform-engineers) can do this

### Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) (~> 1.10)
- [GitHub CLI](https://cli.github.com/), authenticated with `repo` and `read:org` scopes

### Authenticate with GitHub

Export a GitHub token for the Terraform provider:

```bash
export TF_VAR_github_token="$(gh auth token)"
```

## CI/CD

The GitHub Actions workflow (`.github/workflows/terraform.yml`) handles authentication using the **Container Platform Access** GitHub App. It runs:

- use `terraform plan` on pull requests
- use `terraform apply` on merge to `main`

## Contributing

The base branch (`main`) requires all commits to be signed. Unsigned commits will block your PR from merging. Learn more about signing commits in [GitHub's documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).

### Signing Commits

**1. Generate a GPG key** (skip if you already have one):

```bash
gpg --full-generate-key
# Choose: RSA, 4096 bits, set an expiry, use the email associated with your GitHub account
```

**2. Get your key ID**:

```bash
gpg --list-secret-keys --keyid-format=long
# Look for the line: rsa4096/XXXXXXXXXXXXXXXX
```

**3. Export and add to GitHub**:

```bash
gpg --armor --export XXXXXXXXXXXXXXXX
# Copy the output (including -----BEGIN/END PGP PUBLIC KEY BLOCK-----)
# Go to: GitHub > Settings > SSH and GPG keys > New GPG key
```

**4. Configure Git to sign all commits**:

```bash
git config --global user.signingkey XXXXXXXXXXXXXXXX
git config --global commit.gpgsign true
```

**5. Verify it works**:

```bash
echo "test" | gpg --clearsign
# If this produces signed output, you're set
```

If your PR already has unsigned commits, re-sign them:

```bash
git rebase --exec 'git commit --amend --no-edit -S' main
git push --force-with-lease
```

For more detail, see [GitHub's documentation on signing commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).
