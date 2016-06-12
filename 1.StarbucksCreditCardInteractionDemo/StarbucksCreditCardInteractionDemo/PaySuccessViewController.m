//
//  PaySuccessViewController.m
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/6/6.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "PaySuccessViewController.h"
#import <POP/POP.h>
#import "UIView+PopAnimation.h"
#import <ChameleonFramework/Chameleon.h>

@interface PaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cupImageView;
@property (weak, nonatomic) IBOutlet UILabel *hurryLabel;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backImageView.alpha = 0;
    self.cupImageView.alpha = 0;
    self.hurryLabel.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    [self scaleAnimation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scaleAnimation {
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(3.0, 3.0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [anim setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        if (isFinish) {
            [self.cupImageView addCardFlyAppearAnimationFromPositionY:CGRectGetMaxY(self.backImageView.frame)];
            [self.hurryLabel addAppearAnimationWithVelocity:4.0];
        }
    }];
    [self.backImageView.layer pop_addAnimation:anim forKey:@"scaleAnimation"];
    [self.backImageView addAppearAnimationWithVelocity:4.0];
}


- (IBAction)restart:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
