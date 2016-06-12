//
//  YanBannerView.h
//  YanBannerViewDemo
//
//  Created by 颜建文 on 16/1/6.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YanBannerViewCell.h"

@class YanBannerView;

@protocol YanBannerViewDelegate <NSObject>

@required
- (NSUInteger)numberOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView;
- (YanBannerViewCell *)yanBannerView:(YanBannerView *)yanBannerView cellForIndex:(NSInteger)index;

@optional
- (CGFloat)widthOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView;
- (CGFloat)offsetOfPageControl:(YanBannerView *)yanBannerView;

@end

@interface YanBannerView : UIView

@property (nonatomic, weak) id<YanBannerViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isAnimated;
@property (nonatomic, assign) NSUInteger startPage;

- (void)startBannerAutoSwitchWithTimeInterval:(NSTimeInterval) timeInterval;
- (void)stopBannerAutoSwitch;
- (void)reloadYanBannerView;
- (void)moveToPage:(NSInteger)pageNumber;

@end
