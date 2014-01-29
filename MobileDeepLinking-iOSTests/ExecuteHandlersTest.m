//
//  ExecuteHandlersTest.m
//  MobileDeepLinking
//
//  Created by Ethan on 1/28/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MobileDeepLinking_Private.h"

#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface ExecuteHandlersTest : XCTestCase

@end

@implementation ExecuteHandlersTest
{
    MobileDeepLinking *mobileDeepLinking;
    NSDictionary *routeOptions;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:@"testHandler", nil], @"handlers", nil];
}

- (void)testHandlerExecutes
{
    [mobileDeepLinking registerHandlerWithName:@"testHandler" handler:^void(NSDictionary *params)
    {
        [params setValue:@"value" forKey:@"name"];
    }];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [mobileDeepLinking executeHandlers:routeOptions routeParams:routeParams error:NULL ];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value", @"name", nil];
    expect(routeParams).to.equal(expected);
}

- (void)testMultipleHandlersExecuteInOrder
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSArray alloc] initWithObjects:@"testHandler", @"testHandler2", nil], @"handlers", nil];


    [mobileDeepLinking registerHandlerWithName:@"testHandler" handler:^void(NSDictionary *params)
    {
        [params setValue:@"value" forKey:@"name"];
    }];

    [mobileDeepLinking registerHandlerWithName:@"testHandler2" handler:^void(NSDictionary *params)
    {
        [params setValue:@"value2" forKey:@"name"];
    }];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [mobileDeepLinking executeHandlers:routeOptions routeParams:routeParams error:NULL ];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value2", @"name", nil];
    expect(routeParams).to.equal(expected);
}

- (void)testMultipleHandlersExecuteInDifferentOrder
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSArray alloc] initWithObjects:@"testHandler2", @"testHandler", nil], @"handlers", nil];


    [mobileDeepLinking registerHandlerWithName:@"testHandler" handler:^void(NSDictionary *params)
    {
        [params setValue:@"value" forKey:@"name"];
    }];

    [mobileDeepLinking registerHandlerWithName:@"testHandler2" handler:^void(NSDictionary *params)
    {
        [params setValue:@"value2" forKey:@"name"];
    }];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [mobileDeepLinking executeHandlers:routeOptions routeParams:routeParams error:NULL ];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value", @"name", nil];
    expect(routeParams).to.equal(expected);
}

@end
