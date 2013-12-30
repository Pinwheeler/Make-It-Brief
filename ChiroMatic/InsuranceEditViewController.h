//
//  InsuranceEditViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/22/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EditViewController.h"
#import "EmbedDoctorViewController.h"
#import "Insurance.h"

@interface InsuranceEditViewController : EditViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *suiteField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;

@end
