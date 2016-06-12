//
//  YanBannerViewCell.h
//  YanBannerViewDemo
//
//  Created by 颜建文 on 16/1/6.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YanBannerViewCell : UIView


@property (nonatomic, strong, readonly)UIImageView *bannerImageView;
@property (nonatomic, strong, readonly)UILabel *titleLabel;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)CGFloat titleHeight;

@end
