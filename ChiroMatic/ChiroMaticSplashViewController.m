//
//  ChiroMaticSplashViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/27/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ChiroMaticSplashViewController.h"
#import "PrintViewController.h"

@interface ChiroMaticSplashViewController ()

@end

@implementation ChiroMaticSplashViewController

@synthesize passedObject = _passedObject;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Print View Controller Segue"])
    {
        PrintViewController* pvc = segue.destinationViewController;
        pvc.report = self.passedObject;
    }
}

@end
