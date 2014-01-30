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

#import "MDLHandlerExecutor.h"
#import "MDLError.h"


@implementation MDLHandlerExecutor

/**
* Execute registered handlers. Note, modifying the routeParams dictionary in your blocks will persist on any
* subsequent handler execution and upon view instantiation.
*/
+ (BOOL)executeHandlers:(NSDictionary *)routeOptions routeParams:(NSDictionary *)routeParams handlers:(NSDictionary *)handlers error:(NSError **)error
{
    // Execute Handlers for Route
    if ([routeOptions objectForKey:HANDLERS_JSON_NAME] != nil)
    {
        NSArray *routeHandlers = [routeOptions objectForKey:HANDLERS_JSON_NAME];
        for (int i = 0; i < [routeHandlers count]; i++)
        {
            if ([handlers objectForKey:routeHandlers[i]] != nil)
            {
                void(^handlerBlock)(NSDictionary *) = [handlers objectForKey:routeHandlers[i]];
                handlerBlock(routeParams);
            }
            else
            {
                [MDLError setError:error withMessage:[NSString stringWithFormat:@"Handler %@ has not been registered with the MobileDeepLinking library.", routeHandlers[i]]];
                return NO;
            }
        }
    }
    return YES;
}

@end