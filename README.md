# OpenWRT-Packages

Onion Packages for OpenWRT firmware. Intended for the Onion Omega2 & Omega2+ devices

![Omega2+ and Omega2S+](https://github.com/OnionIoT/source/raw/openwrt-18.06/omega2-family.png)

## Where can I find the compiled output of this repo?

The latest compiled packages can be found at: http://repo.onioniot.com/omega2/packages/openwrt-22.03.5/

And firmware with these packages can be found at: http://repo.onioniot.com/omega2/images/openwrt-22.03/

--- 

# Continuous Deployment Details

Summary:

|                                         | Development Builds                                               | Release Builds                                               |
|:---------------------------------------:|------------------------------------------------------------------|--------------------------------------------------------------|
| Purpose                                 | Internal use, may not be 100% stable but useful for testing      | Meant for use by general users                               |
| Trigger                                 | Commit to branch                                                 | Github Release created from branch                           |
| Environment variables used during build | `DEV_BUILD`                                                      | none                                                         |
| Package File Output Location            | `http://repo.onioniot.com/omega2-dev/packages/openwrt-$VERSION/` | `http://repo.onioniot.com/omega2/packages/openwrt-$VERSION/` |
| Image File Output Location             | `http://repo.onioniot.com/omega2-dev/images/openwrt-$RELEASE/`   | `http://repo.onioniot.com/omega2/images/openwrt-$RELEASE/`   |

Where:
* `$VERSION` is the `OPENWRT_VERSION` from the `sdk-profile` config file (for example: `22.03.5`)
* `$RELEASE` is the `OPENWRT_RELEASE` from the `imagebuilder-profile` config file (for example: `22.03`)

Image files will be named with the following syntax: `<device-name>-<openwrt-version>-<build-date>.bin`
For example: `onion_omega2-22.03.5-20240318.bin`

## Development Builds in Branches

When a new branch is created from the `openwrt-22.03` branch in the `OnionIoT/OpenWRT-Packages` repository and follows the regular expression pattern `openwrt-2\d.\d\d`, an action is automatically triggered in GitHub Actions. This action then creates a new instance in AWS CodePipeline using Terraform.

This pipeline additionally makes use of two repositories, `OnionIoT/openwrt-imagebuilder-wrapper` and `OnionIoT/openwrt-sdk-wrapper`, using their respective `main` branches. The production and development buildspecs are stored in their respective main branches.

The newly created pipeline, following the pattern corresponding to the regex `openwrt-2\d.\d\d`, utilizes the development buildspec present in the main branch of each of the auxiliary repositories, `OnionIoT/openwrt-imagebuilder-wrapper` and `OnionIoT/openwrt-sdk-wrapper`, and will only be triggered when a new commit is made to the `OnionIoT/OpenWRT-Packages` repository.

During the build process, the `sdk-profile` is copied to the profile of the `openwrt-sdk-wrapper` repository, and, the `imagebuilder-profile` file is copied to the `profile` of the openwrt-imagebuilder-wrapper repository. 

The output files are then stored in the following locations in S3:
- Location of the development package output file: `s3://$OUTPUT_BUCKET/omega2-dev/packages/openwrt-$VERSION`
- Location of the development image output file: `s3://$OUTPUT_BUCKET/omega2-dev/images/openwrt-$RELEASE`

When the created branch following the regex pattern `openwrt-2\d.\d\d` is deleted, the pipeline in AWS CodePipeline will not be automatically deleted because currently, the branch defined as the default branch is `openwrt-18.06` and has not been modified during our work, and automation of the branch deletion event in GitHub Actions can only be done using the default branch.

## Newly Created Releases

When a new release is created on GitHub from the development branches, it is automatically merged into the release branch, triggering the AWS CodePipeline for production. 

The resulting files are stored in the following locations in S3:
- Package output file: `s3://$OUTPUT_BUCKET/omega2/packages/openwrt-$VERSION`
- ImageBuild output file: `s3://$OUTPUT_BUCKET/omega2/images/openwrt-$RELEASE`

## Process: Creating a Release

* Commit update to `omega2-base/Makefile` that changes `PKG_RELEASE` to the current date, in the format `%Y%m%d-%H%M%S`
* Create a new release:
  * Name the release `<OPENWRT_RELEASE>_<DATE>_<NUMBER>` where `<NUMBER>` is `00` and increments by 1 if there are multiple releases needed in a single day
  * Create a tag that's named same as the release, based on the branch in question
  * Populate the Release description with bullet points outlining what's been Added, Changed, Removed, and/or Fixed
  * Also use generate release notes feature
* Publish the release
