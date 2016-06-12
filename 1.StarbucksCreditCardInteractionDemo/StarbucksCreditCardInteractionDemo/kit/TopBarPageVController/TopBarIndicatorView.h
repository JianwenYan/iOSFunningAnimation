//
//  TopBarIndicatorView.h
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/16.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBarIndicatorView : UIView

typedef NS_ENUM(NSInteger, TopBarIndicatorType) {
    TopBarIndicatorTypeLine = 0,
    TopBarIndicatorTypeTriangle
};

@property (strong, nonatomic) UIColor *color;
@property (nonatomic, assign)TopBarIndicatorType indicatorType;

- (id)initWithFrame:(CGRect)frame indicatorStyle:(TopBarIndicatorType)indicatorType indicatorColor:(UIColor *)color;
@end
