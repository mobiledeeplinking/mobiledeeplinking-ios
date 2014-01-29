//
//  GetRequiredRouteParameterValuesTest.m
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

@interface GetRequiredRouteParameterValuesTest : XCTestCase

@end

@implementation GetRequiredRouteParameterValuesTest
{
    MobileDeepLinking *mobileDeepLinking;
    NSDictionary *routeOptions;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:
                    [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"required", nil], @"name"
                    , nil], @"routeParameters", nil];
}

- (void)testGetRequiredRouteParameterValues
{
    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@NO, @"name", nil];
    expect([mobileDeepLinking getRequiredRouteParameterValues:routeOptions])
        .to.equal(expected);
}

- (void)testGetRequiredRouteParameterValuesWithoutAnyRequiredValues
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:
                    [[NSDictionary alloc] initWithObjectsAndKeys:@"false", @"required", nil], @"name"
                    , nil], @"routeParameters", nil];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] init];
    expect([mobileDeepLinking getRequiredRouteParameterValues:routeOptions])
        .to.equal(expected);
}

- (void)testGetRequiredRouteParameterValuesWithoutAnyValues
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:
                    [[NSDictionary alloc] init], @"name"
                    , nil], @"routeParameters", nil];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] init];
    expect([mobileDeepLinking getRequiredRouteParameterValues:routeOptions])
        .to.equal(expected);
}

@end
