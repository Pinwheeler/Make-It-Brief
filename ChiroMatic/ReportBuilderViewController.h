//
//  ReportBuilderViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/24/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EditViewController.h"
#import "ExamsViewController.h"
#import "Report.h"
#import "Patient.h"
#import "Insurance.h"
#import "UnmanagedReport.h"
#import "PrintViewDatasource.h"
#import "PrintViewController.h"
#import "ReportModalTableViewController.h"
#import "DataPopulator.h"
#import "CustomPopoverDelegate.h"

@interface ReportBuilderViewController : EditViewController <PrintViewDatasource,DataPopulator,UIPopoverControllerDelegate,CustomPopoverDelegate>

@property (weak, nonatomic) IBOutlet UILabel *insuranceField;
@property (weak, nonatomic) IBOutlet UILabel *policyNumberField;
@property (weak, nonatomic) IBOutlet UITextField *examNameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *resultField;
@property (weak, nonatomic) IBOutlet UILabel *contactField;
@property (weak, nonatomic) IBOutlet UITextField *reportNameField;
@property (weak, nonatomic) IBOutlet UIView *patientTableViewWindow;

- (IBAction)generateReport:(id)sender;


//Form Options
@property (weak, nonatomic) IBOutlet UITextField *actionLabelTreatment;
@property (weak, nonatomic) IBOutlet UITextField *actionLabelDuration;
@property (weak, nonatomic) IBOutlet UITextField *actionLabelPurpose;
- (IBAction)treatmentModalPopover:(UIButton *)sender;
- (IBAction)durationModalPopover:(UIButton *)sender;
- (IBAction)purposeModalPopover:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *prognosisLabelExpectation;
@property (weak, nonatomic) IBOutlet UITextField *prognosisLabelFollowup;
- (IBAction)expectationModalPopover:(UIButton *)sender;
- (IBAction)followupModalPopover:(UIButton *)sender;

- (IBAction)actionStateChanged:(UISwitch *)sender;
- (IBAction)prognosisStateChanged:(UISwitch *)sender;

@property (weak, nonatomic) IBOutlet UIView *findingsTable;








@end
