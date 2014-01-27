//
//  MobileDeepLinking_iOS.m
//  MobileDeepLinking-iOS
//
//  Created by Ethan Lo on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking.org. All rights reserved.
//

#import "MobileDeepLinking.h"

NSString *MOBILEDEEPLINKING_CONFIG_NAME = @"MobileDeepLinkingConfig";
NSString *ROUTES_JSON_NAME = @"routes";
NSString *STORYBOARD_JSON_NAME = @"storyboard";
NSString *HANDLERS_JSON_NAME = @"handlers";
NSString *CLASS_JSON_NAME = @"class";
NSString *IDENTIFIER_JSON_NAME = @"identifier";
NSString *LOGGING_JSON_NAME = @"logging";
NSString *DEFAULT_ROUTE_JSON_NAME = @"defaultRoute";
NSString *ROUTE_PARAMS_JSON_NAME = @"routeParameters";
NSString *REQUIRED_JSON_NAME = @"required";
NSString *REGEX_JSON_NAME = @"regex";

@implementation MobileDeepLinking
{
    NSDictionary *config;
    NSMutableDictionary *handlers;
    BOOL loggingEnabled;
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
        NSError *error = nil;
        config = [self getConfiguration:&error];
        if (config == nil)
        {
            NSLog(@"MobileDeepLinking configuration file error: %@", error);
            return nil;
        }
        loggingEnabled = (BOOL) [config objectForKey:LOGGING_JSON_NAME];
    }
    return self;
}


- (NSDictionary *)getConfiguration:(NSError **)error
{
    NSString *configFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:MOBILEDEEPLINKING_CONFIG_NAME ofType:@"json"];
    NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFilePath];
    return [NSJSONSerialization JSONObjectWithData:configData options:0 error:error];
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
    NSDictionary *routes = [config objectForKey:ROUTES_JSON_NAME];
    NSString *storyboardName = [config objectForKey:STORYBOARD_JSON_NAME];
    NSError *error = nil;

    // base case
    if ([[deeplink path] isEqualToString:@"/"])
    {
        if (loggingEnabled)
        {
            NSLog(@"No Routes Match.");
        }
        [self routeToDefault];
    }

    NSMutableDictionary *routeParameterValues = nil;
    for (id route in routes)
    {
        routeParameterValues = [[NSMutableDictionary alloc] init];
        NSDictionary *routeOptions = [routes objectForKey:route];
        if ([self matchDeeplink:route routeOptions:routeOptions deeplink:deeplink results:routeParameterValues error:&error])
        {
            if (routeParameterValues == nil && error != nil)
            {
                if (loggingEnabled)
                {
                    NSLog(@"Error Getting routeParameterValues: %@", error.localizedDescription);
                }
                [self routeToDefault];
            }

            BOOL success = [self handleRouteWithOptions:routeOptions params:routeParameterValues storyboard:storyboardName];
            if (success == NO)
            {
                if (loggingEnabled)
                {
                    NSLog(@"Error when handling route: %@", error.localizedDescription);
                }
                [self routeToDefault];
            }
            return;
        }
    }

    // trim deeplink
    [self routeUsingUrl:[self trimDeeplink:deeplink]];
}

/**
* Match the incoming deeplink on the route options in the JSON. If path or query parameters are encountered, run validation and place
* the result into the NSDictionary * results.
*/
- (BOOL)matchDeeplink:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error
{
    NSDictionary *requiredRouteParameterValues = [self getRequiredRouteParameterValues:routeOptions];
    BOOL pathMatchSuccess = [self matchPathParameters:route routeOptions:routeOptions deeplink:deeplink results:results error:error];
    BOOL queryParametersSuccess = [self matchQueryParameters:[deeplink query] routeOptions:routeOptions intoDictionary:results error:error];

    if (pathMatchSuccess == NO || queryParametersSuccess == NO)
    {
        return NO;
    }

    for (NSString *requiredValueKey in requiredRouteParameterValues)
    {
        if ([requiredRouteParameterValues objectForKey:requiredValueKey] == nil)
        {
            return NO;
        }
    }

    return YES;
}

/**
* Match incoming deeplink's path parameters. If wildcard (:path) is encountered, run validation on it and place
* the result into the NSDictionary * results.
*/
- (BOOL)matchPathParameters:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error
{
    // routeDefinition: host/routeDefinition/path1?query=string&query2=string
    NSMutableArray *routeComponents = [NSMutableArray arrayWithArray:[route componentsSeparatedByString:@"/"]];
    NSMutableArray *deeplinkComponents = [NSMutableArray arrayWithArray:[[deeplink path] componentsSeparatedByString:@"/"]];

    // [url path] returns /somePath, so componentsSeparatedByString will return @"" as the first element.
    [deeplinkComponents removeObject:@""];

    // if route starts with a host.
    if (![route hasPrefix:@"/"])
    {
        NSString *host = [deeplink host];
        if (![[routeComponents objectAtIndex:0] isEqualToString:host])
        {
            return NO;
        }
        [routeComponents removeObjectAtIndex:0];
    }

    if ([routeComponents count] != [deeplinkComponents count])
    {
        return NO;
    }

    NSString *routeComponent = nil;
    NSString *deeplinkComponent = nil;
    for (int i = 0; i < [routeComponents count]; i++)
    {
        routeComponent = routeComponents[i];
        deeplinkComponent = deeplinkComponents[i];
        if (![routeComponent isEqualToString:deeplinkComponent])
        {
            if ([routeComponent hasPrefix:@":"])
            {
                NSString *routeComponentName = [routeComponent substringFromIndex:1];
                BOOL validationSuccess = [self validateRouteComponent:routeComponentName deeplink:deeplinkComponent routeOptions:routeOptions];
                if (validationSuccess)
                {
                    [results setValue:deeplinkComponent forKey:routeComponentName];
                }
                else
                {
                    return NO;
                }
            }
        }
    }

    return YES;
}

/**
* Validate a path component (ie /:pathId) against regular expression defined in json.
*/
- (BOOL)validateRouteComponent:(NSString *)routeComponent deeplink:(NSString *)deeplinkComponent routeOptions:(NSDictionary *)routeOptions
{
    NSDictionary *routeParameters = [routeOptions objectForKey:ROUTE_PARAMS_JSON_NAME];
    NSDictionary *pathComponentParameters = [routeParameters objectForKey:routeComponent];
    NSString *regexString = [pathComponentParameters objectForKey:REGEX_JSON_NAME];
    if (regexString != nil)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:nil];
        if ([regex numberOfMatchesInString:deeplinkComponent options:0 range:NSMakeRange(0, [deeplinkComponent length])] == 0)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Private Helper Methods

- (void)routeToDefault
{
    if (loggingEnabled)
    {
        NSLog(@"Routing to Default Route.");
    }
    [self handleRouteWithOptions:[config objectForKey:DEFAULT_ROUTE_JSON_NAME] params:nil storyboard:[config objectForKey:STORYBOARD_JSON_NAME]];
}

/**
* This method trims off the last path component in an NSURL.
*/
- (NSURL *)trimDeeplink:(NSURL *)deeplink
{
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[deeplink pathComponents]];
    for (int i = [pathComponents count]; i >= 0; i--)
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
        [pathString stringByAppendingString:@"/"];
        [pathString stringByAppendingString:pathComponents[i]];
    }

    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@", [deeplink scheme], [deeplink host], pathString, [deeplink query]]];
}

/**
* Executes handlers and displays views.
*/
- (bool)handleRouteWithOptions:(NSDictionary *)routeOptions params:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName
{
    BOOL handlerSuccess = [self executeHandlers:routeOptions routeParams:routeParams];
    BOOL success = [self displayView:routeOptions routeParams:routeParams storyboard:storyboardName];
    if (!handlerSuccess || !success)
    {
        return NO;
    }

    return YES;
}

/**
* Execute registered handlers. Note, modifying the routeParams dictionary in your blocks will persist on any
* subsequent handler execution and upon view instantiation.
*/
- (BOOL)executeHandlers:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams
{
    // Execute Handlers for Route
    if ([routeOptions objectForKey:HANDLERS_JSON_NAME] != nil)
    {
        NSArray *routeHandlers = [routeOptions objectForKey:HANDLERS_JSON_NAME];
        for (int i = 0; i < [routeHandlers count]; i++)
        {
            void(^handlerBlock)(NSDictionary *) = [handlers objectForKey:routeHandlers[i]];
            handlerBlock(routeParams);
        }
    }
    return YES;
}

/**
* Display View based on presence of storyboard, identifier, and class.
*/
- (BOOL)displayView:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams storyboard:(NSString *)storyboardName
{

    // Display View for Route
    if ([routeOptions objectForKey:CLASS_JSON_NAME] != nil)
    {
        // construct view controller
        id newViewController = [self buildViewController:routeOptions storyboard:storyboardName];
        if (newViewController == nil)
        {
            return NO;
        }

        for (id routeParam in routeParams)
        {
            NSError *error = nil;
            // Validation follows pattern described here: https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html
            // User can create custom validators for their properties. If none exist, validateValue will return YES by default.
            id valueToValidate = [routeParams objectForKey:routeParam];
            BOOL valid = [newViewController validateValue:&valueToValidate forKey:routeParam error:&error];
            if (valid == NO)
            {
                if (loggingEnabled)
                {
                    NSLog(@"Validation error when setting key:%@. Reason:%@", routeParam, error.localizedDescription);
                }
                return NO;
            }

            // check to see if valueToValidate has changed after validation
            if ([valueToValidate isEqual:[routeParams objectForKey:routeParam]])
            {
                [newViewController setValue:[routeParams objectForKey:routeParam] forKey:routeParam];
            }
            else
            {
                [newViewController setValue:valueToValidate forKey:routeParam];
            }
        }

        // push view controller
        [[UIApplication sharedApplication] keyWindow].rootViewController = newViewController;
    }
    return YES;
}

/**
* Depending on the combination of storyboard, identifier, and class, build a view controller.
*/
- (id)buildViewController:(NSDictionary *)routeOptions storyboard:(NSString *)storyboardName
{
    if ([routeOptions objectForKey:STORYBOARD_JSON_NAME])
    {
        storyboardName = [routeOptions objectForKey:STORYBOARD_JSON_NAME];
    }

    NSString *identifier = [routeOptions objectForKey:IDENTIFIER_JSON_NAME];
    NSString *class = [routeOptions objectForKey:CLASS_JSON_NAME];

    if ((storyboardName != nil) && (identifier != nil))
    {
        if (loggingEnabled)
        {
            NSLog(@"Routing to %@.", [routeOptions objectForKey:IDENTIFIER_JSON_NAME]);
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:[routeOptions objectForKey:IDENTIFIER_JSON_NAME]];
    }
    else if ((class != nil) && (identifier != nil))
    {
        // Create view controller with nib.
        if (loggingEnabled)
        {
            NSLog(@"Routing to %@.", [routeOptions objectForKey:CLASS_JSON_NAME]);
        }
        return [[NSClassFromString([routeOptions objectForKey:CLASS_JSON_NAME]) alloc] initWithNibName:[routeOptions objectForKey:IDENTIFIER_JSON_NAME] bundle:nil];
    }
    else if (class != nil)
    {
        // Create a old-fashioned view controller without storyboard or nib.
        if (loggingEnabled)
        {
            NSLog(@"Routing to %@.", [routeOptions objectForKey:CLASS_JSON_NAME]);
        }
        return [[NSClassFromString([routeOptions objectForKey:CLASS_JSON_NAME]) alloc] init];
    }
    else
    {
        return nil;
    }
}


- (NSDictionary *)getRequiredRouteParameterValues:(NSDictionary *)routeOptions
{
    NSDictionary *requiredRouteParameters = [[NSDictionary alloc] init];
    NSDictionary *routeParameters = [routeOptions objectForKey:ROUTE_PARAMS_JSON_NAME];
    for (id routeParameter in routeParameters)
    {
        NSDictionary *routeParameterOptions = [routeParameters objectForKey:routeParameter];
        if ([[routeParameterOptions objectForKey:REQUIRED_JSON_NAME] isEqual:@"true"])
        {
            if ([routeParameter hasPrefix:@":"])
            {
                [requiredRouteParameters setValue:NO forKey:[routeParameter substringFromIndex:1]];
            }
            else
            {
                [requiredRouteParameters setValue:NO forKey:routeParameter];
            }
        }
    }

    return nil;
}

/**
* Checks route options (which define accepted query parameters) against incoming query parameters.
*
* RESTRICTIONS:
* Query Parameter Names may not be repeated. If they are, we will only get the last one.
* There should not be a query parameter with the same name as the path parameter.
*
* Note, this does handle escaped query parameters.
*/
- (BOOL)matchQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions intoDictionary:(NSMutableDictionary *)routeParameterValues error:(NSError **)error
{
    NSDictionary *routeParameters = [routeOptions objectForKey:ROUTE_PARAMS_JSON_NAME];
    NSArray *queryPairs = [queryString componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in queryPairs)
    {
        NSArray *nameAndValue = [keyValuePair componentsSeparatedByString:@"="];
        if ([nameAndValue count] == 2)
        {
            NSString *name = [[nameAndValue objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // only accept query parameters that have been specified in route parameters
            if ([[routeParameters allKeys] containsObject:name] == NO)
            {
                continue;
            }

            NSString *value = [[nameAndValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [routeParameterValues setValue:value forKey:name];
        }
    }
    return YES;
}

- (void)dealloc
{
    abort();
}


@end
