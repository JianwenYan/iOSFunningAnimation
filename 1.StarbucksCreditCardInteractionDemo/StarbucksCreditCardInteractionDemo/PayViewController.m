//
//  PayViewController.m
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/5/28.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "PayViewController.h"
#import <POP/POP.h>
#import "UIView+PopAnimation.h"
#import "PayCardInfoViewController.h"


@interface PayViewController ()

@property (nonatomic, assign) CGFloat payCardWidth;
@property (nonatomic, assign) BOOL isUserCardScaleAnimation;
@property (nonatomic, strong) NSArray *payCardList;

@end

@implementation PayViewController

#pragma mark - life cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.payCardCarousel.type = iCarouselTypeRotary;
    self.payCardCarousel.pagingEnabled =YES;
    self.orLabel.text = @"OR";
    self.agreementLabel.text = @"I agree to Starbucks Card Terms and \r\n Condtions";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.starbucksCardImageView.alpha = 0;
    self.payCardCarousel.alpha = 0;
    self.orLabel.alpha = 0;
    self.agreementLabel.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self enterViewControlelr];
  /*  [self.payCardCarousel.currentItemView addFlyAnimationToPositionY:(self.starbucksCardImageView.frame.origin.y - self.payCardCarousel.frame.origin.y + 50) springSpeed:0];
    POPBaseAnimation *animation =*/
}

#pragma maek - iCarousel Delegate

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
   if (carousel == self.payCardCarousel) {
        if (self.isUserCardScaleAnimation) {
            [self.payCardCarousel.currentItemView addJellyAnimation];
        } else {
            self.isUserCardScaleAnimation = YES;
        }
    }
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.15f;
        }
        case iCarouselOptionArc:
        {
            return M_PI /2;
        }
        case iCarouselOptionFadeMax:
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    if (carousel.currentItemIndex == index) {
        [carousel.currentItemView pop_removeAllAnimations];
        
        //add left and right cards remove animation
        NSInteger rightIndex = carousel.currentItemIndex >= carousel.numberOfItems - 1 ? 0 : carousel.currentItemIndex + 1;
        NSInteger leftIndex = carousel.currentItemIndex == 0 ? carousel.numberOfItems - 1 : carousel.currentItemIndex - 1;
        [carousel.visibleItemViews[leftIndex] addCardFlyDisappearAnimationToPositionX:-100];
        [carousel.visibleItemViews[rightIndex] addCardFlyDisappearAnimationToPositionX:CGRectGetWidth([UIScreen mainScreen].bounds) + 100];
        
        //add starbucks image  remove animation
        [self.starbucksCardImageView addFlyAnimationToPositionY:-CGRectGetHeight(self.starbucksCardImageView.bounds) springSpeed:0];
        
        //add label dispaear animation
        [self.orLabel addDisappearAnimationWithVelocity:4.0];
        [self.agreementLabel addDisappearAnimationWithVelocity:4.0];
        
        //add card move to top animation
        POPPropertyAnimation *cardAnimation = [carousel.currentItemView addCardFlyLargeAnimationToPositionY:(self.starbucksCardImageView.center.y - self.payCardCarousel.frame.origin.y) - 28];
        
        [cardAnimation setCompletionBlock:^(POPAnimation *a, BOOL b) {
            [self leaveViewController];
        }];
    }

}

#pragma mark - iCarousel Data Source

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    if (carousel == self.payCardCarousel) {
        return self.payCardList.count;
    }
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.payCardWidth, self.payCardWidth * 356 / 571)];
        ((UIImageView *)view).image = [UIImage imageNamed:self.payCardList[index]];
        ((UIImageView *)view).contentMode = UIViewContentModeRedraw;
        ((UIImageView *)view).layer.masksToBounds = YES;

    }
    return view;
};

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NSStringFromClass([PayCardInfoViewController class])]) {
        if ([segue.destinationViewController isKindOfClass:[PayCardInfoViewController class]]) {
            PayCardInfoViewController *pcivc = (PayCardInfoViewController *)segue.destinationViewController;
            pcivc.startPage = self.payCardCarousel.currentItemIndex;
        }
    }
}

#pragma mark - private instance method

- (void)enterViewControlelr {
    self.isUserCardScaleAnimation = NO;
    self.payCardWidth = CGRectGetWidth(self.view.bounds) - 40;
    self.payCardCarousel.delegate = self;
    self.payCardCarousel.dataSource = self;

    //first time run animation delay 0.5s for lanuch
    static CGFloat startAnimationDelayTime = 0.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startAnimationDelayTime
                                                              * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        startAnimationDelayTime = 0;
        self.payCardCarousel.hidden = NO;
        [self.starbucksCardImageView addCardFlyRoateAnimationFromPositionY:CGRectGetMaxY(self.orLabel.frame) angel:M_PI_4/2];
        [self.orLabel addAppearAnimationWithVelocity:4.0];
        [self.agreementLabel addAppearAnimationWithVelocity:4.0];
        [self.payCardCarousel addCardFlyAppearAnimationFromPositionY:CGRectGetMaxY(self.payCardCarousel.frame)];
       
    });

}

- (void)leaveViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.payCardCarousel.hidden = YES;
        self.payCardCarousel.delegate = nil;
        self.payCardCarousel.dataSource = nil;
        [self performSegueWithIdentifier:NSStringFromClass([PayCardInfoViewController class]) sender:self];
    });
}

#pragma mark - getters

- (NSArray *)payCardList {
    if (!_payCardList) {
        _payCardList = @[@"apple_pay", @"visa_card", @"master_card"];
    }
    return _payCardList;
}


@end
