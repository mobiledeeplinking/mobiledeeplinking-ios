//
//  TrimDeeplinkTest.m
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
