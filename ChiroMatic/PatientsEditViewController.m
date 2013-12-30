//
//  PatientsEditViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "PatientsEditViewController.h"
#import "EmbedDoctorViewController.h"

@interface PatientsEditViewController ()
@property (weak, nonatomic) EmbedInsuranceViewController* embeddedViewController;
@property (weak, nonatomic) EmbedDoctorViewController* embeddedDoctorViewController;
@end

@implementation PatientsEditViewController
@synthesize embeddedViewController = _embeddedViewController;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Insurance Table View Controller"])
    {
        self.embeddedViewController = segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:@"Embed Doctor Table View Controller"])
    {
        self.embeddedDoctorViewController = segue.destinationViewController;
    }
}

- (void) populateFieldsWithDataOfObject:(id)object;
{
    if (object) {
        
        [self clearTextfieldsAssociatedWithEntityType:[object class]];
        
        if ([object isKindOfClass:[Patient class]]) {
            Patient* patient = (Patient*)object;
            self.embeddedViewController.currentSuperobject = patient;
            self.embeddedDoctorViewController.currentSuperobject = patient;
            [self populate:self.nameField withObjectDataItem:patient.name assumingDataIsNonNil:YES];
            [self populate:self.fileNumberField withObjectDataItem:patient.fileNumber assumingDataIsNonNil:NO];
            //Convert Date objects to nice date strings if possible
            NSString* injuryDateString;
            NSString* birthDateString;
            if (patient.birthDate || patient.injuryDate) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"mm-dd-yyyy"];
                if (patient.injuryDate)
                    injuryDateString = [formatter stringFromDate:patient.injuryDate];
                if (patient.birthDate)
                    birthDateString = [formatter stringFromDate:patient.birthDate];
            }
            
            [self populate:self.dateOfBirthField withObjectDataItem:birthDateString assumingDataIsNonNil:NO];
            [self populate:self.dateOfInjuryField withObjectDataItem:injuryDateString assumingDataIsNonNil:NO];
            [self populate:self.policyNumberField withObjectDataItem:patient.policyNumber assumingDataIsNonNil:NO];
        }
    }else {//Set all of the values to 0 and make them uneditable
        for (UITextField* textfield in self.view.subviews) {
            if ([textfield respondsToSelector:@selector(text)]) {
                textfield.text = nil;
                [textfield setEnabled:NO];
            }
        }
        /*
        self.nameField.text = nil;
        [self.nameField setEnabled:NO];
        self.fileNumberField.text = nil;
        [self.fileNumberField setEnabled:<#(BOOL)#>]
        self.dateOfBirthField.text = nil;
        self.dateOfInjuryField.text = nil;
        self.policyNumberField.text = nil;
         */
    }
}

- (void) clearTextfieldsAssociatedWithEntityType:(Class)type
{
    if (type == [Patient class]) {
        self.nameField.text = @"";
        self.fileNumberField.text = @"";
        self.dateOfBirthField.text = @"";
        self.dateOfInjuryField.text = @"";
        self.policyNumberField.text = @"";
        
        self.embeddedDoctorViewController.currentObject = nil;
        self.embeddedDoctorViewController.currentObject = nil;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.dateOfBirthField || textField == self.dateOfInjuryField) {
        [self.delegate updateCurrentEntityWithStringToDateValue:textField.text forKey:textField.placeholder];
    }else
    {
        [self.delegate updateCurrentEntityWithValue:textField.text forKey:textField.placeholder];
    }
}


/*-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Print View Controller Segue"]) {
        PrintViewController* printer = segue.destinationViewController;
        printer.dataSource = sender;
        printer.printedObjects = self.passedData;   
        
        CGRect scrollFrame = self.view.frame;
        scrollFrame.size.height -= 200;
        printer.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        printer.scrollView.contentSize = CGSizeMake(scrollFrame.size.width * 2, scrollFrame.size.height * 2);
        [printer.view addSubview:printer.scrollView];
    }
    
        
}
 */
@end
