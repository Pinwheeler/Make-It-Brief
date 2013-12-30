//
//  DataManager.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataManager <NSObject>

// Pass the most recently updated text field and ask the delegate to save that data to the managed object context
- (void) updateCurrentEntityWithValue:(id)value forKey:(NSString*)key;
- (void) updateCurrentEntityWithStringToDateValue:(NSString*)value forKey:(NSString *)key;

@end
