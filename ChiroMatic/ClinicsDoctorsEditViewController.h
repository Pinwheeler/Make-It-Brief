//
//  ClinicsDoctorsEditViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/21/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EditViewController.h"
#import "EmbedDoctorViewController.h"
#import "GKImagePicker.h"

@interface ClinicsDoctorsEditViewController : EditViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,GKImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameField;
@property (weak, nonatomic) IBOutlet UIImageView *clinicImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;

@property GKImagePicker* imagePicker;
@property GKImagePicker* signaturePicker;
- (IBAction)changeImage:(id)sender;
- (IBAction)changeDoctorSignature:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *doctorSignatureView;

@property (weak, nonatomic) IBOutlet UIView *doctorsSubview;



@end
