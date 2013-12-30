//
//  ReportBuilderMasterViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/24/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ReportBuilderMasterViewController.h"

@interface ReportBuilderMasterViewController ()

@end

@implementation ReportBuilderMasterViewController

- (void) viewWillDisappear:(BOOL)animated
{
    id vc = self.splitViewController.viewControllers.lastObject;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nc = vc;
        [nc popToRootViewControllerAnimated:NO];
    }
}

@end
