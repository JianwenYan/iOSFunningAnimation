//
//  TopBarView+ExpandItem.m
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/28.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import "TopBarView+ExpandItem.h"
#import <Masonry.h>

@implementation TopBarView(ExpandItem)

/**
 *  配置ExpandItem
 */
- (void)configureExpandItem {
    
    
    
    if (self.isUseRightExpandItem) {
        [self configureRightExpanItem];
       
    }
    
    if (self.isUseLeftExpandItem) {
        [self configureLeftExpandItem];
    }
    
    [self autoLayoutItem];
    
}

- (void)configureRightExpanItem {
   
    CGFloat itemWidth = CGRectGetHeight(self.frame) - CGRectGetHeight(self.indicatorView.frame);

    CGFloat rightItemX = CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame);
    CGRect rightItemFrame =  CGRectMake(rightItemX, 0, itemWidth, itemWidth);
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = rightItemFrame;
    [rightItem setTintColor:self.itemSelectedColor];
    [rightItem setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    UIImage *imageNormal = [[UIImage imageNamed:@"arrow-down" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *imageSelected = [[UIImage imageNamed:@"arrow-up" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [rightItem setImage:imageNormal forState:UIControlStateNormal];
    [rightItem setImage:imageSelected forState:UIControlStateSelected];
    [rightItem addTarget:self action:@selector(selectRightItem:) forControlEvents:UIControlEventTouchUpInside];
    rightItem.selected = NO;
    [self addSubview:rightItem];

    //AutoLayout
    [rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(itemWidth);
        make.width.mas_equalTo(itemWidth);
     }];
}

- (void)configureLeftExpandItem {
    
    CGFloat itemWidth = CGRectGetHeight(self.frame) - CGRectGetHeight(self.indicatorView.frame);
    CGRect leftItemFrame =  CGRectMake(0, 0, itemWidth, itemWidth);
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    leftItem.frame = leftItemFrame;
    [leftItem setTintColor:self.itemSelectedColor];
    [leftItem setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [leftItem setImage:backImage forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(selectLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    leftItem.selected = NO;
    [self addSubview:leftItem];
    //self.leftItem = leftItem;
}

- (void)autoLayoutItem {
    
    if (self.isUseRightExpandItem) {
      /*  [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
       //     make.right.equalTo(self.mas_right);
        }];*/
        
    }
    
    if (self.isUseLeftExpandItem) {
        
    }

}

- (void)selectRightItem:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarView:didSelectRightExpandItem:)]) {
        [self.delegate topBarView:self didSelectRightExpandItem:button];
    }
    
}

- (void)selectLeftItem:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarView:didSelectLeftExpandItem:)]) {
        [self.delegate topBarView:self didSelectLeftExpandItem:button];
    }
    
}


@end
