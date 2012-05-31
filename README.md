# Apple-Generic Versioning

This project illustrates the use of Apple-generic versioning. The project contains a simple stub framework with unit testing. The framework _does_ nothing; it only gives you a version number and version string. The tests verify that versioning works.

It intends to act as a form of template for creating new projects that employ versioning using Apple's generic scheme. It contains code templates for copying to your own projects, specifically `Versioning.[hm]` source files; and extracts from `AppleGenericVersioning.xcconfig` for pasting to your own project's build settings.

## Major, Minor, Patch

Apple's generic versioning scheme does not support typical X.Y.Z version numbers very well. Apple uses `double`s for numeric versions. Hence version numbers are either integers (in fact, floats without a fraction) or floating-point numbers. X.Y.Z cannot fit within a floating-point number--too many decimal points.

This is what Apple documentation says about `CURRENT_PROJECT_VERSION`, the project build setting for carrying the version number.

> This setting defines the the current version of the project. The value must be a integer or floating point number like 57 or 365.8.

If generic versioning does not support major.minor.patch numbers, what _does_ it support?

## Short Version, Long Version

Mac application and framework bundles have __two__ version numbers: short and, well, not so short. Short version is also known as _marketing_ version. The not-so-long version is really the _build_ version.

Accordingly, an application's _About_ panel computes version numbers using the format "Version MV (BV)" by default; where MV is short for Marketing Version, and BV short for Build Version. See Apple's Technical Note [TN2179](http://developer.apple.com/library/mac/#technotes/tn2179/_index.html) for more details.

## Mach-O Versioning

Further complications exist for frameworks and dynamic libraries.

Frameworks and libraries under OS X also carry other version numbers within the Mach-O binary, namely the _current_ version and the _compatibility_ version. Both these three-component X.Y.Z version numbers have some basic size limitations. All components are integers of course; but due to bit-width allocations, major has a maximum of 65,535 while minor and patch have a maximum of 255. You can guess why. Mach-O format uses 16 bits and 8 bits two store these numbers within the dynamic-library binary.

Note that Mach-O version numbers _are_ explicitly three-tiered X.Y.Z numbers. In fact, if you run `otool -L` on the binaries, shorter version numbers extend by adding zeros.

## Reconciling With Major.Minor.Patch

How to map major.minor.patch version scheme to Apple's generic versioning?

`CURRENT_PROJECT_VERSION` by default defines the bundle version (long, i.e. build version) _and_ at the same time the dynamic library version number. That is, `DYLIB_CURRENT_VERSION` tracks `CURRENT_PROJECT_VERSION`. When you change the build-version number using Apple's `agvtool` (Apple-generic versioning tool), you change both the current library and current project version together.

That being the case, marketing version can track major.minor version bumps while long build version becomes a rolling patch number; rolling because it never resets. It acts as a build stamp. In this Apple-generic reconciliation with major.minor.patch therefore we have:

* Market major: major incompatibility changes
* Market minor: minor compatible changes
* Build major: rolling build counter
* Build minor: not used

If you are using Git for version control, the build version can become the number of commits.

## When to Bump Versions

Make version increments with reference to your public API.

1. Bump the short major version number when incompatible API changes occur. This includes: removing things, changing things in terms of size or visibility or semantics.

   When you increment the major version, reset the minor version to zero. Let the long version continue incrementing.

2. Bump the short minor version number when _compatible_ API changes occur. This includes adding new things.
3. Bump the long version number when any change occurs.

[semver]:http://semver.org/

## How to Bump Versions

### Long Version Bumps (Build Version)

	agvtool new-version X.Y

sets

	CURRENT_PROJECT_VERSION = X.Y
	DYLIB_CURRENT_VERSION = X.Y

### Short Version Bumps (Marketing Version)

	agvtool new-marketing-version X.Y

sets `CFBundleShortVersionString` in your `Info.plist`. This bump changes nothing else, just the marketing version.

# Branches

This project has two branches:

- master (ARC-based version)
- mrr

Only one small difference separates the two branches: automatic reference counting. The master branch employs ARC whereas `mrr` employs the manual retain-release memory management strategy.

