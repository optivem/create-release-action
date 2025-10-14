# Create Release Action

A GitHub Action that creates GitHub releases for any pipeline stage (deployment, signoff, production). This action is perfect for tracking deployments and status changes throughout your CI/CD pipeline.

## Features

- 🚀 Create releases for any environment (QA, Staging, Production)
- 📊 Track deployment status (deployed, passed, failed)
- 📦 Include artifact URLs in release notes
- 🏷️ Support for prerelease and full releases
- 🎨 Rich, formatted release notes with emojis
- 🔗 Automatic linking to workflow runs and commits

## Usage

### Basic Example

```yaml
- name: Create Release
  uses: optivem/create-release-action@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    base-version: 'v1.0.4-rc'
    release-version: 'v1.0.4-rc-qa-deployed'
    environment: 'qa'
    status: 'deployed'
```

### Advanced Example with Artifacts

```yaml
- name: Create Release
  uses: optivem/create-release-action@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    base-version: 'v1.0.4-rc'
    release-version: 'v1.0.4-rc-prod-deployed'
    environment: 'production'
    status: 'deployed'
    artifact-urls: '["https://registry.com/myapp:1.0.4", "https://packages.com/myapp-1.0.4.zip"]'
    is-prerelease: 'false'
```

### Complete Workflow Example

```yaml
name: Deploy and Release

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to deploy'
        required: true
        type: string
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options:
          - qa
          - staging
          - production

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Deploy Application
        run: |
          echo "Deploying ${{ inputs.version }} to ${{ inputs.environment }}"
          # Your deployment logic here

      - name: Create Deployment Release
        uses: optivem/create-release-action@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          base-version: ${{ inputs.version }}
          release-version: '${{ inputs.version }}-${{ inputs.environment }}-deployed'
          environment: ${{ inputs.environment }}
          status: 'deployed'
          artifact-urls: '["https://registry.com/myapp:${{ inputs.version }}"]'
          is-prerelease: ${{ inputs.environment != 'production' }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `base-version` | Original version that triggered the workflow (e.g., `v1.0.4-rc`) | Yes | - |
| `release-version` | Release version tag to create (e.g., `v1.0.4-rc-qa-deployed`) | Yes | - |
| `environment` | Environment name (e.g., `qa`, `staging`, `prod`) | Yes | - |
| `status` | Status (e.g., `deployed`, `passed`, `failed`) | Yes | - |
| `artifact-urls` | JSON array of artifact URLs (Docker images, packages, etc.) | No | `[]` |
| `is-prerelease` | Whether this is a prerelease | No | `true` |

## Outputs

| Output | Description |
|--------|-------------|
| `release-url` | URL of the created GitHub release |

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `GITHUB_TOKEN` | GitHub token with repository write permissions | Yes |

## Status Icons

The action automatically adds appropriate emoji icons based on the status:

- 🚀 `deployed`
- ✅ `passed` 
- ❌ `failed`
- 📊 Other statuses

## Release Notes Format

The action generates rich release notes that include:

- Status icon and environment information
- Original and status versions
- Environment and status details
- Link to the workflow run
- Commit information and author
- List of artifacts (if provided)
- Timestamp

Example release notes:
```
# 🚀 QA Deployed

**Original Version:** v1.0.4-rc  
**Status Version:** v1.0.4-rc-qa-deployed  
**Environment:** qa  
**Status:** deployed  
**Workflow:** [12345678](https://github.com/owner/repo/actions/runs/12345678)  
**Commit:** [abc1234](https://github.com/owner/repo/commit/abc1234...)  
**Actor:** username  

## 📦 Artifacts

- https://registry.com/myapp:1.0.4
- https://packages.com/myapp-1.0.4.zip

---
*Created: 2023-10-14 15:30:45 UTC*
```

## Requirements

- GitHub repository with Actions enabled
- `GITHUB_TOKEN` with repository write permissions
- PowerShell execution environment (included in GitHub-hosted runners)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/optivem/create-release-action/issues).
