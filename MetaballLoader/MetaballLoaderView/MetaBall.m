//
//  MetaBall.m
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import "MetaBall.h"

@interface MetaBall()


@end

@implementation MetaBall
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderPosition = GLKVector2Make(0, 0);
        self.trackingPosition = GLKVector2Make(0, 0);
        self.tracking = NO;
    }
    return self;
}
-(instancetype)initWithCenterVector:(GLKVector2)centerVector radius:(CGFloat)radius{
    self = [super init];
    if (self) {
        self.centerPosition = centerVector;
        self.radius = radius;
        self.mess = radius;// ForceConstant * CGFloat(M_PI) * radius * radius
    }
    return self;
}
-(instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius{
    GLKVector2 tempCenter = GLKVector2Make(center.x, center.y);
    self = [self initWithCenterVector:tempCenter radius:radius];

    return self;
}
-(CGFloat)forceAt:(GLKVector2)position{
    CGFloat dis = [self distanceFromPoint:self.centerPosition toPoint:position];
    CGFloat div = dis*dis;
    return div == 0 ? MaximumForce:(self.mess/div);
}
-(CGFloat)distanceFromPoint:(GLKVector2)fromPoint toPoint:(GLKVector2)toPoint{
    return GLKVector2Distance(fromPoint, toPoint);
}
-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.mess = radius;
}

@end
