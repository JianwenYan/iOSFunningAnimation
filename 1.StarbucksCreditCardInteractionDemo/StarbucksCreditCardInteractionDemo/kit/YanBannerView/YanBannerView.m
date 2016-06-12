//
//  YanBannerView.m
//  YanBannerViewDemo
//
//  Created by 颜建文 on 16/1/6.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "YanBannerView.h"
#import <Masonry.h>

#define DEFAULT_PAGECONTROL_OFFSET_WITH_BOTTOM 36.0

@interface YanBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView  *scrollView;
@property (nonatomic, strong)UIView *scrollContentView;
@property (nonatomic, strong, readwrite)UIPageControl *pageControl;

@property (nonatomic, strong)NSMutableArray<YanBannerViewCell *> *bannerList;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSTimeInterval scheduledTime;
@property (nonatomic, assign)NSInteger currentBannerIndex;
@property (nonatomic, assign)NSInteger bannerCount;
@property (nonatomic, assign)CGFloat bannerWidth;
@property (nonatomic, assign)NSInteger currentPage;

@end

@implementation YanBannerView

@synthesize delegate = _delegate;

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)loadSubView {
    self.isAnimated = YES;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
}

#pragma mark - public method 

- (void)startBannerAutoSwitchWithTimeInterval:(NSTimeInterval) timeInterval {
    if (timeInterval > 0) {
        if (!self.timer && self.bannerCount > 1) {
            self.scheduledTime = timeInterval;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(switchBanner:) userInfo:nil repeats:YES];
        }
    }
}

- (void)stopBannerAutoSwitch {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)reloadYanBannerView {
    self.bannerCount = [self numberOfBannerCellInYanBannerView:self];
    [self.pageControl setNumberOfPages:self.bannerCount];
    self.bannerWidth = [self widthOfBannerCellInYanBannerView:self];
    self.bannerList = nil;
    //add cell
    //step1 - for cycle add last view at first
    if (self.bannerCount > 1) {
        YanBannerViewCell *cell = [self yanBannerView:self cellForIndex:self.bannerCount-1];
        [self.scrollContentView addSubview:cell];
        [self.bannerList addObject:cell];
    }
    //step2 - add cell
    for (NSInteger index = 0; index < self.bannerCount; index++) {
        YanBannerViewCell *cell = [self yanBannerView:self cellForIndex:index];
        if(cell == nil){
        
        }
        [self.scrollContentView addSubview:cell];
        [self.bannerList addObject:cell];
    }
    //step3 - for cycle add first view at first
    if (self.bannerCount > 1) {
        YanBannerViewCell *cell = [self yanBannerView:self cellForIndex:0];
        [self.scrollContentView addSubview:cell];
        [self.bannerList addObject:cell];
    }
    //autolayout
    [self autolayoutSubview];
    
}

- (void)autolayoutSubview {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-[self offsetOfPageControl:self]);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.topMargin.equalTo(self.mas_topMargin);
        make.bottomMargin.equalTo(self.mas_bottomMargin);
    }];
    
    
    YanBannerViewCell *lastCell = nil;
    
    for(YanBannerViewCell *cell in self.bannerList) {
        
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.scrollContentView);
            make.width.mas_equalTo(@(self.bannerWidth));
            if (lastCell) {
                make.left.mas_equalTo(lastCell.mas_right);
            } else {
                make.left.mas_equalTo(self.scrollContentView.mas_left);
            }
        }];
        
        lastCell = cell;
    }
    
    if (lastCell) {
        [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastCell.mas_right);
        }];
    }
    
}

#pragma mark - events response

- (void)switchBanner:(NSTimer *)timer {
    self.currentBannerIndex ++;
    [self.scrollView setContentOffset:CGPointMake(self.bannerWidth * self.currentBannerIndex, 0) animated:self.isAnimated];
}

#pragma mark - scrollview delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = self.currentPage;
    self.currentBannerIndex = currentPage;
    self.pageControl.currentPage = (currentPage == self.bannerCount + 1) ? 0 :currentPage-1;
    if (!self.isAnimated && self.pageControl.currentPage == 0) {
        self.currentBannerIndex = 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger currentPage = self.currentPage;
    if (currentPage == self.bannerCount+1) {
        self.scrollView.contentOffset = CGPointMake(self.bannerWidth, 0);
        self.currentBannerIndex = 1;
    } else if (currentPage == 0) {
        self.scrollView.contentOffset = CGPointMake(self.bannerWidth * self.bannerCount, 0);
        self.currentBannerIndex = self.bannerCount;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = self.currentPage;
    if (currentPage == self.bannerCount+1) {
        self.scrollView.contentOffset = CGPointMake(self.bannerWidth, 0);
        self.currentBannerIndex = 1;
    } else if (currentPage == 0) {
        self.scrollView.contentOffset = CGPointMake(self.bannerWidth * self.bannerCount, 0);
        self.currentBannerIndex = self.bannerCount;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //close timer when begin dragging
    if (self.timer) {
        [self stopBannerAutoSwitch];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //start timer when end dragging
    if (self.timer) {
        [self startBannerAutoSwitchWithTimeInterval:self.scheduledTime];
    }
}

#pragma mark - YanBannerViewDelegate

- (NSUInteger)numberOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView {
    
    NSInteger number = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfBannerCellInYanBannerView:)]) {
        number = [self.delegate numberOfBannerCellInYanBannerView:yanBannerView];
    }
    return number;
}

- (CGFloat)widthOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView {
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    if (self.delegate && [self.delegate respondsToSelector:@selector(widthOfBannerCellInYanBannerView:)]) {
        width = [self.delegate widthOfBannerCellInYanBannerView:yanBannerView];
    }
    return width;
}

- (YanBannerViewCell *)yanBannerView:(YanBannerView *)yanBannerView cellForIndex:(NSInteger)index {
    
    YanBannerViewCell *cell = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(yanBannerView:cellForIndex:)]) {
        cell = [self.delegate yanBannerView:yanBannerView cellForIndex:index];
    }
    return cell;
}

- (CGFloat)offsetOfPageControl:(YanBannerView *)yanBannerView {
    CGFloat offset = DEFAULT_PAGECONTROL_OFFSET_WITH_BOTTOM;
    if (self.delegate && [self.delegate respondsToSelector:@selector(offsetOfPageControl:)]) {
        offset = [self.delegate offsetOfPageControl:yanBannerView];
    }
    return offset;
}

#pragma mark - getters and setters

- (NSMutableArray<YanBannerViewCell *> *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray new];
    }
    return _bannerList;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
    }
    return _pageControl;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [UIView new];
    }
    return _scrollContentView;
}

- (NSInteger)currentPage {
    return (self.scrollView.contentOffset.x + self.bannerWidth / 2) /  self.bannerWidth;
}

- (void)setDelegate:(id<YanBannerViewDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;
        [self reloadYanBannerView];
    }
}

- (void)moveToPage:(NSInteger)pageNumber {
    
    if (self.bannerCount > 1 || pageNumber < self.bannerCount) {
        self.currentBannerIndex = 1 + pageNumber;
        self.scrollView.contentOffset = CGPointMake(self.bannerWidth * self.currentBannerIndex, 0);
    }
    
}

#pragma mark - overwrite

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.bannerCount > 1) {
        self.currentBannerIndex = (self.startPage < self.bannerCount) ?  self.startPage + 1 : 1;
        self.scrollView.contentOffset = CGPointMake(self.currentBannerIndex * self.bannerWidth, 0);
    } else {
        self.currentBannerIndex = 0;
    }
}

@end
