//
//  MetaBall.h
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

static CGFloat ForceConstant = 6.67384;
static CGFloat DistanceConstant = 2.0;
static CGFloat MaximumForce = 10000;

@interface MetaBall : NSObject
@property (assign,nonatomic) CGFloat radius;
@property (assign,nonatomic) CGFloat mess;
@property (assign,nonatomic) GLKVector2 borderPosition;
@property (assign,nonatomic) GLKVector2 trackingPosition;

@property (assign,nonatomic) GLKVector2 centerPosition;
@property (assign,nonatomic) BOOL tracking;


-(instancetype)initWithCenterVector:(GLKVector2)centerVector radius:(CGFloat)radius;

-(instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius;

-(CGFloat)forceAt:(GLKVector2)position;
@end
