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

@interface TrimDeeplinkTest : XCTestCase

@end

@implementation TrimDeeplinkTest
{
    MobileDeepLinking *mobileDeepLinking;
}

- (void)setUp
{
    [super setUp];
    mobileDeepLinking = [MobileDeepLinking sharedInstance];
}

- (void)testTrimDeeplink
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data/54?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://data?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithTrailingSlashes
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data/54/?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://data?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);


    url = [[NSURL alloc] initWithString:@"mdldemo://data/54//////?name=value&name1=value1"];
    expected = [[NSURL alloc] initWithString:@"mdldemo://data?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithoutPath
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithoutHostAndPath
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithLongPath
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data/32/hello/there?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://data/32/hello?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithHost
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data?name=value&name1=value1"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://?name=value&name1=value1"];
    expect([mobileDeepLinking trimDeeplink:url])
            .to.equal(expected);
}

- (void)testTrimDeeplinkWithHost2
{
    NSURL *url = [[NSURL alloc] initWithString:@"mdldemo://data/3"];
    NSURL *expected = [[NSURL alloc] initWithString:@"mdldemo://"];
    expect([mobileDeepLinking trimDeeplink:[mobileDeepLinking trimDeeplink:url]])
            .to.equal(expected);
}

@end
