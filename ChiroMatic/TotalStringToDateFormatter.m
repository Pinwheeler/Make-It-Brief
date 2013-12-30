//
//  TotalStringToDateFormatter.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/29/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "TotalStringToDateFormatter.h"

@implementation TotalStringToDateFormatter

+(NSDate*) convertString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDate* date;
    NSString* checkString;
    
    
    [dateFormatter setDateFormat:@"mm/dd/yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    [dateFormatter setDateFormat:@"mm-dd-yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    [dateFormatter setDateFormat:@"m/d/yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    [dateFormatter setDateFormat:@"m-d-yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    [dateFormatter setDateFormat:@"m/d/yy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    [dateFormatter setDateFormat:@"m-d-yy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    [dateFormatter setDateFormat:@"mm/d/yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    [dateFormatter setDateFormat:@"mm-d-yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    [dateFormatter setDateFormat:@"m/dd/yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    [dateFormatter setDateFormat:@"m-dd-yyyy"];
    date = [dateFormatter dateFromString:string];
    checkString = [dateFormatter stringFromDate:date];
    if ([string isEqualToString:checkString]) {
        return date;
    }
    
    
    return nil;
}

@end
