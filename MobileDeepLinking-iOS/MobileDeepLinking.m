//
//  MobileDeepLinking_iOS.m
//  MobileDeepLinking-iOS
//
//  Created by Ethan Lo on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileDeepLinking.h"

NSString *MOBILEDEEPLINKING_CONFIG_NAME = @"MobileDeepLinkingConfig";
NSString *ROUTES_JSON_NAME = @"routes";
NSString *STORYBOARD_JSON_NAME = @"storyboard";
NSString *HANDLERS_JSON_NAME = @"handlers";
NSString *CLASS_JSON_NAME = @"class";
NSString *IDENTIFIER_JSON_NAME = @"identifer";

@implementation MobileDeepLinking
{
    NSDictionary *config;
    NSMutableDictionary *handlers;
}

+ (id) sharedInstance
{
    static dispatch_once_t pred;
    static MobileDeepLinking *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[MobileDeepLinking alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        config = [self getConfiguration];
        if (config == nil)
        {
            NSLog(@"MobileDeepLinking configuration file not found!");
            return nil;
        }
    }
    return self;
}


- (NSDictionary *) getConfiguration
{
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:MOBILEDEEPLINKING_CONFIG_NAME ofType:@"json"];
    NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFilePath];
    return [NSJSONSerialization JSONObjectWithData:configData options:0 error:nil];
}

- (void)registerHandlerWithName:(NSString *)name handler:(void (^)(NSDictionary *))handler
{
    if (handlers == nil)
    {
        handlers = [[NSMutableDictionary alloc] init];
    }
    [handlers setObject:[handler copy] forKey:name];
}

- (void) routeUsingUrl:(NSURL *)url viewController:(UIViewController *)viewController
{
    NSDictionary *routes = [config objectForKey:ROUTES_JSON_NAME];
    NSString *storyboardName = [config objectForKey:STORYBOARD_JSON_NAME];
    for (id route in routes)
    {
        if ([self matcherWithPath:route url:url])
        {
            NSDictionary *routeOptions = [routes objectForKey:route];

            // check to see if route has handlers
            if ([routeOptions objectForKey:HANDLERS_JSON_NAME] != nil)
            {
                NSArray *routeHandlers = [routeOptions objectForKey:HANDLERS_JSON_NAME];
                for (int i = 0; i < [routeHandlers count]; i++)
                {
                    void(^handlerBlock)(NSDictionary *) = [handlers objectForKey:routeHandlers[i]];
                    NSDictionary *routeParams = [self getRouteParamsWithRoute:route routeOptions:routeOptions url:url];
                    handlerBlock(routeParams);
                }
            }

            // check to see if route has a class
            if ([routeOptions objectForKey:CLASS_JSON_NAME] != nil)
            {
                // construct view controller
                id newViewController = [self buildNewViewControllerWithRouteOptions:routeOptions storyboard:storyboardName];

                // set attributes
                NSDictionary *routeParams = [self getRouteParamsWithRoute:route routeOptions:routeOptions url:url];
                for (id param in routeParams)
                {
                    [newViewController setValue:[routeParams objectForKey:param] forKey:param];
                }

                // push view controller
                [viewController presentViewController:newViewController animated:YES completion:nil];
            }
        }
    }
}

/**
* TODO - build this
*/
- (NSDictionary *)getRouteParamsWithRoute:(id)route routeOptions:(NSDictionary *)options url:(NSURL *)url
{
    NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
    [testDict setObject:@"banana" forKey:@"name"];
    return testDict;
}

- (id) buildNewViewControllerWithRouteOptions:(NSDictionary *)routeOptions storyboard:(NSString *) storyboardName {
    if ([routeOptions objectForKey:STORYBOARD_JSON_NAME])
    {
        storyboardName = [routeOptions objectForKey:STORYBOARD_JSON_NAME];
    }

    if (storyboardName == nil)
    {
        // TODO: instantiate view controller the old fashioned way without storyboard.
        return nil;
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:[routeOptions objectForKey:IDENTIFIER_JSON_NAME]];
    }
}

- (BOOL) matcherWithPath: (id)path url: (NSURL *)url
{
    // TODO: do path matching here
    return YES;
}

- (void) dealloc
{
    abort();
}


@end
