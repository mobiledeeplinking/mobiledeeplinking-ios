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

#import <UIKit/UIKit.h>
#import "MDLViewNavigator.h"


@implementation MDLViewNavigator

@synthesize rootViewController = _rootViewController;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self)
    {
        _rootViewController = rootViewController;
    }
    return self;
}

/**
 * Attempts to show view on UINavigationController. Assumes that rootViewController is either UINavigationController or UITabBarView with a child UINavigationController.
 * If UINavigationController is not found, replace rootViewController with selected view controller.
 */
- (void)showViewController:(UIViewController*)viewController
{
    if ([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        [self pushViewControllerOntoRoot:(UINavigationController *) _rootViewController controller:viewController];
    }
    else if ([_rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)_rootViewController;
        for (UIViewController *controllerInTabBar in tabBarController.viewControllers)
        {
            if ([viewController isKindOfClass:[controllerInTabBar class]])
            {
                [tabBarController setSelectedViewController:controllerInTabBar];
                return;
            }
        }
        
        if ([[tabBarController.viewControllers objectAtIndex:0] isKindOfClass:[UINavigationController class]])
        {
            [self pushViewControllerOntoRoot:(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] controller:viewController];
            [tabBarController setSelectedIndex:0];
        }
    }
    else
    {
        [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
    }
}

- (void) pushViewControllerOntoRoot:(UINavigationController *)navController controller:(UIViewController *)viewController
{
    [navController popToRootViewControllerAnimated:NO];
    
    if (![viewController isKindOfClass:[navController.viewControllers[0] class]])
    {
        [navController pushViewController:viewController animated:YES];
    }
}


@end