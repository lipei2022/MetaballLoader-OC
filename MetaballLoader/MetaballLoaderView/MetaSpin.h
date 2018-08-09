//
//  MetaSpin.h
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaField.h"

@interface MetaSpin : UIView
@property (strong,nonatomic) UIColor *ballFillColor;
@property (assign,nonatomic) CGFloat centralBallRadius;

@property (assign,nonatomic) CGFloat sideBallRadius;

-(void)animateSideBall;
@end
