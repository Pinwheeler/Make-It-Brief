//
//  EmbedViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/22/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface EmbedViewController : CoreDataTableViewController

@property (weak, nonatomic) NSManagedObject* currentSuperObject;
@property (weak, nonatomic) NSString* entityNameListedInTable;

@end
