//
//  UIColor+Fade.h
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/18.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Fade)
+ (UIColor *)moveColor:(UIColor *)color toTargetColor:(UIColor *) targetColor ratio:(CGFloat)ratio;
@end
