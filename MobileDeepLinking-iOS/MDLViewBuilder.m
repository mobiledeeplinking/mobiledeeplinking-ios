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

#import "MDLViewBuilder.h"
#import "MDLError.h"
#import "MDLConfig.h"
#import "MDLViewNavigator.h"


@implementation MDLViewBuilder

/**
* Display View based on presence of storyboard, identifier, and class.
*/
+ (BOOL)displayView:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams config:(MDLConfig *)config error:(NSError **)error
{
    // construct view controller
    id newViewController = [self buildViewController:routeOptions config:config];
    if (!newViewController)
    {
        if (config.logging)
        {
            NSLog(@"No View Controllers found in route options.");
        }
        return NO;
    }

    BOOL success = [self setPropertiesOnViewController:newViewController routeParams:routeParams config:config];
    if (!success)
    {
        [MDLError setError:error withMessage:[NSString stringWithFormat:@"Setting properties on %@ failed.", NSStringFromClass([newViewController class])]];
        return NO;
    }

    // push view controller
    MDLViewNavigator *viewNavigator = [[MDLViewNavigator alloc] initWithRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    [viewNavigator showViewController:newViewController];
    return YES;
}

/**
* Depending on the combination of storyboard, identifier, and class, build a view controller.
*/
+ (id)buildViewController:(NSDictionary *)routeOptions config:(MDLConfig *)config
{
    NSString *storyboardName = [self getStoryboardName:config.storyboard];

    if ([routeOptions objectForKey:STORYBOARD_JSON_NAME])
    {
        storyboardName = [self getStoryboardName:[routeOptions objectForKey:STORYBOARD_JSON_NAME]];
    }

    NSString *identifier = [routeOptions objectForKey:IDENTIFIER_JSON_NAME];
    NSString *class = [routeOptions objectForKey:CLASS_JSON_NAME];

    if (([storyboardName length] != 0) && ([identifier length] != 0))
    {
        if (config.logging)
        {
            NSLog(@"Routing to %@.", [routeOptions objectForKey:IDENTIFIER_JSON_NAME]);
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:[routeOptions objectForKey:IDENTIFIER_JSON_NAME]];
    }
    else if (([class length] != 0) && ([identifier length] != 0))
    {
        // Create view controller with nib.
        if (config.logging)
        {
            NSLog(@"Routing to %@.", [routeOptions objectForKey:CLASS_JSON_NAME]);
        }
        return [[NSClassFromString([routeOptions objectForKey:CLASS_JSON_NAME]) alloc] initWithNibName:[routeOptions objectForKey:IDENTIFIER_JSON_NAME] bundle:nil];
    }
    else if ([class length] != 0)
    {
        // Create a old-fashioned view controller without storyboard or nib.
        if (config.logging)
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

+ (NSString *)getStoryboardName:(NSDictionary *)storyboard
{
    NSString * storyboardName = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        storyboardName = [storyboard objectForKey:STORYBOARD_IPHONE_NAME];
    }
    else
    {
        storyboardName = [storyboard objectForKey:STORYBOARD_IPAD_NAME];

        // if ipad storyboard is not defined, fall back to iphone storyboard
        if (storyboardName == nil)
        {
            storyboardName = [storyboard objectForKey:STORYBOARD_IPHONE_NAME];
        }
    }
    return storyboardName;
}

+ (BOOL)setPropertiesOnViewController:(UIViewController *)viewController routeParams:(NSDictionary *)routeParams config:(MDLConfig *)config
{
    for (id routeParam in routeParams)
    {
        NSError *error = nil;
        // Validation follows pattern described here: https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html
        // User can create custom validators for their properties. If none exist, validateValue will return YES by default.
        id valueToValidate = [routeParams objectForKey:routeParam];
        BOOL valid = [viewController validateValue:&valueToValidate forKey:routeParam error:&error];
        if (valid == NO)
        {
            if (config.logging)
            {
                NSLog(@"Validation error when setting key:%@. Reason:%@", routeParam, error.localizedDescription);
            }
            return NO;
        }

        @try
        {
            [viewController setValue:valueToValidate forKey:routeParam];
        }
        @catch (NSException *e)
        {
            if (config.logging)
            {
                NSLog(@"Unable to set property: %@ on %@.", routeParam, NSStringFromClass([viewController class]));
            }
        }
    }
    return YES;
}

@end