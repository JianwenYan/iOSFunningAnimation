//
//  UIColor+Fade.m
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/18.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import "UIColor+Fade.h"

@implementation UIColor(Fade)
/**
 *  Color fade base on HSB
 *
 *  @param color       current color
 *  @param targetColor target color
 *  @param ratio
 *
 *  @return ratio color
 */
+ (UIColor *)moveColor:(UIColor *)color toTargetColor:(UIColor *) targetColor ratio:(CGFloat)ratio {
    
    CGFloat currentColorHue;
    CGFloat currentColorSta;
    CGFloat currentColorBri;
    
    CGFloat targetColorHue;
    CGFloat targetColorSta;
    CGFloat targetColorBri;
    
    CGFloat ratioColorHue;
    CGFloat ratioColorSta;
    CGFloat ratioColorBri;
    
    [color getHue:&currentColorHue saturation:&currentColorSta brightness:&currentColorBri alpha:nil];
    [targetColor getHue:&targetColorHue saturation:&targetColorSta brightness:&targetColorBri alpha:nil];
    
    ratioColorHue = currentColorHue-(currentColorHue-targetColorHue)*(ratio > 1 ? 1: ratio);
    ratioColorSta = currentColorSta-(currentColorSta-targetColorSta)*(ratio > 1 ? 1: ratio);
    ratioColorBri = currentColorBri-(currentColorBri-targetColorBri)*(ratio > 1 ? 1: ratio);
    
    UIColor *ratioColor = [[UIColor alloc]initWithHue:ratioColorHue saturation:ratioColorSta brightness:ratioColorBri alpha:1.0];
    return ratioColor;
    
}
@end
