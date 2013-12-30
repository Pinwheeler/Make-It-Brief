//
//  PrintViewDatasource.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/20/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Report.h"

@protocol PrintViewDatasource <NSObject>

-(Report*) passedData;

@optional
-(UIView*) view;

@end
