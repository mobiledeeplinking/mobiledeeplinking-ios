//
//  ViewControllerWithNib.m
//  MobileDeepLinkingDemo
//
//  Created by Ethan on 1/29/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import "ViewControllerWithNib.h"

@interface ViewControllerWithNib ()

@end

@implementation ViewControllerWithNib

@synthesize saleId;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [label setText:saleId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
