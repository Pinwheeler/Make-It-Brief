//
//  PrintContentViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *clinicLogoLabel;  // I'd suggest renaming this to just clinicLogo
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceAddress;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *insuranceContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *repatientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *examNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingSentenceLabel;
@end
