//
//  MatchQueryParameterTest.m
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

@interface MatchQueryParameterTest : XCTestCase

@end

@implementation MatchQueryParameterTest
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


- (void)testQueryMatcherDoesntMatch
{
    results = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    expect([mobileDeepLinking matchQueryParameters:@"name=value" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherDoesntMatchWithMultipleParameters
{
    results = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    expect([mobileDeepLinking matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatch
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value" forKey:@"name"];
    expect([mobileDeepLinking matchQueryParameters:@"name=value" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithMultipleParameters
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value" forKey:@"name"];

    expect([mobileDeepLinking matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithMultipleParameters2
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name2", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value2" forKey:@"name2"];

    expect([mobileDeepLinking matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithMultipleParameters3
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name", [[NSDictionary alloc] init], @"name2", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value" forKey:@"name"];
    [dict setValue:@"value2" forKey:@"name2"];

    expect([mobileDeepLinking matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithRegexParameter
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"6" forKey:@"name"];

    expect([mobileDeepLinking matchQueryParameters:@"name=6&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);

    results = [[NSMutableDictionary alloc] init];
    expect([mobileDeepLinking matchQueryParameters:@"name=62&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(NO);
}

@end
