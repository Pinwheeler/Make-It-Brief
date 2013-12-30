//
//  ChiroMaticViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ChiroMaticViewController.h"

@interface ChiroMaticViewController ()

@end

@implementation ChiroMaticViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segueButtonPressed:(UIButton*)sender {
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%@ Master Segue",sender.currentTitle] sender:self];
    //[self performSegueWithIdentifier:[NSString stringWithFormat:@"%@ Detail Segue",sender.currentTitle] sender:self];
    
    UINavigationController* nc = self.splitViewController.viewControllers.lastObject;
    UIViewController *vc = nc.viewControllers.lastObject;
    [vc performSegueWithIdentifier:[NSString stringWithFormat:@"%@ Detail Segue",sender.currentTitle] sender:vc];
     
}
@end
