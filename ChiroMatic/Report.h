//
//  Report.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, Doctor, Exam, Insurance, Patient;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * prognosis;
@property (nonatomic, retain) Clinic *clinic;
@property (nonatomic, retain) Doctor *doctor;
@property (nonatomic, retain) NSSet *exams;
@property (nonatomic, retain) Insurance *insuranceBilled;
@property (nonatomic, retain) Patient *patient;
@end

@interface Report (CoreDataGeneratedAccessors)

- (void)addExamsObject:(Exam *)value;
- (void)removeExamsObject:(Exam *)value;
- (void)addExams:(NSSet *)values;
- (void)removeExams:(NSSet *)values;

@end
