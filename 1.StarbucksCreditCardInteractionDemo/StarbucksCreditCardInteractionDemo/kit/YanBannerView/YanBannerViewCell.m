//
//  YanBannerViewCell.m
//  YanBannerViewDemo
//
//  Created by 颜建文 on 16/1/6.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "YanBannerViewCell.h"
#import <Masonry.h>

#define DEFAULT_TITLE_HEIGHT (32.0f)

@interface YanBannerViewCell()

@property (nonatomic, strong, readwrite)UIImageView *bannerImageView;
@property (nonatomic, strong, readwrite)UILabel *titleLabel;

@end

@implementation YanBannerViewCell

#pragma mark - getter

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [UIImageView new];
    }
    return _bannerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [[UIColor alloc]initWithWhite:0.6 alpha:0.4];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = [title copy];;
}

- (void)setImage:(UIImage *)image {
    self.bannerImageView.image = image;
}


#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubView];
    }
    return self;
}


- (void)loadSubView {
    self.titleHeight = DEFAULT_TITLE_HEIGHT;
    [self addSubview:self.bannerImageView];
    [self addSubview:self.titleLabel];
    [self autolayoutSubviews];
}

- (void)autolayoutSubviews {
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-self.titleHeight);
    }];
}


@end
