//
//  Insurance.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doctor, Patient, Report;

@interface Insurance : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * suiteNumber;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *doctors;
@property (nonatomic, retain) NSSet *patients;
@property (nonatomic, retain) NSSet *reportsFiled;
@end

@interface Insurance (CoreDataGeneratedAccessors)

- (void)addDoctorsObject:(Doctor *)value;
- (void)removeDoctorsObject:(Doctor *)value;
- (void)addDoctors:(NSSet *)values;
- (void)removeDoctors:(NSSet *)values;

- (void)addPatientsObject:(Patient *)value;
- (void)removePatientsObject:(Patient *)value;
- (void)addPatients:(NSSet *)values;
- (void)removePatients:(NSSet *)values;

- (void)addReportsFiledObject:(Report *)value;
- (void)removeReportsFiledObject:(Report *)value;
- (void)addReportsFiled:(NSSet *)values;
- (void)removeReportsFiled:(NSSet *)values;

@end
