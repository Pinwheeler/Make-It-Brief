//
//  ReportModalTableViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPopulator.h"
#import "CustomPopoverDelegate.h"

@interface ReportModalTableViewController : UITableViewController

@property (strong, nonatomic) NSArray* tableOptions;
@property (weak, nonatomic) id <CustomPopoverDelegate> delegate;
- (IBAction)dismissSelf:(id)sender;

@end
