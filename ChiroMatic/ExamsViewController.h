//
//  ExamsViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/24/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Exam.h"
#import "EditViewController.h"
#import "Patient.h"
#import "Report.h"

@interface ExamsViewController : CoreDataTableViewController

@property (weak, nonatomic) NSManagedObject* currentSuperobject;
@property (weak, nonatomic) EditViewController* delegate;
@property (weak, nonatomic) Report* currentReport;
@property Exam* currentlySelectedExam;

@end
