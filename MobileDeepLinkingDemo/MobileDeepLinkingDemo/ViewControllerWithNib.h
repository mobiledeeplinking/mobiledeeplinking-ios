//
//  ViewControllerWithNib.h
//  MobileDeepLinkingDemo
//
//  Created by Ethan on 1/29/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerWithNib : UIViewController
{
    IBOutlet UILabel *label;
}

@property(retain, nonatomic) IBOutlet UILabel *label;
@property(nonatomic, strong) id saleId;

@end
