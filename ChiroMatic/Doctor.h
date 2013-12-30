//
//  Doctor.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, Insurance, Patient, Report;

@interface Doctor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * signature;
@property (nonatomic, retain) Clinic *clinic;
@property (nonatomic, retain) NSSet *insurances;
@property (nonatomic, retain) NSSet *patients;
@property (nonatomic, retain) NSSet *reports;
@end

@interface Doctor (CoreDataGeneratedAccessors)

- (void)addInsurancesObject:(Insurance *)value;
- (void)removeInsurancesObject:(Insurance *)value;
- (void)addInsurances:(NSSet *)values;
- (void)removeInsurances:(NSSet *)values;

- (void)addPatientsObject:(Patient *)value;
- (void)removePatientsObject:(Patient *)value;
- (void)addPatients:(NSSet *)values;
- (void)removePatients:(NSSet *)values;

- (void)addReportsObject:(Report *)value;
- (void)removeReportsObject:(Report *)value;
- (void)addReports:(NSSet *)values;
- (void)removeReports:(NSSet *)values;

@end
