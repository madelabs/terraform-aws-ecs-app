# Changelog

All notable changes to this project will be documented in this file.

## [0.0.8] - 2023-09-18

### Fixed

- Added ingress block for ALB redirect port on the ALB security group.

## [0.0.7] - 2023-09-15

### Added

- Added redirect ALB listener.

## [0.0.6] - 2023-08-17

### Changed

- Added write-all permissions to GitHub Action workflow.

## [0.0.5] - 2023-07-14

### Added

- Required minimum version of Terraform to `1.5.2`
- Required minimum version of `hashicorp/aws` provider to `5.0.0`
- Added capacity provider strategy configuration to ECS service.
- Added cloudwatch event alerts for ECS service deployments. 
- Added deployment circuit breaker configuration to ECS service.

## [0.0.4] - 2023-06-08

### Added

- Add ALB timeout variable.
- Add container environment variable to task definition. 

## [0.0.3] - 2023-06-06

### Changed

- Remove creation of cluster in this module. Add variable for input for cluster ARN.
- Remove the unnecessary templates folder.
- ALB target group naming shortened to decrease chance of hitting character limit.

### Added

- Add conditional creation of permissions boundary for roles, default to no permissions boundary.
- Add SSM Docker Exec support to ECS task. Defaults to false.
- Add variable for Fargate Platform Version.
- Add ability to launch the ECS resources and ALB resources in separate VPCs.
- Add Github Actions for generating README.md and checks for formatting and validation.
- Add ability to turn on stickiness on the load balancer target group.

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
