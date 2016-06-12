//
//  TopBarPageController.m
//  Phobos
//
//  Created by 颜建文 on 15/10/27.
//  Copyright © 2015年 颜建文. All rights reserved.
//

#import "TopBarPageController.h"
#import "TopBarView.h"
#import "UIColor+Fade.h"
#import <Masonry.h>

#define DEFAULT_TOP_BAR_HEIGHT  (42.0)
#define DEFAULT_INDICATOR_HEIGHT (2.0)
#define DEFAULT_MAX_ITEMS_PER_SCREEN 4

@interface TopBarPageController ()<TopBarDelegate>

@property (nonatomic, strong) TopBarView *topBarView;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) UIView *pageContainView;
@property (nonatomic, assign, readonly) CGFloat pageWidth;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger tapedItemIndex;

@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, assign) NSInteger maxItemsPerPage;
@property (nonatomic, strong) UIColor *topBarColor;
@property (nonatomic, strong) UIFont *itemFont;

//Configure expand item view
@property (nonatomic, assign) BOOL isShowExpandItemView;
@property (nonatomic, assign) BOOL isExpandViewWithMask;
//Configure Page
@property (nonatomic, assign) BOOL isAnimatedWhenTapItem;


@end

@implementation TopBarPageController

#pragma mark - Default Configure

/**
 *  load default configure when view controller init
 */
- (void)loadDefaultConfigure {
    //Configure top bar
    self.topBarHeight = DEFAULT_TOP_BAR_HEIGHT;
    self.maxItemsPerPage = DEFAULT_MAX_ITEMS_PER_SCREEN;
    self.topBarColor = [UIColor whiteColor];
    //grey
    self.topBarView.itemNormalColor = [[UIColor alloc] initWithHue:0.511 saturation:0.11 brightness:0.58 alpha:1.0];
    //watermelon
    self.topBarView.itemSelectedColor = [[UIColor alloc] initWithHue:0.986 saturation:0.6 brightness:0.89 alpha:1.0];
    self.itemFont = [UIFont systemFontOfSize:16.0];
    
    //Configure page
    self.isAnimatedWhenTapItem = YES;
    
    //Configure expand View
    self.isShowExpandItemView = NO;
    self.isExpandViewWithMask = YES;
    self.selectedIndex = 0;
    self.tapedItemIndex = -1;
    self.isShowIndicatorView = YES;
    //self.pageLeftRightMargin = 0;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Check vaild
    if (self.itemTitles.count <= 0 || self.childViewControllers.count <=0 ||
        self.itemTitles.count != self.childViewControllers.count ) {
        return;
    }
    //Load Default Configure
    [self loadDefaultConfigure];
    
    // Add SubView
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.pageScrollView];
    
    [self.pageScrollView addSubview:self.pageContainView];
    
    for (int index = 0; index < self.pageCount; index++) {
        UIViewController *childViewController = self.childViewControllers[index];
        [self addChildViewController: childViewController];
        [self.pageContainView addSubview:childViewController.view];
        [self didMoveToParentViewController:self];
    }
    
    // Auto Layout
    [self layoutSubview];
    
    // KVO
    [self startObservingContentOffsetForPage];
    
    // Move to seleted page
    CGPoint contentOffset = CGPointMake(self.selectedIndex * self.pageWidth, 0);
    [self.pageScrollView setContentOffset:contentOffset animated:YES];
}

- (void)layoutSubview {
    
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_topLayoutGuide).with.offset(self.topBarHeight);
        make.trailing.equalTo(self.view.mas_trailing);
        make.leading.equalTo(self.view.mas_leading);
    }];
    
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    [self.pageContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageScrollView);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
    
    UIView *lastView = nil;
    
    for(UIViewController *vc in self.childViewControllers) {
        
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.pageContainView);
            make.width.mas_equalTo(@(self.pageWidth-self.pageLeftRightMargin*2));
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(self.pageLeftRightMargin*2);
            } else {
                make.left.mas_equalTo(self.pageContainView.mas_left).offset(self.pageLeftRightMargin);
            }
        }];
        
        lastView = vc.view;
    }
    
    [self.pageContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right).offset(self.pageLeftRightMargin);
    }];
}

- (void)dealloc {
    [self stopObservingContentOffsetForPage];
}


#pragma mark - ScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        self.selectedIndex = (x + self.pageWidth / 2) /  self.pageWidth;
        scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.pageScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        self.selectedIndex = (x + self.pageWidth / 2) /  self.pageWidth;
        self.tapedItemIndex = -1;
        scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.pageScrollView && !decelerate) {
        scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.pageScrollView) {
        scrollView.userInteractionEnabled = NO;
        
    }
}

#pragma mark - TopBarView delegate

- (void)topBarView:(TopBarView *)topBarView didSelectItemAtIndex:(NSUInteger)index oldIndex:(NSUInteger)oldIndex {
    CGPoint contentOffset = CGPointMake(index * self.pageWidth, 0);
    self.tapedItemIndex = index;
    [self.pageScrollView setContentOffset:contentOffset animated:self.isAnimatedWhenTapItem];
    if (!self.isAnimatedWhenTapItem) {
        [self.topBarView moveOldItem:oldIndex toSelectedItem:index];
    }
}

#pragma mark - Event response

#pragma mark -- Rotate orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.topBarView updateLayout:self.selectedIndex];
    
    //update layout
    for(UIViewController *vc in self.childViewControllers) {
        [vc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(self.pageWidth));
        }];
    }
    
    //update offset
    CGPoint pageOffset = CGPointMake(self.selectedIndex * self.pageWidth, 0);
    [self.pageScrollView setContentOffset:pageOffset animated:NO];
    [self.topBarView moveToSelectedItem:self.selectedIndex];
    //for landspace ->  portrait
   self.pageScrollView.userInteractionEnabled = YES;
}

#pragma mark -- KVO pageScrollView contentoffset

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self updateTopbarView];
    }
}

- (void)startObservingContentOffsetForPage {
    if (self.pageScrollView) [self.pageScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)stopObservingContentOffsetForPage {
    if (self.pageScrollView) [self.pageScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

/**
 *  update top bar scroll view offset, indicator offset and color fade
 */
- (void)updateTopbarView {
    //获取当前选中索引的oldOffset
    CGFloat oldOffsetX = self.selectedIndex * self.pageWidth;
    
    //oldOffset != contentOffset 且 需要检测实时偏移
    if (oldOffsetX != self.pageScrollView.contentOffset.x) {
        
        NSInteger targetIndex = (self.pageScrollView.contentOffset.x > oldOffsetX) ? self.selectedIndex + 1 : self.selectedIndex - 1;
        
        if (targetIndex >= 0 && targetIndex < self.pageCount) {
            //滑动比例
            CGFloat ratio = (self.pageScrollView.contentOffset.x - oldOffsetX) / self.pageWidth;
            ratio = fabs(ratio);
            //获取当前Item的Offset X
            CGFloat previousItemContentOffsetX = [self.topBarView contentOffsetForSelectedItemAtIndex:self.selectedIndex].x;
            //获取目标Item的Offset X
            CGFloat nextItemContentOffsetX = [self.topBarView contentOffsetForSelectedItemAtIndex:targetIndex].x
            ;
            //获取当前IndicatorX的位置
            CGFloat previousItemPageIndicatorX = self.topBarView.itemViewArray[self.selectedIndex].center.x;
            //获取目标IndicatorX的位置
            CGFloat nextItemPageIndicatorX = self.topBarView.itemViewArray[targetIndex].center.x;
            
            //配置button颜色
            UIButton *previosSelectedItem = self.topBarView.itemViewArray[self.selectedIndex];
            UIButton *nextSelectedItem = self.topBarView.itemViewArray[(self.tapedItemIndex < 0) ? targetIndex : self.tapedItemIndex];
            [previosSelectedItem setTitleColor:[UIColor moveColor:self.topBarView.itemSelectedColor toTargetColor:self.topBarView.itemNormalColor ratio:ratio] forState:UIControlStateNormal];
            [nextSelectedItem setTitleColor:[UIColor moveColor:self.topBarView.itemNormalColor    toTargetColor:self.topBarView.itemSelectedColor ratio:ratio] forState:UIControlStateNormal];
            
            self.topBarView.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX +
                                                              (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
            self.topBarView.indicatorView.center = CGPointMake(previousItemPageIndicatorX +
                                                    (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                    self.topBarView.indicatorView.center.y);
        }
    }
}

#pragma mark - getters and setters

- (CGFloat)pageWidth {
    return CGRectGetWidth(self.view.frame);
}

- (NSInteger)pageCount {
    return self.childViewControllers ? self.childViewControllers.count : 0;
}

- (UIView *)pageContainView {
    if (!_pageContainView) {
        _pageContainView = [[UIView alloc]init];
    }
    return _pageContainView;
}

- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] init];
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.userInteractionEnabled = YES;
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
    }
    
    return _pageScrollView;
}

- (TopBarView *)topBarView {
    if (!_topBarView) {
        CGRect topBarViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.topBarHeight);
        _topBarView = [[TopBarView alloc]initWithFrame:topBarViewFrame itemTitleArray:self.itemTitles maxItemCountOnShow:self.maxItemsPerPage];
        _topBarView.itemFont = self.itemFont;
        _topBarView.delegate = self;
        _topBarView.isUseLeftExpandItem = YES;
    }
    return _topBarView;
}

- (void)setIsShowIndicatorView:(BOOL)isShowIndicatorView {
    if (_isShowIndicatorView != isShowIndicatorView) {
        _isShowIndicatorView = isShowIndicatorView;
        self.topBarView.indicatorView.hidden = !isShowIndicatorView;
    }
}

- (void)setPageLeftRightMargin:(CGFloat) margin {
    if (margin != _pageLeftRightMargin) {
        _pageLeftRightMargin = margin;
        [self updateTopbarViewLeftRightLayout:margin];
    }
}

- (void)setPageTopMargin:(CGFloat)pageTopMargin {
    if (_pageTopMargin != pageTopMargin) {
        _pageTopMargin = pageTopMargin;
        [self updateTopbarViewTopLayout:pageTopMargin];
    }
}

- (void)setIsUsePageConner:(BOOL)isUsePageConner {
    if (_isUsePageConner != isUsePageConner) {
        _isUsePageConner = isUsePageConner;
    }
    [self configPageConner:isUsePageConner];
}

#pragma mark - private instance methods 

- (void)updateTopbarViewLeftRightLayout:(CGFloat)pageLeftRightMargin {
    UIView *lastView = nil;
    
    for(UIViewController *vc in self.childViewControllers) {
        
        [vc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(self.pageWidth - pageLeftRightMargin*2));
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(pageLeftRightMargin*2);
            } else {
                make.left.mas_equalTo(self.pageContainView.mas_left).offset(pageLeftRightMargin);
            }
        }];
        
        lastView = vc.view;
    }
    
    [self.pageContainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right).offset(self.pageLeftRightMargin);
    }];
    
    if (self.isUsePageConner) {
        [self configPageConner: YES];
    }
}

- (void)updateTopbarViewTopLayout:(CGFloat)pageTopMargin {
    for(UIViewController *vc in self.childViewControllers) {
        [vc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pageContainView).offset(pageTopMargin);
        }];
    }
}

- (void)configPageConner:(BOOL) isConner{
    
    CGSize radii = isConner ? CGSizeMake(10, 10) : CGSizeMake(0, 0);
    
    for(UIViewController *vc in self.childViewControllers) {
        
        CGRect rect = CGRectMake(vc.view.bounds.origin.x, vc.view.bounds.origin.y, vc.view.bounds.size.width-self.pageLeftRightMargin*2, vc.view.bounds.size.height);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:radii];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = rect;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        vc.view.layer.mask = maskLayer;
    }
}


@end
