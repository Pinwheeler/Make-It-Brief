//
//  ClinicsDoctorsEditViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/21/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ClinicsDoctorsEditViewController.h"

@interface ClinicsDoctorsEditViewController ()
@property (weak, nonatomic) EmbedDoctorViewController* embeddedViewController;
@property (strong, nonatomic) UIPopoverController* popover;

@end

@implementation ClinicsDoctorsEditViewController

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

-(id) specialReturnValue
{
    return self.doctorNameField.text;
}

-(void) populateFieldsWithDataOfObject:(id)object
{
    
    if ([object isKindOfClass:[Clinic class]]) {
        self.embeddedViewController.currentSuperobject = object;
        Clinic* clinic = object;
        [self populate:self.nameField withObjectDataItem:clinic.name assumingDataIsNonNil:YES];
        [self populate:self.websiteField withObjectDataItem:clinic.website assumingDataIsNonNil:NO];
        [self populate:self.phoneField withObjectDataItem:clinic.phone assumingDataIsNonNil:NO];
        [self populate:self.addressField withObjectDataItem:clinic.address assumingDataIsNonNil:NO];
        UIImage* image = [UIImage imageWithData:clinic.logo];
        self.clinicImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.clinicImageView setImage:image];
        [self.changeImageButton setEnabled:YES];
        [self.doctorsSubview setHidden:NO];
        
    }
    
    if ([object isKindOfClass:[Doctor class]]) {
        Doctor* doctor = object;
        [self populate:self.doctorNameField withObjectDataItem:doctor.name assumingDataIsNonNil:YES];
        UIImage* image = [UIImage imageWithData:doctor.signature];
        self.doctorSignatureView.image = image;
    }
    if (!object) {
        //Set all of the values to 0 and make them uneditable
        for (UITextField* textfield in self.view.subviews) {
            if ([textfield respondsToSelector:@selector(text)]) {
                textfield.text = nil;
                [textfield setEnabled:NO];
            }
        }
        [self.doctorsSubview setHidden:YES];
    }
}

-(void) clearTextfieldsAssociatedWithEntityType:(NSString *)type
{
    if ([type isEqualToString:@"Doctor"]) {
        self.doctorNameField.text = @"";
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.doctorNameField) {
        [self.embeddedViewController setDoctorName:textField.text];
    }else{
        [self.delegate updateCurrentEntityWithValue:textField.text forKey:textField.placeholder];
    }
    //[self saveData];
}

/*- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.clinicImageView.image = image;
    NSData* imageData = UIImagePNGRepresentation(image);
    [self.delegate updateCurrentEntityWithValue:imageData forKey:@"logo"];
    [self.popover dismissPopoverAnimated:YES];
}*/

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if (imagePicker == self.imagePicker) {
        self.clinicImageView.image = image;
        NSData* imageData = UIImagePNGRepresentation(image);
        [self.delegate updateCurrentEntityWithValue:imageData forKey:@"logo"];
    }
    if (imagePicker == self.signaturePicker) {
        self.doctorSignatureView.image = image;
        NSData* imageData = UIImagePNGRepresentation(image);
        [self.embeddedViewController setDoctorSignatureData:imageData];
    }
    [self.popover dismissPopoverAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.popover dismissPopoverAnimated:YES];
}

- (IBAction)changeImage:(id)sender {
    self.imagePicker = [[GKImagePicker alloc]init];
    [self.imagePicker setDelegate:self];
    //[self.imagePicker setCropSize:self.clinicImageView.frame.size];
    self.imagePicker.resizeableCropArea = YES;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(350, 500);
    [self.popover presentPopoverFromRect:self.clinicImageView.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)changeDoctorSignature:(id)sender {
    self.signaturePicker = [[GKImagePicker alloc]init];
    [self.signaturePicker setDelegate:self];
    [self.signaturePicker setCropSize:self.doctorSignatureView.frame.size];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.signaturePicker.imagePickerController];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(300, 400);
    [self.popover presentPopoverFromRect:self.clinicImageView.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}
@end
