//
//  TopBarView.h
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/3.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarIndicatorView.h"

@class TopBarView;

@protocol TopBarDelegate <NSObject>

@optional
- (void)topBarView:(TopBarView *)topBarView didSelectItemAtIndex:(NSUInteger)index oldIndex:(NSUInteger)oldIndex;
- (void)topBarView:(TopBarView *)topBarView didSelectLeftExpandItem:(UIButton *)leftExpandItem;
- (void)topBarView:(TopBarView *)topBarView didSelectRightExpandItem:(UIButton *)rightExpandItem;
@end

@interface TopBarView : UIView

@property (weak, nonatomic) id<TopBarDelegate> delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) TopBarIndicatorView *indicatorView;
@property (nonatomic, strong, readonly) NSArray<UIButton *> *itemViewArray;
@property (nonatomic, assign, readonly) NSInteger itemCount;

@property (nonatomic, assign) BOOL isUseRightExpandItem;
@property (nonatomic, assign) BOOL isUseLeftExpandItem;
@property (nonatomic, strong, readwrite) UIFont *itemFont;
@property (nonatomic, strong, readwrite) UIColor *itemNormalColor;
@property (nonatomic, strong, readwrite) UIColor *itemSelectedColor;
@property (nonatomic, assign, readwrite) TopBarIndicatorType topBarIndicatorType;

- (instancetype)initWithFrame:(CGRect)frame itemTitleArray:(NSArray *)itemTitleArray maxItemCountOnShow:(NSUInteger)maxItemCountOnShow;

/**
 *  caculator top bar offset for item index
 *
 *  @param index item index
 *
 *  @return (CGPoint *)
 */
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;
- (void)moveOldItem:(NSUInteger)oldIndex toSelectedItem:(NSInteger) selectedIndex;
- (void)moveToSelectedItem:(NSInteger) selectedIndex;
- (void)updateLayout:(NSInteger) index ;

@end


