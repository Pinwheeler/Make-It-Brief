//
//  CustomPopoverDelegate.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomPopoverDelegate <NSObject>

-(void) dismissPopoverFromSender:(id)sender;

@optional
- (void) modalSender:(id)sender didSelectObject:(id)object;
- (NSMutableArray*) optionsArray;

@end
