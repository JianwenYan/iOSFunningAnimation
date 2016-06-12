//
//  MainViewController.hr.m
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/5/28.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "MainViewController.h"
#import "PayViewController.h"
#import <ChameleonFramework/Chameleon.h>

@implementation MainViewController

@synthesize itemTitles = _itemTitles;
@synthesize childViewControllers = _childViewControllers;

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBarView.isUseLeftExpandItem = NO;
    self.topBarView.isUseRightExpandItem = NO;
    self.topBarView.backgroundColor = [UIColor flatBlackColor];
    self.topBarView.itemNormalColor  = [UIColor flatGrayColorDark];
    self.topBarView.itemSelectedColor = [UIColor flatWhiteColor];
    self.isShowIndicatorView = NO;
    self.view.backgroundColor = [UIColor flatBlackColor];
    self.pageLeftRightMargin = 10;
    self.pageTopMargin = 4;
    self.isUsePageConner = YES;
    
}


#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - getters

- (NSArray<NSString *> *) itemTitles {
    if (!_itemTitles) {
        _itemTitles = @[@"PAY", @"STORES",  @"GIFT"];
    }
    return _itemTitles;
}

- (NSArray<UIViewController *> *) childViewControllers {
    if (!_childViewControllers) {
        
        UIStoryboard *payStoryboard = [UIStoryboard storyboardWithName:@"Pay" bundle:nil];
        
        UINavigationController *vc1 = [payStoryboard instantiateViewControllerWithIdentifier:@"PayNavigationController"];
        UIViewController *vc2 = [UIViewController new];
        UIViewController *vc3 = [UIViewController new];
        
        vc1.view.backgroundColor = [UIColor whiteColor];
        vc2.view.backgroundColor = [UIColor whiteColor];
        vc3.view.backgroundColor = [UIColor whiteColor];
        
        _childViewControllers = @[vc1, vc2, vc3];
        
    }
    
    return _childViewControllers;
}


@end
