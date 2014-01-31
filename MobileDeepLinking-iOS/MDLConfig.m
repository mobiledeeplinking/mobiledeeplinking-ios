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

#import "MDLConfig.h"
#import "MobileDeepLinking.h"


@implementation MDLConfig
{
}

@synthesize logging = _logging;
@synthesize storyboard = _storyboard;
@synthesize routes = _routes;
@synthesize defaultRoute = _defaultRoute;

- (id)initConfiguration
{
    self = [super init];

    if (self)
    {
        NSError *error = nil;
        NSString *configFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:MOBILEDEEPLINKING_CONFIG_NAME ofType:@"json"];
        NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFilePath];
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:configData options:0 error:&error];
        if (config == nil)
        {
            NSLog(@"MobileDeepLinking configuration file error: %@", error);
            return nil;
        }

        _logging = ([[config objectForKey:LOGGING_JSON_NAME] isEqualToString:@"true"]);
        _routes = [config objectForKey:ROUTES_JSON_NAME];
        _storyboard = [config objectForKey:STORYBOARD_JSON_NAME];
        _defaultRoute = [config objectForKey:DEFAULT_ROUTE_JSON_NAME];
    }
    return self;
}

@end