# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-14

### Added
- Initial release of create-release-action
- Support for creating GitHub releases for any pipeline stage
- Rich release notes with status icons and environment information
- Support for artifact URLs in release notes
- Configurable prerelease support
- Automatic linking to workflow runs and commits
- PowerShell-based implementation for cross-platform compatibility

### Features
- Environment-specific release creation (QA, Staging, Production)
- Status tracking (deployed, passed, failed)
- Artifact URL inclusion in release notes
- Customizable release titles and descriptions
- GitHub CLI integration for reliable release creation
- Comprehensive error handling and logging

[Unreleased]: https://github.com/optivem/create-release-action/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/optivem/create-release-action/releases/tag/v1.0.0