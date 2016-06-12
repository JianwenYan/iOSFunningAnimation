//
//  PayViewController.h
//  StarbucksCreditCardInteractionDemo
//
//  Created by 颜建文 on 16/5/28.
//  Copyright © 2016年 颜建文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface PayViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starbucksCardImageView;
@property (weak, nonatomic) IBOutlet iCarousel *payCardCarousel;

@end
