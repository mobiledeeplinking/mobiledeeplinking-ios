//
//  MobileDeepLinking_iOSTests.m
//  MobileDeepLinking-iOSTests
//
//  Created by Ethan on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MobileDeepLinking.h"
#import "MobileDeepLinking_Private.h"

@interface MatcherTest : XCTestCase

@end

@implementation MatcherTest
{
    MobileDeepLinking *mobileDeepLinking;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMatcherReturnTrueWithHost
{
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:@"mdldemo://data"]]);
}

- (void)testMatcherReturnFalseWithHost
{
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:@"mdldemo://dataa"]]);
}

- (void)testMatcherReturnFalseWithHost2
{
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:@"mdldemo://ata"]]);
}

- (void)testMatcherReturnFalseWithHost3
{
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:@"mdldemo://dat"]]);
}

- (void)testMatcherReturnTrueWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnTrueWithPathAndTrailingSlash
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/path/";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnFalseWithPath
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pathe";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnFalseWithPath2
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://data/pat";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnFalseWithPath3
{
    NSString *path = @"data/path";
    NSString *url = @"mdldemo://daa/path";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnTrueWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data/path" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnTrueWithPathParamsAndTrailingSlash
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path/5/";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data/path" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

- (void)testMatcherReturnFalseWithPathParams
{
    NSString *path = @"data/path/:pathId";
    NSString *url = @"mdldemo://data/path//";
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:@"data" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertTrue([mobileDeepLinking matchCustomUrlWithRoute:@"data/path" url:[[NSURL alloc] initWithString:url]]);
    XCTAssertFalse([mobileDeepLinking matchCustomUrlWithRoute:path url:[[NSURL alloc] initWithString:url]]);
}

@end
