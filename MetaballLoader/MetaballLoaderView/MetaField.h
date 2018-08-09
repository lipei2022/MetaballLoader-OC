//
//  MetaField.h
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaBall.h"

@interface MetaField : UIView

@property (strong,nonatomic) UIColor *ballFillColor;
@property (assign,nonatomic) CGPathRef currentPath;

-(void)addMetaBall:(MetaBall *)metaBall;
-(CGPathRef)pathForCurrentConfiguration;
@end
