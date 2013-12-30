//
//  Report.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, Doctor, Exam, Insurance, Patient;

@interface UnmanagedReport : NSObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Insurance *insuranceBilled;
@property (nonatomic, retain) Clinic *clinic;
@property (nonatomic, retain) Doctor *doctor;
@property (nonatomic, retain) Patient *patient;
@property (nonatomic, retain) NSSet *exams;
@end

@interface UnmanagedReport (CoreDataGeneratedAccessors)

- (void)addExamsObject:(Exam *)value;
- (void)removeExamsObject:(Exam *)value;
- (void)addExams:(NSSet *)values;
- (void)removeExams:(NSSet *)values;

@end
