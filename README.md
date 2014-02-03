# MobileDeepLinking [![Build Status](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios.png?branch=master)](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios)

This project is the iOS library component of the MobileDeepLinking specification, the industry standard for mobile application deeplinking. This specification and accompanying libraries simplify and reduce implementation of deep links as well as provide flexible and powerful features for routing to custom behavior.

## Features

Given a configuration file (`MobileDeepLinking.json`), this library provides an app the ability to route incoming deeplinks to view controllers or custom logic. It has the ability to automatically instantiate and push view controllers onto the navigation controller, as well the ability to register callback handlers that are executed when matching a deeplink.

### View Routing

When a view is defined in the configuration file, the library will instantiate the viewController as appropriate and then attempt to push it to the appropriate navigation controller. The route parameters defined in the configuration file (path and query parameters) will be set on this viewController.

Three types of viewControllers are supported. They are listed below with the appropriate json configuration settings:

1. Storyboard - requires `storyboard` (storyboard name) and `identifier` (view storyboard identifier) attributes
2. Xib - requires `identifier` (xib name) and `class` (viewController class name) attributes.
3. Non Interface Builder View Controller - requires `class` (viewController class name) attribute.


### Handlers

There may be cases where you need to set up a view before displaying it. This functionality is supported through the use of custom handlers. In the `didFinishLaunchingWithOptions` method in your AppDelegate, you can register blocks (essentially callback functions) that will be executed when an associated route is matched. This association takes place in the configuration json.

These handlers are provided with a NSDictionary with all route parameters found in the deeplink. They can modify the contents of this dictionary, which will be forwarded on to the next handler in the handlers array. Handlers can be reused across multiple routes and can be used in conjucation with view instantiation or entirely on their own.

## Compatibility

This library was developed using ARC and supports iOS 5 and above on all architectures.


## Build

This library follows the iOS Framework build process laid out [here](https://github.com/jverkoey/iOS-Framework). The library can be found in the releases/ folder. It is also available through CocoaPods.

To build from source:

1. Build the `MobileDeepLinking-iOS` scheme. 
2. Build the `Framework` scheme.
3. Expand the `Products` folder in Xcode, right click the .a file, and click "Show in Finder". Within this folder you will see your `.framework` folder. This is the built framework file that can be dropped into other projects.


## Installation

#### Required

Create a `MobileDeepLinking.json` file in your project with your desired routes and options. See demo app and spec for examples.

Insert the following line into the `- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation` method in your AppDelegate:

	[[MobileDeepLinking sharedInstance] routeUsingUrl:url];

#### Optional

Register Custom Handlers (if desired) in your AppDelegate's `didFinishLaunchingWithOptions` method:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    	[[MobileDeepLinking sharedInstance] registerHandlerWithName:@"exampleHandler" handler:^void(NSDictionary *params)
	    {
	        NSLog(@"exampleHandler");
	    }];
	}

## Run Unit Tests

This assumes you have [CocoaPods](http://cocoapods.org/) installed.

1. Run `pod install`
2. Open `MobileDeepLinking.xcworkspace`
3. Test using 'MobileDeepLinking-iOS' scheme.

## Demo App

Part of the `MobileDeepLinking.xcworkspace` includes `MobileDeepLinkingDemo`. This is a demo application that provides an example implementation of the `MobileDeepLinking.json` file, along with several custom handlers that demonstrate how to route to client-specified functionality. It also provides example routing to a storyboard based view, a xib based view, and a view without any Interface Builder elements.

## License

Copyright 2014 MobileDeepLinking.org and other contributors
http://mobiledeeplinking.org

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
