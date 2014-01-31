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

#import "MobileDeepLinking.h"
#import "MDLDeeplinkMatcher.h"
#import "MDLHandlerExecutor.h"
#import "MDLViewBuilder.h"
#import "MDLConfig.h"

@implementation MobileDeepLinking
{
    MDLConfig *config;
    NSMutableDictionary *handlers;
}

#pragma mark - Initialization Methods

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static MobileDeepLinking *sharedInstance = nil;
    dispatch_once(&pred, ^
    {
        sharedInstance = [[MobileDeepLinking alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        config = [[MDLConfig alloc] initConfiguration];
    }
    return self;
}

#pragma mark - Public Methods

/**
* Register a Custom Handler Function with the MobileDeepLinking library.
* This method should be called in the application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
* function in AppDelegate.m.
*
* @handlerName - name to register handler function under
* @handlerFunction - a block function declaration that takes in a NSDictionary
*/
- (void)registerHandlerWithName:(NSString *)handlerName handler:(void (^)(NSDictionary *))handlerFunction
{
    if (handlers == nil)
    {
        handlers = [[NSMutableDictionary alloc] init];
    }
    [handlers setObject:[handlerFunction copy] forKey:handlerName];
}

/**
* Route to the appropriate view and/or handler function using the custom url.
* This method should be called in the application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
* function in AppDelegate.m.
*
* @deeplink - The NSURL that comes in openURL in the above function.
*/
- (void)routeUsingUrl:(NSURL *)deeplink
{
    NSError *error = nil;

    // base case
    if (([[deeplink host] length] == 0) &&
            ([[deeplink path] isEqualToString:@"/"] || [[deeplink path] length] == 0))
    {
        if (config.logging)
        {
            NSLog(@"No Routes Match.");
        }
        [self routeToDefault];
        return;
    }

    NSMutableDictionary *routeParameterValues = nil;
    for (id route in config.routes)
    {
        error = nil;
        routeParameterValues = [[NSMutableDictionary alloc] init];
        NSDictionary *routeOptions = [config.routes objectForKey:route];
        if ([MDLDeeplinkMatcher matchDeeplink:route routeOptions:routeOptions deeplink:deeplink results:routeParameterValues error:&error])
        {
            if (routeParameterValues == nil && error != nil)
            {
                if (config.logging)
                {
                    NSLog(@"Error Getting routeParameterValues: %@", error.localizedDescription);
                }
                break;
            }

            BOOL success = [self handleRouteWithOptions:routeOptions params:routeParameterValues error:&error];
            if (!success && error != nil)
            {
                if (config.logging)
                {
                    NSLog(@"Error when handling route: %@", error.localizedDescription);
                }
                break;
            }
            return;
        }
        else
        {
            if (error != nil && config.logging)
            {
                NSLog(@"Route did not match: %@", error.localizedDescription);
                break;
            }
        }
    }

    // trim deeplink
    return [self routeUsingUrl:[self trimDeeplink:deeplink]];
}

#pragma mark - Private Helper Methods

/**
* Executes handlers and displays views.
*/
- (BOOL)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams error:(NSError **)error
{
    return [MDLHandlerExecutor executeHandlers:routeOptions routeParams:routeParams handlers:handlers error:error]
            && [MDLViewBuilder displayView:routeOptions routeParams:routeParams config:config error:error];
}

- (void)routeToDefault
{
    if (config.logging)
    {
        NSLog(@"Routing to Default Route.");
    }
    [self handleRouteWithOptions:config.defaultRoute params:nil error:nil];
}

/**
* This method trims off the last path or host component in an NSURL.
*/
- (NSURL *)trimDeeplink:(NSURL *)deeplink
{
    NSString *deeplinkHost = [deeplink host];
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[deeplink pathComponents]];
    if ([pathComponents count] == 0)
    {
        // path is empty - remove host if host exists
        if (deeplinkHost)
        {
            deeplinkHost = nil;
        }
    }

    for (int i = ((int) [pathComponents count]) - 1; i >= 0; i--)
    {
        // remove any trailing slashes
        if ([pathComponents[i] isEqual:@"/"])
        {
            [pathComponents removeObjectAtIndex:i];
        }
        else
        {
            [pathComponents removeObjectAtIndex:i];
            break;
        }
    }

    NSString *pathString = @"";
    // build path string. Start at i = 1 because first element of pathComponents is always /
    for (int i = 1; i < [pathComponents count]; i++)
    {
        pathString = [pathString stringByAppendingString:@"/"];
        pathString = [pathString stringByAppendingString:pathComponents[i]];
    }

    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@%@%@",
                                                                    [deeplink scheme],
                                                                    (deeplinkHost) ? deeplinkHost : @"",
                                                                    pathString,
                                                                    ([deeplink query]) ? [NSString stringWithFormat:@"?%@", [deeplink query]] : @""]];
}


- (void)dealloc
{
    abort();
}


@end
