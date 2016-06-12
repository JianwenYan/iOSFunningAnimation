//
//  PayCardInfoViewController.m
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/5/30.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "PayCardInfoViewController.h"
#import "YanBannerView.h"
#import <ChameleonFramework/Chameleon.h>
#import "UIView+PopAnimation.h"
#import <POP.h>

@interface PayCardInfoViewController () <YanBannerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet YanBannerView *cardBannerView;
@property (nonatomic, strong) NSArray *payCardList;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@end

@implementation PayCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cardBannerView.pageControl.pageIndicatorTintColor  = [UIColor flatWhiteColor];
    self.cardBannerView.pageControl.currentPageIndicatorTintColor = [UIColor flatGrayColor];
    self.doneButton.alpha = 0;
    self.cardInfoView.alpha = 0;
    [self.doneButton setBackgroundColor:[UIColor flatCoffeeColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.cardBannerView.delegate = self;
    self.cardBannerView.startPage = self.startPage;
    
    [self.doneButton addCardFlyAppearAnimationFromPositionY: CGRectGetHeight([UIScreen mainScreen].bounds)];
    [self.cardInfoView addAppearAnimationWithVelocity:4.0];
    
}


#pragma mark - YanBannerView datasource 

- (NSUInteger)numberOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView {
    return self.payCardList.count;
}

- (CGFloat)widthOfBannerCellInYanBannerView:(YanBannerView *)yanBannerView {
    return CGRectGetWidth(self.cardBannerView.frame);
}

- (CGFloat)offsetOfPageControl:(YanBannerView *)yanBannerView {
    return 8.0;
}

 
- (YanBannerViewCell *)yanBannerView:(YanBannerView *)yanBannerView cellForIndex:(NSInteger)index {
    YanBannerViewCell *cell = [YanBannerViewCell new];
    cell.titleLabel.hidden = YES;
    cell.image = [UIImage imageNamed:self.payCardList[index]];
    cell.bannerImageView.contentMode = UIViewContentModeRedraw;
    return cell;
}

#pragma mark - events response

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)success:(UIButton *)sender {
    
    UIView *maskView = [[UIView alloc]initWithFrame: CGRectMake(self.view.frame.origin.x, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
                        ];
    maskView.backgroundColor = [UIColor flatCoffeeColor];
    [self.view addSubview:maskView];
    

    POPSpringAnimation *colorAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    colorAnimation.toValue = [UIColor whiteColor];
    [colorAnimation setCompletionBlock:^(POPAnimation *a, BOOL s) {
        [self performSegueWithIdentifier:@"PaySuccessSegueIdentifier" sender:self];
        [maskView removeFromSuperview];
    }];
    
    [[maskView addFlyAnimationToCenter:self.view.center springSpeed:0] setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        if (isFinish) {
            [maskView.layer pop_addAnimation:colorAnimation forKey:@"kColorAnimation"];
        }
    }];
    
}

#pragma mark - getters

- (NSArray *)payCardList {
    if (!_payCardList) {
        _payCardList = @[
                         @"apple_pay_large",
                         @"visa_large",
                         @"master_large",
                        ];
    }
    return _payCardList;
}

@end
