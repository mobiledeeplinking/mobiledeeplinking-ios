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

#import "MDLDeeplinkMatcher.h"
#import "MDLError.h"


@implementation MDLDeeplinkMatcher

/**
* Match the incoming deeplink on the route options in the JSON. If path or query parameters are encountered, run validation and place
* the result into the NSDictionary * results.
*/
+ (BOOL)matchDeeplink:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error
{
    return [self matchPathParameters:route routeOptions:routeOptions deeplink:deeplink results:results error:error]
            && [self matchQueryParameters:[deeplink query] routeOptions:routeOptions result:results error:error]
            && [self checkForRequiredRouteParameters:routeOptions extractedResults:results error:error];
}

/**
* Match incoming deeplink's path parameters. If wildcard (:path) is encountered, run validation on it and place
* the result into the NSDictionary * results.
*/
+ (BOOL)matchPathParameters:(NSString *)route routeOptions:(NSDictionary *)routeOptions deeplink:(NSURL *)deeplink results:(NSMutableDictionary *)results error:(NSError **)error
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
                BOOL validationSuccess = [self validateRouteComponent:routeComponentName value:deeplinkComponent routeOptions:routeOptions];
                if (validationSuccess)
                {
                    [results setValue:deeplinkComponent forKey:routeComponentName];
                }
                else
                {
                    [MDLError setError:error withMessage:[NSString stringWithFormat:@"Validation for %@ failed.", routeComponentName]];
                    return NO;
                }
            }
            else
            {
                return NO;
            }
        }
    }

    return YES;
}


/**
* Checks route options (which define accepted query parameters) against incoming query parameters.
*
* RESTRICTIONS:
* Query Parameter Names may not be repeated. If they are, we will only get the last one.
* There should not be a query parameter with the same name as the path parameter.
*
* Note, this does handle escaped query parameters.
*
* Precondition: queryString should not start with ?
*/
+ (BOOL)matchQueryParameters:(NSString *)queryString routeOptions:(NSDictionary *)routeOptions result:(NSMutableDictionary *)routeParameterValues error:(NSError **)error
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

            if ([self validateRouteComponent:name value:value routeOptions:routeOptions] == YES)
            {
                [routeParameterValues setValue:value forKey:name];
            }
            else
            {
                [MDLError setError:error withMessage:@"Query Parameter Regex checking failed."];
                return NO;
            }
        }
    }
    return YES;
}

+ (BOOL)checkForRequiredRouteParameters:(NSDictionary *)routeOptions extractedResults:(NSDictionary *)results error:(NSError **)error
{
    NSDictionary *requiredRouteParameterValues = [self getRequiredRouteParameterValues:routeOptions];
    for (NSString *requiredValueKey in requiredRouteParameterValues)
    {
        if ([results objectForKey:requiredValueKey] == nil)
        {
            [MDLError setError:error withMessage:[NSString stringWithFormat:@"%@ route parameter is missing.", requiredValueKey]];
            return NO;
        }
    }
    return YES;
}

+ (NSMutableDictionary *)getRequiredRouteParameterValues:(NSDictionary *)routeOptions
{
    NSMutableDictionary *requiredRouteParameters = [[NSMutableDictionary alloc] init];
    NSDictionary *routeParameters = [routeOptions objectForKey:ROUTE_PARAMS_JSON_NAME];
    for (id routeParameter in routeParameters)
    {
        NSDictionary *routeParameterOptions = [routeParameters objectForKey:routeParameter];
        if ([[routeParameterOptions objectForKey:REQUIRED_JSON_NAME] isEqual:@"true"])
        {
            [requiredRouteParameters setValue:@YES forKey:routeParameter];
        }
    }

    return requiredRouteParameters;
}


/**
* Validate a route component (path or query parameter) against regular expression defined in json.
*/
+ (BOOL)validateRouteComponent:(NSString *)name value:(NSString *)value routeOptions:(NSDictionary *)routeOptions;
{
    NSDictionary *routeParameters = [routeOptions objectForKey:ROUTE_PARAMS_JSON_NAME];
    NSDictionary *pathComponentParameters = [routeParameters objectForKey:name];
    NSString *regexString = [pathComponentParameters objectForKey:REGEX_JSON_NAME];
    if (regexString != nil)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:nil];

        NSArray *matches = [regex matchesInString:value options:0 range:NSMakeRange(0, [value length])];
        return ([matches count] == 1);
    }
    return YES;
}

@end