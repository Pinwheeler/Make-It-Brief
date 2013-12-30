//
//  InsuranceEditViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/22/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "InsuranceEditViewController.h"

@interface InsuranceEditViewController ()
@property (weak, nonatomic) EmbedDoctorViewController* embeddedViewController;
@end

@implementation InsuranceEditViewController

@synthesize embeddedViewController = _embeddedViewController;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Doctor Table View Controller"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* nav = segue.destinationViewController;
            self.embeddedViewController = nav.viewControllers.lastObject;
            self.embeddedViewController.delegate = self;
        }
    }
}


-(void) populateFieldsWithDataOfObject:(id)object
{
    
    [self clearTextfieldsAssociatedWithEntityType:[object class]];
    
    if ([object isKindOfClass:[Insurance class]]) {
        self.embeddedViewController.currentSuperobject = object;
        Insurance* insurance = object;
        [self populate:self.nameField withObjectDataItem:insurance.name assumingDataIsNonNil:YES];
        [self populate:self.contactField withObjectDataItem:insurance.contact assumingDataIsNonNil:NO];
        [self populate:self.phoneField withObjectDataItem:insurance.phone assumingDataIsNonNil:NO];
        [self populate:self.addressField withObjectDataItem:insurance.address assumingDataIsNonNil:NO];
        [self populate:self.cityField withObjectDataItem:insurance.city assumingDataIsNonNil:NO];
        [self populate:self.stateField withObjectDataItem:insurance.state assumingDataIsNonNil:NO];
        [self populate:self.zipField withObjectDataItem:insurance.zip assumingDataIsNonNil:NO];
        [self populate:self.suiteField withObjectDataItem:insurance.suiteNumber assumingDataIsNonNil:NO];
    }
    if (!object) {
        //Set all of the values to 0 and make them uneditable
        for (UITextField* textfield in self.view.subviews) {
            if ([textfield respondsToSelector:@selector(text)]) {
                textfield.text = nil;
                [textfield setEnabled:NO];
            }
        }
    }
    
}

- (void) clearTextfieldsAssociatedWithEntityType:(Class)type
{
    if (type == [Insurance class]) {
        self.nameField.text = @"";
        self.contactField.text = @"";
        self.phoneField.text = @"";
        self.addressField.text = @"";
        self.cityField.text = @"";
        self.stateField.text = @"";
        self.zipField.text = @"";
        self.suiteField.text = @"";
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate updateCurrentEntityWithValue:textField.text forKey:textField.placeholder];
}
@end
