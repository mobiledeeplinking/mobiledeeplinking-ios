//
//  RegexValidationTest.m
//  MobileDeepLinking
//
//  Created by Ethan on 1/28/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <XCTest/XCTest.h>

#define EXP_SHORTHAND

#import <Expecta/Expecta.h>
#import "MobileDeepLinking.h"
#import "MobileDeepLinking_Private.h"

@interface RegexValidationTest : XCTestCase

@end

@implementation RegexValidationTest
{
    MobileDeepLinking *mobileDeepLinking;
    NSDictionary *routeOptions;
    NSMutableDictionary *results;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:@"routeParameters", [[NSDictionary alloc] init], nil];
    results = [[NSMutableDictionary alloc] init];

}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testRegexMatches
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"name", nil], @"routeParameters", nil];
    expect([mobileDeepLinking validateRouteComponent:@"name" value:@"3" routeOptions:routeOptions])
            .to.equal(YES);
}

- (void)testRegexDoesNotMatch
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"name", nil], @"routeParameters", nil];
    expect([mobileDeepLinking validateRouteComponent:@"name" value:@"32" routeOptions:routeOptions])
            .to.equal(NO);
}

- (void)testRegexDoesNotMatch2
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"name", nil], @"routeParameters", nil];
    expect([mobileDeepLinking validateRouteComponent:@"name" value:@"hello" routeOptions:routeOptions])
            .to.equal(NO);
}

@end
