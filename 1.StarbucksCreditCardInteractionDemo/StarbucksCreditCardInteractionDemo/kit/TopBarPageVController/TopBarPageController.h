//
//  TopBarPageController.h
//  Phobos
//
//  Created by 颜建文 on 15/10/27.
//  Copyright © 2015年 颜建文. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TopBarView.h"

@interface TopBarPageController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *itemTitles;
@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;
@property (nonatomic, strong, readonly)TopBarView *topBarView;

@property (nonatomic, assign) BOOL isShowIndicatorView;
@property (nonatomic, assign) BOOL isUsePageConner;
@property (nonatomic, assign) CGFloat pageLeftRightMargin;
@property (nonatomic, assign) CGFloat pageTopMargin;


@end
