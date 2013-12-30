//
//  Patient.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doctor, Exam, Insurance, Report;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * fileNumber;
@property (nonatomic, retain) NSDate * injuryDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) Doctor *doctor;
@property (nonatomic, retain) NSSet *exams;
@property (nonatomic, retain) Insurance *insurance;
@property (nonatomic, retain) NSSet *report;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addExamsObject:(Exam *)value;
- (void)removeExamsObject:(Exam *)value;
- (void)addExams:(NSSet *)values;
- (void)removeExams:(NSSet *)values;

- (void)addReportObject:(Report *)value;
- (void)removeReportObject:(Report *)value;
- (void)addReport:(NSSet *)values;
- (void)removeReport:(NSSet *)values;

@end
