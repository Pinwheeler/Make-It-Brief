//
//  EmbedInsuranceViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/23/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "EditViewController.h"
#import "Insurance.h"
#import "Patient.h"

@interface EmbedInsuranceViewController : CoreDataTableViewController

@property (weak, nonatomic) NSManagedObject* currentSuperobject;
@property (weak, nonatomic) EditViewController* delegate;

@end
