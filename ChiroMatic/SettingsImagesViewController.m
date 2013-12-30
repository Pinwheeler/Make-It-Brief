//
//  SettingsImagesViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "SettingsImagesViewController.h"

@interface SettingsImagesViewController ()

@end

@implementation SettingsImagesViewController

- (void) viewWillDisappear:(BOOL)animated
{
    id vc = self.splitViewController.viewControllers.lastObject;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nc = vc;
        [nc popToRootViewControllerAnimated:NO];
    }
}

@end
