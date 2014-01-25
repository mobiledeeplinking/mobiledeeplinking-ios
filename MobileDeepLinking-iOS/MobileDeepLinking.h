//
//  MobileDeepLinking_iOS.h
//  MobileDeepLinking-iOS
//
//  Created by Ethan on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MobileDeepLinking : NSObject

+ (id) sharedInstance;
- (void) registerHandlerWithName:(NSString *)handlerName handler:(void(^)(NSDictionary *))handlerFunction;
- (void)routeUsingUrl:(NSURL *)customUrl;

@end
