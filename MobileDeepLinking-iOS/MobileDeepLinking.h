//
//  MobileDeepLinking_iOS.h
//  MobileDeepLinking-iOS
//
//  Created by Ethan on 1/21/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileDeepLinking : NSObject

+ (id) sharedInstance;
- (void) registerHandlerWithName:(NSString *)name handler:(void(^)(NSDictionary *))handler;
- (void) routeUsingUrl:(NSURL *)url viewController:(UIViewController *)viewController;

@end
