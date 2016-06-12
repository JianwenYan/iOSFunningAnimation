//
//  UIView+PopAnimation.m
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/6/1.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import "UIView+PopAnimation.h"


NSString *const kAppearAnimation = @"kAppearAnimation";
NSString *const kDisappearAnimation = @"kDisappearAnimation";

NSString *const kJellyAnimationSmall = @"kJellyAnimationSmall";
NSString *const kJellyAnimationNormal = @"kJellyAnimationNormal";
NSString *const kJellyAnimationLarge = @"kJellyAnimationLarge";

NSString *const kRoateAnimation = @"kRoateAnimation";
NSString *const kFlyAnimationToPositionY = @"kFlyAnimationToPositionY";
NSString *const kFlyAnimationFromPositionY = @"kFlyAnimationFromPositionY";
NSString *const kFlyAnimationToPositionX = @"kFlyAnimationToPositionX";
NSString *const kFlyAnimationFromPositionX = @"kFlyAnimationFromPositionX";
NSString *const kFlyAnimationFromCenter = @"kFlyAnimationFromCenter";

NSString *const kCardLargeAnimation = @"kCardLargeAnimation";

NSString *const kCardFlyAnimationAppear = @"kCardFlyAnimationAppear";
NSString *const kCardFlyAnimationRoate = @"kCardFlyAnimationRoate";
NSString *const kCardFlyAnimationFly = @"kCardFlyAnimationFly";
NSString *const kCardAnimationRemove = @"kCardAnimationRemove";


@implementation UIView(PopAnimation)

#pragma mark - Basic Animation

- (POPPropertyAnimation *)addAppearAnimationWithVelocity:(CGFloat)velocity {
    POPDecayAnimation *appearAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    appearAnimation.fromValue = @0.0;
    appearAnimation.velocity = @(fabs(velocity));
    appearAnimation.deceleration = 0.998;
    [self.layer pop_addAnimation:appearAnimation forKey:kAppearAnimation];
    return appearAnimation;
}

- (void)removeAppearAnimation {
    [self.layer pop_removeAnimationForKey:kAppearAnimation];
}

- (POPPropertyAnimation *)addDisappearAnimationWithVelocity:(CGFloat)velocity {
    POPDecayAnimation *appearAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    appearAnimation.fromValue = @1.0;
    appearAnimation.velocity = @(-fabs(velocity));
    appearAnimation.deceleration = 0.998;
    [self.layer pop_addAnimation:appearAnimation forKey:kDisappearAnimation];
    return appearAnimation;
}

- (void)removeDisappearAnimation {
    [self.layer pop_removeAnimationForKey:kDisappearAnimation];
}

- (POPPropertyAnimation *)addRoateAniamationFromAngel:(CGFloat)fromAngel toAngel:(CGFloat)toAngel {
    POPSpringAnimation *roateAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    
    roateAnimation.fromValue = @(fromAngel);
    roateAnimation.toValue = @(toAngel);
    roateAnimation.dynamicsTension = 100;
    
    [self.layer pop_addAnimation:roateAnimation forKey:kRoateAnimation];
    
    return roateAnimation;
}

- (void)removeRoateAnimation {
    [self.layer pop_animationForKey:kRoateAnimation];
}


- (POPPropertyAnimation *)addFlyAnimationFromPositionY:(CGFloat)positionY springSpeed:(CGFloat)springSpeed {
    
    POPSpringAnimation *flyAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    flyAnimation.fromValue = @(positionY);
    if (springSpeed > 0) {
        flyAnimation.springSpeed = springSpeed;
    }
    flyAnimation.dynamicsTension = 100;
    [self.layer pop_addAnimation:flyAnimation forKey:kFlyAnimationFromPositionY];
    
    return flyAnimation;
}

- (void)removeFlyAnimationFromPostionY {
    [self.layer pop_removeAnimationForKey:kFlyAnimationFromPositionY];
}

- (POPPropertyAnimation *)addFlyAnimationToPositionY:(CGFloat)positionY springSpeed:(CGFloat)springSpeed {
    
    POPSpringAnimation *flyAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    flyAnimation.toValue = @(positionY);
    if (springSpeed > 0) {
        flyAnimation.springSpeed = springSpeed;
    }
    flyAnimation.dynamicsTension = 100;
    [self.layer pop_addAnimation:flyAnimation forKey:kFlyAnimationToPositionY];
    
    return flyAnimation;
}

- (void)removeFlyAnimationToPostionY {
    [self.layer pop_removeAnimationForKey:kFlyAnimationToPositionY];
}

- (POPPropertyAnimation *)addFlyAnimationFromPositionX:(CGFloat)positionX springSpeed:(CGFloat)springSpeed {
    
    POPSpringAnimation *flyAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    flyAnimation.fromValue = @(positionX);
    if (springSpeed > 0) {
        flyAnimation.springSpeed = springSpeed;
    }
    flyAnimation.dynamicsTension = 100;
    [self.layer pop_addAnimation:flyAnimation forKey:kFlyAnimationFromPositionX];
    
    return flyAnimation;
}

- (void)removeFlyAnimationFromPostionX {
    [self.layer pop_removeAnimationForKey:kFlyAnimationFromPositionX];
}

- (POPPropertyAnimation *)addFlyAnimationToPositionX:(CGFloat)positionX springSpeed:(CGFloat)springSpeed {
    
    POPSpringAnimation *flyAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    flyAnimation.toValue = @(positionX);
    if (springSpeed > 0) {
        flyAnimation.springSpeed = springSpeed;
    }
    flyAnimation.dynamicsTension = 100;
    [self.layer pop_addAnimation:flyAnimation forKey:kFlyAnimationToPositionX];
    
    return flyAnimation;
}

- (void)removeFlyAnimationToPostionX {
    [self.layer pop_removeAnimationForKey:kFlyAnimationToPositionX];
}

- (POPPropertyAnimation *)addFlyAnimationToCenter:(CGPoint)center springSpeed:(CGFloat)springSpeed {
    POPSpringAnimation *flyAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    flyAnimation.toValue = [NSValue valueWithCGPoint:center];
    if (springSpeed > 0) {
        flyAnimation.springSpeed = springSpeed;
    }
    [self pop_addAnimation:flyAnimation forKey:kFlyAnimationFromCenter];
    return flyAnimation;
}

- (void)removeFlyAnimationToCenter {
    [self.layer pop_removeAnimationForKey:kFlyAnimationFromCenter];
}


#pragma mark - Group Animation

- (POPPropertyAnimation *)addJellyAnimation {
    POPSpringAnimation *jellySmallAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    jellySmallAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.98, 0.98)];
    jellySmallAnimation.springSpeed = 20;
    
    POPSpringAnimation *jellyNormalAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    jellyNormalAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    jellyNormalAnimation.springSpeed = 20;
    
    POPSpringAnimation *cardLargeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    cardLargeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.02, 1.02)];
    cardLargeAnimation.springSpeed = 20;
    
    [cardLargeAnimation setCompletionBlock:^(POPAnimation *anmation, BOOL isFinish) {
        if (isFinish) {
            [self.layer pop_addAnimation:jellySmallAnimation forKey:kJellyAnimationSmall];
        }
    }];
    
    [jellySmallAnimation setCompletionBlock:^(POPAnimation *anmation, BOOL isFinish) {
        if (isFinish) {
            [self.layer pop_addAnimation:jellyNormalAnimation forKey:kJellyAnimationNormal];
        }
    }];
    
    [self.layer pop_addAnimation:cardLargeAnimation forKey:kJellyAnimationLarge];
    return jellyNormalAnimation;
}

- (void)removeJellyAnimation {
    [self.layer pop_removeAnimationForKey:kJellyAnimationSmall];
    [self.layer pop_removeAnimationForKey:kJellyAnimationNormal];
    [self.layer pop_removeAnimationForKey:kJellyAnimationLarge];
}

- (POPPropertyAnimation *)addCardFlyAppearAnimationFromPositionY:(CGFloat)positionY {
    [self addAppearAnimationWithVelocity:4.0];
    return [self addFlyAnimationFromPositionY:positionY springSpeed:0];;
}

- (void)removeCardFlyAppearAnimationFromPositionY {
    [self removeAppearAnimation];
    [self removeFlyAnimationFromPostionY];
}

- (POPPropertyAnimation *)addCardFlyDisappearAnimationFromPositionY:(CGFloat)positionY {
    [self addDisappearAnimationWithVelocity:4.0];
    return [self addFlyAnimationFromPositionY:positionY springSpeed:0];;
}

- (void)removeCardFlyDisappearAnimationFromPositionY {
    [self removeDisappearAnimation];
    [self removeFlyAnimationFromPostionY];
}

- (POPPropertyAnimation *)addCardFlyAppearAnimationToPositionY:(CGFloat)positionY {
    [self addAppearAnimationWithVelocity:4.0];
    return [self addFlyAnimationToPositionY:positionY springSpeed:0];;
}

- (void)removeCardFlyAppearAnimationToPositionY {
    [self removeAppearAnimation];
    [self removeFlyAnimationToPostionY];
}

- (POPPropertyAnimation *)addCardFlyDisappearAnimationToPositionY:(CGFloat)positionY {
    [self addDisappearAnimationWithVelocity:4.0];
    return [self addFlyAnimationToPositionY:positionY springSpeed:0];;
}

- (void)removeCardFlyDisappearAnimationToPositionY {
    [self removeDisappearAnimation];
    [self removeFlyAnimationToPostionY];
}

- (POPPropertyAnimation *)addCardFlyDisappearAnimationToPositionX:(CGFloat)positionX {
    [self addDisappearAnimationWithVelocity:4.0];
    return [self addFlyAnimationToPositionX:positionX springSpeed:0];
}

- (void)removeCardFlyDisappearAnimationToPositionX {
    [self removeDisappearAnimation];
    [self removeFlyAnimationToPostionX];
}

- (POPPropertyAnimation *)addCardFlyRoateAnimationFromPositionY:(CGFloat)positionY angel:(CGFloat)angel {
    [self addRoateAniamationFromAngel:angel toAngel:0];
    return [self addCardFlyAppearAnimationFromPositionY:positionY];
}

- (void)removeCardFlyRoateAnimationFromPositionY {
    [self removeAppearAnimation];
    [self removeCardFlyRoateAnimationFromPositionY];
}

- (POPPropertyAnimation *)addCardFlyLargeAnimationToPositionY:(CGFloat)positionY {
    /*
    self.layer.masksToBounds = YES;
    
    [self addFlyAnimationToPositionY:positionY springSpeed:10];
    
    POPSpringAnimation *connerSmallAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    connerSmallAnimation.fromValue = @(0);
    connerSmallAnimation.toValue = @(self.frame.size.width/2);

    
    POPSpringAnimation *connerNormalAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    connerNormalAnimation.toValue = @(0);

    
    POPSpringAnimation *cardLargeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    cardLargeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.24, 1.24)];
    [self.layer pop_addAnimation:cardLargeAnimation forKey:kCardLargeAnimation];
    
    [self.layer pop_addAnimation:connerSmallAnimation forKey:@"kConnerSmallAnimation"];
    [connerSmallAnimation setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        if (isFinish) {
            [self.layer pop_addAnimation:connerNormalAnimation forKey:@"kConnerNormalAnimation"];
            [self.layer pop_addAnimation:cardLargeAnimation forKey:kCardLargeAnimation];
        }
    }];
    */
    
    POPSpringAnimation *cardLargeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    cardLargeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.20, 1.20)];
    [self.layer pop_addAnimation:cardLargeAnimation forKey:kCardLargeAnimation];
    [self addFlyAnimationToPositionY:positionY springSpeed:2];
    
    return cardLargeAnimation;
}

- (void)removeCardFlyLargeAnimationToPositionY {
    [self.layer pop_removeAnimationForKey:kCardLargeAnimation];
    [self removeFlyAnimationFromPostionY];
}

@end
