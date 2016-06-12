//
//  TopBarIndicatorView.m
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/16.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import "TopBarIndicatorView.h"

@interface TopBarIndicatorView()

@end

@implementation TopBarIndicatorView

- (id)initWithFrame:(CGRect)frame indicatorStyle:(TopBarIndicatorType)indicatorType indicatorColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.indicatorType = indicatorType;
        self.color = color;
        if (indicatorType == TopBarIndicatorTypeLine) {
            
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.indicatorType == TopBarIndicatorTypeTriangle) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextClearRect(context, rect);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextClosePath(context);
        
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillPath(context);
    } else {
        [super drawRect:rect];
    }
}

- (void)setColor:(UIColor *)color {
    [self setBackgroundColor:color];
}

@end
