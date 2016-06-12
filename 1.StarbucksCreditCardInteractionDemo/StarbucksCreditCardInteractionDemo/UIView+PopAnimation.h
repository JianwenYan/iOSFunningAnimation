//
//  UIView+PopAnimation.h
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/6/1.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>

@interface UIView(PopAnimation)

#pragma mark  -  Basic Animation
- (POPPropertyAnimation *)addAppearAnimationWithVelocity:(CGFloat)velocity;
- (void)removeAppearAnimation;

- (POPPropertyAnimation *)addDisappearAnimationWithVelocity:(CGFloat)velocity;
- (void)removeDisappearAnimation;

- (POPPropertyAnimation *)addFlyAnimationFromPositionY:(CGFloat)positionY springSpeed:(CGFloat)springSpeed;
- (void)removeFlyAnimationFromPostionY;

- (POPPropertyAnimation *)addFlyAnimationToPositionY:(CGFloat)positionY springSpeed:(CGFloat)springSpeed;
- (void)removeFlyAnimationToPostionY;

- (POPPropertyAnimation *)addFlyAnimationFromPositionX:(CGFloat)positionX springSpeed:(CGFloat)springSpeed;
- (void)removeFlyAnimationFromPostionX ;

- (POPPropertyAnimation *)addFlyAnimationToPositionX:(CGFloat)positionX springSpeed:(CGFloat)springSpeed;
- (void)removeFlyAnimationToPostionX;


#pragma mark - Group Animation

- (POPPropertyAnimation *)addJellyAnimation;
- (void)removeJellyAnimation;

- (POPPropertyAnimation *)addCardFlyAppearAnimationFromPositionY:(CGFloat)positionY;
- (void)removeCardFlyAppearAnimationFromPositionY;

- (POPPropertyAnimation *)addCardFlyDisappearAnimationFromPositionY:(CGFloat)positionY;
- (void)removeCardFlyDisappearAnimationFromPositionY;

- (POPPropertyAnimation *)addCardFlyDisappearAnimationToPositionY:(CGFloat)positionY;
- (void)removeCardFlyDisappearAnimationToPositionY;

- (POPPropertyAnimation *)addCardFlyDisappearAnimationToPositionX:(CGFloat)positionX;
- (void)removeCardFlyDisappearAnimationToPositionX;

- (POPPropertyAnimation *)addCardFlyRoateAnimationFromPositionY:(CGFloat)positionY angel:(CGFloat)angel;
- (void)removeCardFlyRoateAnimationFromPositionY;

- (POPPropertyAnimation *)addCardFlyLargeAnimationToPositionY:(CGFloat)positionY;
- (void)removeCardFlyLargeAnimationToPositionY;

- (POPPropertyAnimation *)addFlyAnimationToCenter:(CGPoint)center springSpeed:(CGFloat)springSpeed;
- (void)removeFlyAnimationToCenter;


@end
