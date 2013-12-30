//
//  EditViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize delegate = _delegate;

- (void) clearTextfieldsAssociatedWithEntityType:(NSString *)type
{
    //abstractly defined
}

- (void) populate:(id)text withObjectDataItem:(id)item assumingDataIsNonNil:(BOOL) assumption
{
    if (!assumption) {
        if (!item) {
            //return;
        }
    }
    if ([text isKindOfClass:[UITextField class]])
    {
        UITextField* field = (UITextField*)text;
        [field setEnabled:YES];
        if ([item isKindOfClass:[NSString class]])
        {
            NSString *string = item;
            field.text = string;
        }else if ([item isKindOfClass:[NSDate class]])
        {
            NSDate *date = item;
            field.text = [date description];
        }
    }
    if ([text isKindOfClass:[UILabel class]])
    {
        UILabel* field = (UILabel*)text;
        if ([item isKindOfClass:[NSString class]])
        {
            NSString *string = item;
            field.text = string;
        }else if ([item isKindOfClass:[NSDate class]])
        {
            NSDate *date = item;
            field.text = [date description];
        }
    }
}

- (void) populateFieldsWithDataOfObject:(id)object
{
    //abstractly defined. This must be overriden in any subclasses
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate updateCurrentEntityWithValue:textField.text forKey:textField.placeholder];
    [self saveData];
}

- (void) saveData
{
    ChiroMaticAppDelegate* sharedDelegate = [[UIApplication sharedApplication]delegate];
    [sharedDelegate saveContext];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self saveData];
}

@end
