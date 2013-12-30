//
//  ReportPageRenderer.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/25/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ReportPageRenderer.h"

@implementation ReportPageRenderer

- (void)setHeaderText:(NSString *)newString {
    
    if (_headerText != newString) {
        _headerText = [newString copy];
        
        
        if (_headerText) {
            UIFont *font = [UIFont fontWithName:@"Helvetica"
                                           size:HEADER_FONT_SIZE];
            CGSize size = [_headerText sizeWithFont:font];
            self.headerHeight = size.height +
            HEADER_TOP_PADDING +
            HEADER_BOTTOM_PADDING;
        }
    }
}

- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex
                          inRect:(CGRect)headerRect {
    
    if (self.headerText) {
        UIFont *font = [UIFont fontWithName:@"Helvetica"
                                       size:HEADER_FONT_SIZE];
        CGSize size = [self.headerText sizeWithFont:font];
        
        // Center Text
        CGFloat drawX = CGRectGetMaxX(headerRect)/2 - size.width/2;
        CGFloat drawY = CGRectGetMaxY(headerRect) - size.height -
        HEADER_BOTTOM_PADDING;
        CGPoint drawPoint = CGPointMake(drawX, drawY);
        [self.headerText drawAtPoint:drawPoint withFont:font];
    }
}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex
                          inRect:(CGRect)footerRect {
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:FOOTER_FONT_SIZE];
    NSString *pageNumber = [NSString stringWithFormat:@"- %d -", pageIndex+1];
    CGSize size = [pageNumber sizeWithFont:font];
    CGFloat drawX = CGRectGetMaxX(footerRect)/2 - size.width/2;
    CGFloat drawY = CGRectGetMaxY(footerRect) - size.height -
    FOOTER_BOTTOM_PADDING;
    CGPoint drawPoint = CGPointMake(drawX, drawY);
    [pageNumber drawAtPoint:drawPoint withFont:font];
    
    
    if (self.footerText) {
        size = [self.footerText sizeWithFont:font];
        drawX = CGRectGetMaxX(footerRect) - size.width - FOOTER_RIGHT_PADDING;
        drawPoint = CGPointMake(drawX, drawY);
        [self.footerText drawAtPoint:drawPoint withFont:font];
    }
}

@end
