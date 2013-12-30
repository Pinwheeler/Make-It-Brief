//
//  ReportPageRenderer.h
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/25/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEADER_FONT_SIZE 14
#define HEADER_TOP_PADDING 5
#define HEADER_BOTTOM_PADDING 10
#define HEADER_RIGHT_PADDING 5
#define HEADER_LEFT_PADDING 5

#define FOOTER_FONT_SIZE 12
#define FOOTER_TOP_PADDING 10
#define FOOTER_BOTTOM_PADDING 5
#define FOOTER_RIGHT_PADDING 5
#define FOOTER_LEFT_PADDING 5

@interface ReportPageRenderer : UIPrintPageRenderer

@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *footerText;

@end
