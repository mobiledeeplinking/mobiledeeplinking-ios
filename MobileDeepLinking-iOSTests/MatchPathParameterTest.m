// Copyright (C) 2013 by MobileDeepLinking.org
//
// Permission is hereby granted, free of charge, to any
// person obtaining a copy of this software and
// associated documentation files (the "Software"), to
// deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall
// be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "MobileDeepLinking_Private.h"
#import "MDLDeeplinkMatcher.h"

#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface MatchPathParameterTest : XCTestCase

@end

@implementation MatchPathParameterTest
{
    MobileDeepLinking *mobileDeepLinking;
    NSDictionary *routeOptions;
    NSMutableDictionary *results;
    NSError *error;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:@"routeParameters", [[NSDictionary alloc] init], nil];
    results = [[NSMutableDictionary alloc] init];
    error = nil;
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - match path parameters

- (void)testMatcherReturnTrueWithHost
{
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data"] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost
{
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dataa"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost2
{
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://ata"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost3
{
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dat"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path";

    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPathAndTrailingSlash
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path/";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pathe";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath2
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pat";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath3
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://daa/path";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"pathId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnTrueWithPathParamsAndTrailingSlash
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5/";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"pathId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnFalseWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path//";
    expect([MDLDeeplinkMatcher matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([MDLDeeplinkMatcher matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithRegex
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/5"] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"dataId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnFalseWithRegex
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/52"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithRegex2
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([MDLDeeplinkMatcher matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/somedata"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}


@end
