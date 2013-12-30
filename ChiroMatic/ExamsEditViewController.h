//
//  ExamsEditViewController.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EditViewController.h"
#import "Exam+ValueColumns.h"

@interface ExamsEditViewController : EditViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *topPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *bottomPicker;
@property (weak, nonatomic) IBOutlet UILabel *previewSentenceLabel;


@end
