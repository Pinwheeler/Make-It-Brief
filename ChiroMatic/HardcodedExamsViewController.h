//
//  HardcodedExamsViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "DataPopulator.h"
#import "Exam+ValueColumns.h"
#import "ChiroMaticAppDelegate.h"

@interface HardcodedExamsViewController : UITableViewController
@property (strong, nonatomic) Exam* currentObject;

@end
