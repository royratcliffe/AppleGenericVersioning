// AppleGenericVersioningTests AppleGenericVersioningTests.m
//
// Copyright © 2011, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "AppleGenericVersioningTests.h"
#import "AppleGenericVersioning.h"

@implementation AppleGenericVersioningTests

#define PROGRAM_NAME_STRING PROJECT_NAME_STRING
#define AT_HASH "@(#)PROGRAM:" PROGRAM_NAME_STRING "  PROJECT:" PROJECT_NAME_STRING "-"

- (void)testVersionString
{
	STAssertEqualObjects(AppleGenericVersioningVersionString(), @AT_HASH CURRENT_PROJECT_VERSION_STRING, nil);
}

- (void)testVersionCString
{
	STAssertEquals(strcmp((const char *)kAppleGenericVersioningVersionString, AT_HASH CURRENT_PROJECT_VERSION_STRING "\n"), 0, nil);
}

- (void)testVersionNumber
{
	// Use atof on the string form of the version number in cases where the
	// current project version has three components: major, minor and patch. In
	// such cases the embedded Apple-generic version number represents just the
	// major and minor in the form of a double-precision floating-point number:
	// the integer part being the major, the fractional part being the minor.
	STAssertEquals(kAppleGenericVersioningVersionNumber, atof(CURRENT_PROJECT_VERSION_STRING), nil);
}

#define BUNDLE_IDENTIFIER_STRING "uk.co.pioneeringsoftware.AppleGenericVersioning"

- (void)testBundleVersion
{
	// This test assumes that you assign your Info.plist's CFBundleVersion entry
	// to ${CURRENT_PROJECT_VERSION}. Hence when you bump the version using
	// agvtool new-version, the Info.plist bumps in sync.
	NSBundle *bundle = [NSBundle bundleWithIdentifier:@BUNDLE_IDENTIFIER_STRING];
	NSString *bundleVersion = [bundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
	STAssertEqualObjects(bundleVersion, @CURRENT_PROJECT_VERSION_STRING, nil);
}

@end
