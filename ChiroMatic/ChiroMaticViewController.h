//
//  ChiroMaticViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ChiroMaticViewController : UIViewController

@property (strong, nonatomic) UIViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)segueButtonPressed:(UIButton*)sender;
@end
