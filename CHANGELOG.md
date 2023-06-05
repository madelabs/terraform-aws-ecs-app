# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- Add capacity provider support to support spot instances for cost savings

## [0.0.3] - DATE TBD

### Changed

- Remove creation of cluster in this module. Add variable for input for cluster ARN. 
- Remove the unnecessary templates folder.
- Add conditional creation of permissions boundary for roles, default to no permissions boundary. 
- Add SSM Docker Exec support to ECS task. Defaults to false. 
- Add variable for Fargate Platform Version. 
- Add ability to launch the ECS resources and ALB resources in separate VPCs. 
- Add Github Actions for generating README.md and checks for formatting and validation.
- Add ability to turn on stickiness on the load balancer target group.
- ALB target group naming shortened to decrease chance of hitting character limit.

## [0.0.2] - 2023-04-24

### Fixed

- Fixed reference to renamed security group.
- Remove unnecessary log stream. (each container will make their own)
- Adjust ALB variables
- Adjust ECS variables
- Add IAM actions variable
- Forced HTTPS on the ALB and added ACM certificate

## [0.0.1] - 2023-04-18

### Added

- Added the initial version of the module.

---

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Guiding Principles

- Changelogs are for humans, not machines.
- There should be an entry for every single version.
- The same types of changes should be grouped.
- Versions and sections should be linkable.
- The latest version comes first.
- The release date of each version is displayed.
- Mention whether you follow Semantic Versioning.

Types of changes

- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for now removed features.
- **Fixed** for any bug fixes.
- **Security** in case of vulnerabilities.
