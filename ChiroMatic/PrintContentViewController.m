//
//  PrintContentViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "PrintContentViewController.h"

@interface PrintContentViewController ()

@end

@implementation PrintContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // add logging message so I can confirm that the frame is set correctly
    
    NSLog(@"%s: self.view.frame=%@", __FUNCTION__, NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
