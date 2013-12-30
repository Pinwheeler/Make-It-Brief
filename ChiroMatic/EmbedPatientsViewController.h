//
//  EmbedPatientsViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Patient.h"
#import "Exam.h"

@interface EmbedPatientsViewController : CoreDataTableViewController

@property (weak,nonatomic) id currentSuperobject;

@end
