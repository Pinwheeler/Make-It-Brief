//
//  Clinic.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doctor, Report;

@interface Clinic : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *doctors;
@property (nonatomic, retain) NSSet *reports;
@end

@interface Clinic (CoreDataGeneratedAccessors)

- (void)addDoctorsObject:(Doctor *)value;
- (void)removeDoctorsObject:(Doctor *)value;
- (void)addDoctors:(NSSet *)values;
- (void)removeDoctors:(NSSet *)values;

- (void)addReportsObject:(Report *)value;
- (void)removeReportsObject:(Report *)value;
- (void)addReports:(NSSet *)values;
- (void)removeReports:(NSSet *)values;

@end
