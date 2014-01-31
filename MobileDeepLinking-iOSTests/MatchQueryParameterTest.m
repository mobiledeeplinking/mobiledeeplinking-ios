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

#define EXP_SHORTHAND

#import <Expecta/Expecta.h>
#import "MobileDeepLinking.h"
#import "MobileDeepLinking_Private.h"
#import "MDLDeeplinkMatcher.h"

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
    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherDoesntMatchWithMultipleParameters
{
    results = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatch
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value" forKey:@"name"];
    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithMultipleParameters
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value" forKey:@"name"];

    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithMultipleParameters2
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] init], @"name2", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"value2" forKey:@"name2"];

    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
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

    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=value&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);
}

- (void)testQueryMatcherMatchWithRegexParameter
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSDictionary alloc] initWithObjectsAndKeys:@"[0-9]", @"regex", nil], @"name", nil], @"routeParameters", nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"6" forKey:@"name"];

    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=6&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(YES);
    expect(results).to.equal(dict);

    results = [[NSMutableDictionary alloc] init];
    expect([MDLDeeplinkMatcher matchQueryParameters:@"name=62&name2=value2" routeOptions:routeOptions result:results error:nil]
    ).to.equal(NO);
}

@end
