//
//  ReportBuilderViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/24/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ReportBuilderViewController.h"
#import "ChiroMaticSplashViewController.h"
#import "TotalStringToDateFormatter.h"

@interface ReportBuilderViewController ()
@property (weak, nonatomic) ExamsViewController* embeddedViewController;
@property (strong, nonatomic) Report* report;
@property (weak,nonatomic) UITextField* currentTextField;
@property (strong, nonatomic) NSString* currentKey;
@property (strong, nonatomic) NSMutableArray* optionsArray;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) ReportModalTableViewController* rMTVC;
@property (nonatomic) BOOL actionEnabled;
@property (nonatomic) BOOL prognosisEnabled;

@end

@implementation ReportBuilderViewController

@synthesize embeddedViewController = _embeddedViewController;
@synthesize report = _report;

-(id) passedData
{
    return self.report;
}

- (BOOL) checkIfAllRequiredFieldsHaveBeenFilledInView:(UIView*)view {
    BOOL truth = YES;
    for (UIView* iView in view.subviews) {
        truth = [self checkIfAllRequiredFieldsHaveBeenFilledInView:iView];
        if ([iView isKindOfClass:[UITextField class]]) {
            UITextField* textField = (UITextField*) iView;
            if ((!textField.text) || ([textField.text isEqualToString:@""])) {
        
                if (textField == self.dateField) {
                    continue;
                }
                if (textField == self.actionLabelDuration || textField == self.actionLabelPurpose || textField == self.actionLabelTreatment) {
                    if (!self.actionEnabled) {
                        continue;
                    }
                }
                if (textField == self.prognosisLabelExpectation || textField == self.prognosisLabelFollowup){
                    if (!self.prognosisEnabled) {
                        continue;
                    }
                }
                if (textField == self.examNameField) {
                    continue;
                }
                if (textField == self.reportNameField) {
                    continue;
                }
                if (textField == self.resultField) {
                    continue;
                }
                    [self createErrorPopupAtView:textField inView:textField.superview];
                    return NO;
            }
        }
    }
    return truth;
}

- (void) createErrorPopupAtView:(UIView*)targetView inView:(UIView*)parentView{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"RequiredPopover"];
    self.popover = [[UIPopoverController alloc]initWithContentViewController:vc];
    [self.popover presentPopoverFromRect:targetView.frame inView:parentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)generateReport:(id)sender {
    if (self.report.patient) {
        if (self.report.exams && [self.report.exams count]) {
            if ([self checkIfAllRequiredFieldsHaveBeenFilledInView:self.view]) {
                if (!self.dateField.text || ([self.dateField.text isEqualToString:@""])) {
                    self.report.date = [NSDate date];
                }
                if (!self.reportNameField.text || ([self.reportNameField.text isEqualToString:@""])) {
                    self.report.name = @"Exam";
                }
                [self.embeddedViewController saveData];
                self.report.insuranceBilled = self.report.patient.insurance;
                //[self performSegueWithIdentifier:@"Print View Controller Segue" sender:self];
                UINavigationController* nc = self.splitViewController.viewControllers.lastObject;
                ChiroMaticSplashViewController *vc = [nc.viewControllers objectAtIndex:0];
                id lvc = self.splitViewController.viewControllers.lastObject;
                if ([lvc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController* lnc = lvc;
                    [lnc popToRootViewControllerAnimated:NO];
                }
                
                // Set the Action and Prognosis of the SOAP report
                // If one or more of the components are missing, do not generate report
                if (self.actionEnabled){
                    NSString* actionString = [NSString stringWithFormat:@"The treatment will consist of %@ lasting %@ this treatment has been prescribed to %@",self.actionLabelTreatment.text,self.actionLabelDuration.text,self.actionLabelPurpose.text];
                    NSError *error = NULL;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.$" options:0 error:&error];
                    NSArray* matches = [regex matchesInString:actionString options:0 range:NSMakeRange(0, [actionString length])];
                    if (!matches || ![matches count]) {
                        actionString = [actionString stringByAppendingString:@"."];
                    }
                    self.report.action = actionString;
                }
                if (self.prognosisEnabled) {
                    NSString* prognosisString = [NSString stringWithFormat:@"I expect %@ and suggest the patient follow up with you in %@",self.prognosisLabelExpectation.text,self.prognosisLabelFollowup.text];
                    NSError *error = NULL;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.$" options:0 error:&error];
                    NSArray* matches = [regex matchesInString:prognosisString options:0 range:NSMakeRange(0, [prognosisString length])];
                    if (!matches || ![matches count]) {
                        prognosisString = [prognosisString stringByAppendingString:@"."];
                    }
                    self.report.prognosis = prognosisString;
                }
                
                vc.passedObject = self.report;
                [vc performSegueWithIdentifier:@"Print View Controller Segue" sender:vc];
            }
        } else
        {
            [self createErrorPopupAtView:self.findingsTable inView:self.findingsTable.superview];
        }
    }
    else
    {
        [self createErrorPopupAtView:self.patientTableViewWindow inView:self.patientTableViewWindow.superview];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Exams Table View Controller"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* nav = segue.destinationViewController;
            self.embeddedViewController = nav.viewControllers.lastObject;
            self.embeddedViewController.delegate = self;
        }
    }
    if ([segue.identifier isEqualToString:@"Print View Controller Segue"])
    {
        PrintViewController* pvc = segue.destinationViewController;
        pvc.report = self.report;
        pvc.dataSource = self;
    }
    for (int i = 1; i < 6; i++) {
        if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"modalPopover%d",i]]) {
            ReportModalTableViewController* rMTVC = (ReportModalTableViewController*) segue.destinationViewController;
            rMTVC.tableOptions = [NSArray arrayWithArray:self.optionsArray];
        }
    }
    
}

-(id) specialReturnValue
{
    return self.examNameField.text;
}

-(void) viewDidLoad{
    ChiroMaticAppDelegate* sharedDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* sharedContext = sharedDelegate.managedObjectContext;
    NSEntityDescription* newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Report" inManagedObjectContext:sharedContext];
    self.report = (Report*)newObject;
    self.embeddedViewController.currentReport = self.report;
    self.actionEnabled = YES;
    self.prognosisEnabled = YES;
}


-(void) populateFieldsWithDataOfObject:(id)object
{
    
    if ([object isKindOfClass:[Patient class]]) {
        Patient* patient = object;
        self.embeddedViewController.currentSuperobject = patient;
        self.report.patient = patient;
        //[self populate:self.insuranceField withObjectDataItem:patient.insurance.name assumingDataIsNonNil:NO];
        self.insuranceField.text = patient.insurance.name;
        //[self populate:self.policyNumberField withObjectDataItem:patient.policyNumber assumingDataIsNonNil:NO];
        self.policyNumberField.text = patient.policyNumber;
        //[self populate:self.contactField withObjectDataItem:patient.insurance.contact assumingDataIsNonNil:NO];
        self.contactField.text = patient.insurance.contact;
        [self.findingsTable setHidden:NO];
    }
    if ([object isKindOfClass:[Exam class]]) {
        Exam* exam = object;
        [self populate:self.examNameField withObjectDataItem:exam.name assumingDataIsNonNil:NO];
        NSLog(@"%@",exam.result);
        [self populate:self.resultField withObjectDataItem:exam.result assumingDataIsNonNil:NO];
    }
    if (!object) {
        self.examNameField.text = @"";
        [self.examNameField setEnabled:NO];
        self.resultField.text = @"";
        [self.resultField setEnabled:NO];
    }
}

-(void) modalSender:(id)sender didSelectObject:(id)object
{
    if ([sender isKindOfClass:[ReportModalTableViewController class]]) {
        //ReportModalTableViewController* rMTVC = (ReportModalTableViewController*) sender;
        NSString* modalString = (NSString*) object;
        self.currentTextField.text = modalString;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (self.embeddedViewController.currentlySelectedExam)
    {
        Exam* exam = self.embeddedViewController.currentlySelectedExam;
        if (textField == self.examNameField)
        {
            exam.name = textField.text;
            
            // Error Handling
            if (!exam.name || [exam.name isEqualToString:@""]) {
                exam.name = @"Miscellaneous Exam";
            }
        }
        if (textField == self.resultField){
            exam.result = textField.text;
            
            // Error Handling
            if (!textField.text || [textField.text isEqualToString:@""]) {
                exam.result = @"No Result";
            }
        }
    }
    if (textField == self.dateField) {
        //self.report.date = self.dateField.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        self.report.date = [TotalStringToDateFormatter convertString:self.dateField.text];
    }
    if (textField == self.reportNameField){
        self.report.name = self.reportNameField.text;
    }
    if (textField == self.actionLabelDuration || textField == self.actionLabelPurpose || textField == self.actionLabelTreatment || textField == self.prognosisLabelExpectation || textField == self.prognosisLabelFollowup)
    {
        switch (textField.tag) {
            case 1:
                self.currentKey = @"treatment";
                break;
            case 2:
                self.currentKey = @"duration";
                break;
            case 3:
                self.currentKey = @"purpose";
                break;
            case 4:
                self.currentKey = @"expectation";
                break;
            case 5:
                self.currentKey = @"followup";
                break;
                
            default:
                break;
        }
        
        [self addString:textField.text toUserDefaultsInCurrentGroupForKey:self.currentKey];
    }
    
}

- (void) addString:(NSString*)string toUserDefaultsInCurrentGroupForKey:(NSString*)key
{
    NSUserDefaults* sharedDefaults = [NSUserDefaults standardUserDefaults];
    self.optionsArray = [[sharedDefaults arrayForKey:key]mutableCopy];
    int maxOptions;
    NSMutableArray* group;
    if ([self optionsArray])
        group = self.optionsArray;
    else
        group = [NSMutableArray arrayWithCapacity:0];
    if ([sharedDefaults integerForKey:@"maxOptions"])
        maxOptions = [sharedDefaults integerForKey:@"maxOptions"];
    else
        maxOptions = 5;
    if ([group count] >= maxOptions) {
        [group removeObjectAtIndex:1];
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:group];
        group = newArray;
    }else
        [group addObject:string];
    NSArray* userArray = [NSArray arrayWithArray:group];
    [sharedDefaults setObject:userArray forKey:key];
}

- (void) beginModalPopover
{
    self.optionsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:self.currentKey]];
    if ([self.optionsArray count]) {
        self.rMTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Popup View Controller"];
        [self.rMTVC setDelegate:self];
        [self.rMTVC setTableOptions:self.optionsArray];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:self.rMTVC];
        self.popover.delegate = self;
        self.popover.popoverContentSize = CGSizeMake(350, 250);
        [self.popover presentPopoverFromRect:self.currentTextField.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void) dismissPopoverFromSender:(id)sender
{
    [self.popover dismissPopoverAnimated:YES];
}

- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (IBAction)treatmentModalPopover:(UIButton *)sender {
    self.currentKey = @"treatment";
    self.currentTextField = self.actionLabelTreatment;
    [self beginModalPopover];
}

- (IBAction)durationModalPopover:(UIButton *)sender {
    self.currentKey = @"duration";
    self.currentTextField = self.actionLabelDuration;
    [self beginModalPopover];
}

- (IBAction)purposeModalPopover:(UIButton *)sender {
    self.currentKey = @"purpose";
    self.currentTextField = self.actionLabelPurpose;
    [self beginModalPopover];
}

- (IBAction)expectationModalPopover:(UIButton *)sender {
    self.currentKey = @"expectation";
    self.currentTextField = self.prognosisLabelExpectation;
    [self beginModalPopover];
}

- (IBAction)followupModalPopover:(UIButton *)sender {
    self.currentKey = @"followup";
    self.currentTextField = self.prognosisLabelFollowup;
    [self beginModalPopover];
}

- (IBAction)actionStateChanged:(UISwitch *)sender {
    self.actionEnabled = sender.state;
}

- (IBAction)prognosisStateChanged:(UISwitch *)sender {
    self.prognosisEnabled = sender.state;
}
@end
