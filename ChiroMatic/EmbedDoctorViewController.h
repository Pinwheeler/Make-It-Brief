//
//  EmbedDoctorViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/21/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorViewController.h"
#import "Clinic.h"
#import "EditViewController.h"
#import "ClinicsDoctorsEditViewController.h"
#import "Insurance.h"
#import "Patient.h"

@interface EmbedDoctorViewController : DoctorViewController <UIPopoverControllerDelegate>

@property (weak, nonatomic) NSManagedObject* currentSuperobject;
@property (weak, nonatomic) EditViewController* delegate;

-(void) setDoctorName:(NSString*)name;
-(void) setDoctorSignatureData:(NSData*)data;

@end
