//
//  TotalStringToDateFormatter.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalStringToDateFormatter : NSObject

+(NSDate*) convertString:(NSString*)string;

@end
