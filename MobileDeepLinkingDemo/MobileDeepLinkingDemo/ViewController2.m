//
// Created by Ethan on 1/21/14.
// Copyright (c) 2014 mobiledeeplinking. All rights reserved.
//

#import "ViewController2.h"


@implementation ViewController2 {

}

@synthesize name;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(name);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end