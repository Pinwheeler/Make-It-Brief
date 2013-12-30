//
//  ChiroMaticAppDelegate.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ChiroMaticAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) UIImage* imageToBeSaved;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveImageToDisk;

@end
