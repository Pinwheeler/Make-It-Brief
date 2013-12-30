//
//  DataPopulator.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol DataPopulator <NSObject>

- (void) populateFieldsWithDataOfObject:(id)object;
@property (weak, nonatomic) id delegate;

@optional
- (void) populate:(UITextField*)field withObjectDataItem:(id)item assumingDataIsNonNil:(BOOL) assumption;

@end
