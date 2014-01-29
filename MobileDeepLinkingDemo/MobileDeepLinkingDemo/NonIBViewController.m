//
//  NonIBViewController.m
//  MobileDeepLinkingDemo
//
//  Created by Ethan on 1/29/14.
//  Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import "NonIBViewController.h"

@interface NonIBViewController ()

@end

@implementation NonIBViewController

@synthesize productId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;

    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    [label setText:[NSString stringWithFormat:@"View Controller Without Storyboard or Nib. ProductId: %@", productId]];

    [label setFrame:CGRectMake((self.view.frame.size.width / 2),
            (self.view.frame.size.height / 2),
            300,
            250)];
    [label setCenter:self.view.center];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
