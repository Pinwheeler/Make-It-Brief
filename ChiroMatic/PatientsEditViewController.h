//
//  PatientsEditViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Patient.h"
#import "EditViewController.h"
#import "PrintViewDatasource.h"
#import "PrintViewController.h"
#import "EmbedInsuranceViewController.h"

@interface PatientsEditViewController : EditViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *fileNumberField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfInjuryField;
@property (weak, nonatomic) IBOutlet UITextField *policyNumberField;


@end
