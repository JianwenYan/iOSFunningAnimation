//
//  TopBarView.m
//  TopBarPageControllerDemo
//
//  Created by 颜建文 on 15/11/3.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import "TopBarView.h"
#import "TopBarIndicatorView.h"
#import <Masonry.h>

#define DEFAULT_INDICATOR_LINE_STYLE_HEIGHT 2.0
#define DEFAULT_EXPANDITEM_WIDTH    40.0

@interface TopBarView()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *scrolContentView;
@property (nonatomic, strong, readwrite) TopBarIndicatorView *indicatorView;


@property (nonatomic, strong, readwrite) NSArray *itemViewArray;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *itemTitleArray;
@property (nonatomic, assign, readwrite) NSInteger itemCount;
@property (nonatomic, assign, readwrite) NSInteger maxItemCountOnShow;
@property (nonatomic, strong, readwrite) UIButton *leftExpandItem;
@property (nonatomic, strong, readwrite) UIButton *rightExpandItem;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation TopBarView

#pragma mark - Public instance method

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"init");
        [self loadDefaultConfigure];
    }
    return self;
}

/**
 *  初始化TopBarView
 *
 *  @param frame
 *  @param itemStyle
 *  @param itemTitleArray
 *  @param maxItemCountOnShow
 *
 *  @return （TopBarView ＊）
 */
- (instancetype)initWithFrame:(CGRect)frame itemTitleArray:(NSArray *)itemTitleArray maxItemCountOnShow:(NSUInteger)maxItemCountOnShow {
    self = [super initWithFrame:frame];
    NSLog(@"initWithFrame");
    if (self) {
        if (itemTitleArray && itemTitleArray.count > 0) {
            [self loadDefaultConfigure];
            self.selectedIndex = 0;
            self.itemCount = itemTitleArray.count;
            self.itemTitleArray = [itemTitleArray copy];
            self.maxItemCountOnShow = maxItemCountOnShow;
            [self loadSubView];
        }
    }
    
    return self;
}

/**
 *  根据item的index索引计算Top Bar的偏移
 *
 *  @param index item的index索引号
 *
 *  @return (CGPoint *) 偏移坐标
 */
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index {
    if (self.itemCount < index || self.itemCount == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
        return CGPointMake(index * totalOffset / (self.itemCount - 1), 0.);
    }
}

- (void)moveOldItem:(NSUInteger)oldIndex toSelectedItem:(NSInteger) selectedIndex {
    [self.itemViewArray[oldIndex] setTitleColor:self.itemNormalColor forState:UIControlStateNormal];
    [self.itemViewArray[selectedIndex] setTitleColor:self.itemSelectedColor forState:UIControlStateNormal];
    CGPoint contentOffset = [self contentOffsetForSelectedItemAtIndex:selectedIndex];
    [self.scrollView setContentOffset:contentOffset animated:YES];
    self.indicatorView.center = CGPointMake(self.itemViewArray[selectedIndex].center.x, self.indicatorView.center.y);
}

- (void)moveToSelectedItem:(NSInteger) selectedIndex {
    
    for (UIButton *item in self.itemViewArray) {
        UIColor *titleColor = item.tag == selectedIndex ? self.itemSelectedColor : self.itemNormalColor;
        [item setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    CGPoint contentOffset = [self contentOffsetForSelectedItemAtIndex:selectedIndex];
    [self.scrollView setContentOffset:contentOffset animated:YES];
    self.indicatorView.center = CGPointMake(self.itemViewArray[selectedIndex].center.x, self.indicatorView.center.y);
}

- (void)updateLayout:(NSInteger) index {
    self.scrollView.contentSize = CGSizeMake(self.itemWidth*self.itemCount, 0);
    
    for (int index = 0; index < self.itemCount; index++) {
        self.itemViewArray[index].frame = CGRectMake(index * self.itemWidth, 0, self.itemWidth, CGRectGetHeight(self.frame));
    }
    
    CGFloat indicatorY = CGRectGetHeight(self.frame) - DEFAULT_INDICATOR_LINE_STYLE_HEIGHT;
    self.indicatorView.frame = CGRectMake(self.itemWidth*index, indicatorY, self.itemWidth, DEFAULT_INDICATOR_LINE_STYLE_HEIGHT);
    
    CGPoint topBarOffset = [self contentOffsetForSelectedItemAtIndex:index];
    [self.scrollView setContentOffset:topBarOffset animated:YES];
}


#pragma mark - Private instance method

/**
 *  加载默认配置
 */
- (void)loadDefaultConfigure {
    NSLog(@"loadDefaultConfigure");
    self.backgroundColor = [UIColor whiteColor];
    
    //Configure Item
    self.itemNormalColor = [[UIColor alloc] initWithHue:0.511 saturation:0.11 brightness:0.58 alpha:1.0];//grey
    self.itemSelectedColor = [[UIColor alloc] initWithHue:0.986 saturation:0.6 brightness:0.89 alpha:1.0];//watermelon
    self.itemFont = [UIFont systemFontOfSize:16.0];
    self.isUseRightExpandItem = NO;
    self.isUseLeftExpandItem = NO;
    self.topBarIndicatorType = TopBarIndicatorTypeLine;
    
    self.selectedIndex = 0;
    self.isUseLeftExpandItem = YES;
    self.isUseRightExpandItem  = YES;
}

/**
 *  加载SubView
 */
- (void)loadSubView {
    
    self.maxItemCountOnShow = self.maxItemCountOnShow > self.itemCount ? self.itemCount : self.maxItemCountOnShow;
    [self addSubview: self.scrollView];
    if (self.leftExpandItem) {
        [self addSubview:self.leftExpandItem];
    }
    if (self.rightExpandItem) {
        [self addSubview:self.rightExpandItem];
    }
    [self configureTopBarItem];
    [self.scrollView addSubview:self.indicatorView];
    [self layoutSubview];
    //[self configureExpandItem];
}


#pragma mark -- Configure top bar item

/**
 *  配置TopBarItem
 */
- (void)configureTopBarItem {
    
    NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:self.itemCount];
    CGFloat buttonHeight = CGRectGetHeight(self.frame);
    
    for (NSUInteger index = 0; index < self.itemCount; index++) {
        CGRect buttonFrame = CGRectMake(index * self.itemWidth, 0, self.itemWidth, buttonHeight);
        UIButton *itemButton = [[UIButton alloc]initWithFrame: buttonFrame];
        itemButton.tag = index;
        [itemButton addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *itemString = self.itemTitleArray[index];
        UIColor *itemColor = (index == 0) ? self.itemSelectedColor : self.itemNormalColor;
        
        [itemButton setTitle:itemString forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:self.itemFont];
        [itemButton setTitleColor: itemColor forState:UIControlStateNormal];
        
        [self.scrollView addSubview:itemButton];
        [mutableItemViews addObject:itemButton];
    }
    
    self.itemViewArray = [NSArray arrayWithArray:mutableItemViews];

}

- (void)layoutSubview {
    

   [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       //make.edges.equalTo(self);
       make.left.equalTo(self).offset(self.isUseLeftExpandItem ? DEFAULT_EXPANDITEM_WIDTH : 0);
       make.right.equalTo(self).offset(self.isUseRightExpandItem ? -DEFAULT_EXPANDITEM_WIDTH : 0);
       make.top.equalTo(self);
       make.bottom.equalTo(self);
   }];
    
    if (self.isUseLeftExpandItem) {
        
        [self.leftExpandItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-DEFAULT_INDICATOR_LINE_STYLE_HEIGHT);
            make.right.equalTo(self.scrollView.mas_left);
        }];
    }
    
    if (self.isUseRightExpandItem) {
        [self.rightExpandItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-DEFAULT_INDICATOR_LINE_STYLE_HEIGHT);
            make.right.equalTo(self);
        }];
    }

}

#pragma mark - Events respone

- (void)selectItem:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarView:didSelectItemAtIndex:oldIndex:)]) {
        [self.delegate topBarView:self didSelectItemAtIndex:button.tag oldIndex:self.selectedIndex];
    } else {
        [self moveOldItem:self.selectedIndex toSelectedItem:button.tag];
    }
    self.selectedIndex = button.tag;
}

- (void)clickRightItem:(UIButton *)button {
    NSLog(@"clickLeftItem");
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarView:didSelectRightExpandItem:)]) {
        [self.delegate topBarView:self didSelectRightExpandItem:button];
    }
    
}

- (void)clickLeftItem:(UIButton *)button {
    NSLog(@"clickRightItem");
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarView:didSelectLeftExpandItem:)]) {
        [self.delegate topBarView:self didSelectLeftExpandItem:button];
    }
    
}

#pragma mark - getters and setters


- (CGFloat)itemWidth {
    return CGRectGetWidth(self.bounds) / self.maxItemCountOnShow;
}

- (void)setItemFont:(UIFont *)itemFont
{
    if (!itemFont) {
        return;
    }
    
    _itemFont = itemFont;
    for (UIButton *itemButton in self.itemViewArray) {
        [itemButton.titleLabel setFont:itemFont];
    }
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    
    if (!itemNormalColor) {
        return;
    }
    
    _itemNormalColor = itemNormalColor;
    for (UIButton *itemButton in self.itemViewArray) {
        if (itemButton.tag != self.selectedIndex) {
            [itemButton setTitleColor:itemNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    
    if (!itemSelectedColor) {
        return;
    }
    
    _itemSelectedColor = itemSelectedColor;
    [self.itemViewArray[self.selectedIndex] setTitleColor:itemSelectedColor forState:UIControlStateNormal];
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        UIScrollView *topBarScrollView = [[UIScrollView alloc]init];
        topBarScrollView.contentSize = CGSizeMake(self.itemWidth * self.itemCount, 0);
        topBarScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        topBarScrollView.showsVerticalScrollIndicator = NO;
        topBarScrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = topBarScrollView;
    }
    
    return _scrollView;
}

- (UIView *)scrolContentView {
    
    if (!_scrolContentView) {
        _scrolContentView  = [[UIScrollView alloc] init];
    }
    
    return _scrolContentView;
}

- (TopBarIndicatorView *)indicatorView {
    
    if (!_indicatorView) {

        CGRect indicatorFrame;
        
        if (self.topBarIndicatorType == TopBarIndicatorTypeLine) {
            CGFloat indicatorWidth = CGRectGetWidth(self.itemViewArray[0].frame);
            CGFloat indicatorY = CGRectGetHeight(self.frame) - DEFAULT_INDICATOR_LINE_STYLE_HEIGHT;
            indicatorFrame = CGRectMake(0, indicatorY, indicatorWidth, DEFAULT_INDICATOR_LINE_STYLE_HEIGHT);
        } else if (self.topBarIndicatorType == TopBarIndicatorTypeTriangle) {
            
            
        }
        
        TopBarIndicatorView *topBarIndicatorView = [[TopBarIndicatorView alloc] initWithFrame:indicatorFrame indicatorStyle:self.topBarIndicatorType indicatorColor:self.itemSelectedColor];
         NSLog(@"topBarIndicatorView");
      _indicatorView = topBarIndicatorView;
    }
    
    return _indicatorView;
}

- (UIButton *)leftExpandItem {
    if (!_leftExpandItem) {
        NSLog(@"leftExpandItem");
        _leftExpandItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftExpandItem setTitle:@"L" forState:UIControlStateNormal];
        [_leftExpandItem setTitleColor:_itemSelectedColor forState:UIControlStateNormal];
        [_leftExpandItem addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftExpandItem;
}

- (UIButton *)rightExpandItem {
    if (!_rightExpandItem) {
        _rightExpandItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightExpandItem setTitle:@"R" forState:UIControlStateNormal];
        [_rightExpandItem setTitleColor:_itemSelectedColor forState:UIControlStateNormal];
        [_rightExpandItem addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightExpandItem;
}

- (void)setIsUseLeftExpandItem:(BOOL)isUseLeftExpandItem {
    if (_isUseLeftExpandItem != isUseLeftExpandItem) {
        self.leftExpandItem.hidden = YES;
    }
}

- (void)setIsUseRightExpandItem:(BOOL)isUseRightExpandItem {
    if (_isUseRightExpandItem != isUseRightExpandItem) {
        self.rightExpandItem.hidden = YES;
    }
}


@end