//
//  PrintViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/20/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PrintViewDatasource.h"
#import <QuartzCore/QuartzCore.h>
#import "Report.h"
#import "Insurance.h"
#import "Patient.h"
#import "Exam.h"
#import "Doctor.h"
#import "Clinic.h"
#import "ChiroMaticAppDelegate.h"
#import "ReportPageRenderer.h"

@interface PrintViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property id <PrintViewDatasource> dataSource;
@property (weak,nonatomic) Report* report;
@property (strong,nonatomic) NSSet* printedObjects;

@property (weak,nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *clinicLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceAddress;

@property (weak, nonatomic) IBOutlet UILabel *insuranceContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *repatientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *examNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingSentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *suiteLabel;

- (IBAction)print:(UIButton*)sender;
- (IBAction)pdf:(UIButton*)sender;
- (IBAction)email:(id)sender;

@end
