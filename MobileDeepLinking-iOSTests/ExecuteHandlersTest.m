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
#import "MDLHandlerExecutor.h"

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
    NSMutableDictionary * handlers = [[NSMutableDictionary alloc]init];
    [handlers setObject:^void(NSDictionary *params)
     {
         [params setValue:@"value" forKey:@"name"];
     } forKey:@"testHandler"];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [MDLHandlerExecutor executeHandlers:routeOptions routeParams:routeParams handlers:handlers error:NULL];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value", @"name", nil];
    expect(routeParams).to.equal(expected);
}

- (void)testMultipleHandlersExecuteInOrder
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSArray alloc] initWithObjects:@"testHandler", @"testHandler2", nil], @"handlers", nil];
    
    NSMutableDictionary * handlers = [[NSMutableDictionary alloc]init];
    [handlers setObject:^void(NSDictionary *params)
     {
         [params setValue:@"value" forKey:@"name"];
     } forKey:@"testHandler"
    ];
    
    [handlers setObject:^void(NSDictionary *params)
     {
         [params setValue:@"value2" forKey:@"name"];
     } forKey:@"testHandler2"
     ];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [MDLHandlerExecutor executeHandlers:routeOptions routeParams:routeParams handlers:handlers error:NULL ];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value2", @"name", nil];
    expect(routeParams).to.equal(expected);
}

- (void)testMultipleHandlersExecuteInDifferentOrder
{
    routeOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
            [[NSArray alloc] initWithObjects:@"testHandler2", @"testHandler", nil], @"handlers", nil];


    NSMutableDictionary * handlers = [[NSMutableDictionary alloc]init];
    [handlers setObject:^void(NSDictionary *params)
     {
         [params setValue:@"value" forKey:@"name"];
     } forKey:@"testHandler"
     ];
    
    [handlers setObject:^void(NSDictionary *params)
     {
         [params setValue:@"value2" forKey:@"name"];
     } forKey:@"testHandler2"
     ];

    NSMutableDictionary *routeParams = [[NSMutableDictionary alloc] init];
    [MDLHandlerExecutor executeHandlers:routeOptions routeParams:routeParams handlers:handlers error:NULL ];

    NSMutableDictionary *expected = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value", @"name", nil];
    expect(routeParams).to.equal(expected);
}

@end
