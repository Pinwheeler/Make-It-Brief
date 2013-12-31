//
//  ExamsEditViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ExamsEditViewController.h"
#import "EmbedPatientsViewController.h"

@interface ExamsEditViewController ()
@property (weak,nonatomic) Exam* currentExam;
@property (strong,nonatomic) NSDictionary* currentExamDictionary;
@property (strong,nonatomic) NSArray* currentExamArray;
@property (strong,nonatomic) NSNumber* topPickerFinalCategoryIndex;
@property (weak,nonatomic) EmbedPatientsViewController* embeddedViewController;

@end

@implementation ExamsEditViewController

-(id) init
{
    self = [super init];
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Patients Table View Controller"])
    {
        self.embeddedViewController = segue.destinationViewController;
    }
}

-(void)populateFieldsWithDataOfObject:(id)object
{
    self.previewSentenceLabel.text = @"Preview Sentence";
    self.topPickerFinalCategoryIndex = 0;
    self.bottomPicker.hidden = YES;
    //This needs to happen AFTER the exam is named
    if ([object isKindOfClass:[Exam class]]) {
        self.currentExam = (Exam*)object;
        self.embeddedViewController.currentSuperobject = self.currentExam;
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ExamProperties" ofType:@"plist"];
        NSDictionary* examsDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        self.currentExamDictionary = [examsDict objectForKey:self.currentExam.name];
        self.currentExamArray = [self.currentExamDictionary objectForKey:@"categories"];
        self.topPickerFinalCategoryIndex = [NSNumber numberWithInt:[self.currentExamArray count]];
        
        //Show/Hide only the necessary picker views based on how wide the columns will be
        float totalRealEstate = 0;
        for (int i = 0; i < [self.currentExamArray count]; i++) {
            NSDictionary* dict = [self.currentExamArray objectAtIndex:i];
            totalRealEstate += [[dict objectForKey:@"width"]floatValue];
            if (totalRealEstate > self.topPicker.frame.size.width) {
                self.bottomPicker.hidden = NO;
                self.topPickerFinalCategoryIndex = [NSNumber numberWithInt:i];
                i = [self.currentExamArray count] + 1;
            }
        }
    }
    self.topPicker.delegate = nil;
    self.topPicker.delegate = self;
    self.bottomPicker.delegate = nil;
    self.bottomPicker.delegate = self;
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

-(NSInteger)convertInteger:(int)integer BasedOnPickerView:(UIPickerView*)pickerView
{
    if (pickerView == self.topPicker) {
        return integer;
    }else
    {
        return self.topPickerFinalCategoryIndex.integerValue + integer;
    }
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.currentExam) {
        NSDictionary* dict = [self.currentExamArray objectAtIndex:[self convertInteger:component BasedOnPickerView:pickerView]];
        return [[dict objectForKey:@"width"]floatValue];
    }
    return pickerView.frame.size.width;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.currentExam) {
        NSDictionary* dict = [self.currentExamArray objectAtIndex:[self convertInteger:component BasedOnPickerView:pickerView]];
        NSArray* specificArray = [dict objectForKey:@"possibleValues"];
        return [specificArray objectAtIndex:row];
    }
    return @"";
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.currentExam) {
        NSDictionary* dict = [self.currentExamArray objectAtIndex:[self convertInteger:component BasedOnPickerView:pickerView]];
        NSArray* specificArray = [dict objectForKey:@"possibleValues"];
        return [specificArray count];
    }
    return 1;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.currentExam) {
        if (pickerView == self.topPicker) {
            return [self.topPickerFinalCategoryIndex integerValue];
        }else
        {
            int retint = [self.currentExamArray count] - [self.topPickerFinalCategoryIndex integerValue];
            return retint;
        }
    }
    return 1;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Create the result string based on the pickerView selections
    // Results string will be a composition of several prefix-value-suffix trios
    //This is if the topPicker isn't even being used
    NSString* resultsString = @"";
    for (int i = 0; i < [self.currentExamArray count]; i++) {
        NSDictionary* dict = [self.currentExamArray objectAtIndex:i];
        NSString* prefixString = [dict objectForKey:@"prefix"];
        int arrayIndex = [pickerView selectedRowInComponent:i];
        NSArray* array = [dict objectForKey:@"possibleValues"];
        NSString* componentString = [array objectAtIndex:arrayIndex];
        NSString* suffixString = [dict objectForKey:@"suffix"];
        if ([componentString isEqualToString:@""]) {
            prefixString = @"";
            suffixString = @"";
        }
        resultsString = [resultsString stringByAppendingFormat:@"%@%@%@",prefixString,componentString,suffixString];
    }

    self.currentExam.result = resultsString;
    self.previewSentenceLabel.text = resultsString;
    //NSLog(@"%@",self.currentExam.result);
}

@end
