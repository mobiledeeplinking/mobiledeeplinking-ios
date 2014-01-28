//
//  MobileDeepLinking_iOSTests.m
//  MobileDeepLinking-iOSTests
//
//  Created by Ethan on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MobileDeepLinking_Private.h"


// #define EXP_OLD_SYNTAX // enable backward-compatibility
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

@interface MatchDeeplinkTest : XCTestCase

@end

@implementation MatchDeeplinkTest
{
    MobileDeepLinking *mobileDeepLinking;
    NSDictionary *routeOptions;
    NSMutableDictionary *results;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:@"routeParameters", [[NSDictionary alloc]init], nil];
    results = [[NSMutableDictionary alloc] init];
    
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - match path parameters

- (void)testMatcherReturnTrueWithHost
{
    XCTAssertTrue([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://data"] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithHost
{
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dataa"] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithHost2
{
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://ata"] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithHost3
{
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:@"mdldemo://dat"] results:results error:nil]);
}

- (void)testMatcherReturnTrueWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertTrue([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnTrueWithPathAndTrailingSlash
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path/";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertTrue([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pathe";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithPath2
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pat";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithPath3
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://daa/path";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnTrueWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertTrue([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnTrueWithPathParamsAndTrailingSlash
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5/";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertTrue([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

- (void)testMatcherReturnFalseWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path//";
    XCTAssertFalse([mobileDeepLinking matchPathParameters:@"data" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertTrue([mobileDeepLinking matchPathParameters:@"data/path" routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
    XCTAssertFalse([mobileDeepLinking matchPathParameters:path routeOptions:routeOptions deeplink:[[NSURL alloc] initWithString:url] results:results error:nil]);
}

#pragma mark - match query parameters

- (void)testQueryMatcherReturnTrueWithHost
{
   XCTAssertTrue([mobileDeepLinking matchQueryParameters:@"?name=value" routeOptions:routeOptions result:results error:nil]);
}

@end
