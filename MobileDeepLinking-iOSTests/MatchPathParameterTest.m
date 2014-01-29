//
//  MobileDeepLinking_iOSTests.m
//  MobileDeepLinking-iOSTests
//
//  Created by Ethan on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MobileDeepLinking_Private.h"

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
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data"] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost
{
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dataa"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost2
{
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://ata"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithHost3
{
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dat"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path";

    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPathAndTrailingSlash
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path/";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pathe";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath2
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pat";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithPath3
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://daa/path";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"pathId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnTrueWithPathParamsAndTrailingSlash
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5/";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"pathId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnFalseWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path//";
    expect([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);

    expect([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnTrueWithRegex
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([mobileDeepLinking matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/5"] results:results error:nil]
    ).to.equal(YES);
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5", @"dataId", nil];
    expect(results).to.equal(expected);
}

- (void)testMatcherReturnFalseWithRegex
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([mobileDeepLinking matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/52"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}

- (void)testMatcherReturnFalseWithRegex2
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"dataId", nil], @"routeParameters", nil];

    expect([mobileDeepLinking matchPathParameters:@"data/:dataId" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data/somedata"] results:results error:nil]
    ).to.equal(NO);
    expect(results).to.equal([[NSMutableDictionary alloc] init]);
}


@end
