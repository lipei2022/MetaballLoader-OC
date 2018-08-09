//
//  MetaField.m
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import "MetaField.h"

static CGFloat rungKutaStep = 1.0;
static CGFloat fieldThreshold = 0.04;

@interface MetaField(){
    CGFloat currentForce;
}
@property (strong,nonatomic) CAShapeLayer *pathLayer;

@property (assign,nonatomic) CGFloat unitThreshold;

@property (assign,nonatomic) CGFloat minSizeBall;

@property (strong,nonatomic) NSMutableArray<MetaBall *> *metaBalls;
@end


@implementation MetaField

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), frame.size.width, frame.size.height);
    self = [super initWithFrame:rect];
    if (self) {
        self.unitThreshold = 0;
        self.minSizeBall = 1000;
        self.metaBalls = [NSMutableArray new];
        self.ballFillColor = [UIColor blackColor];
        //
        self.pathLayer = [CAShapeLayer layer];
        self.pathLayer.fillColor = self.ballFillColor.CGColor;
        self.pathLayer.frame = self.bounds;
        [self.layer addSublayer:self.pathLayer];
    }
    return self;
}
-(void)addMetaBall:(MetaBall *)metaBall{
    [self.metaBalls addObject:metaBall];
    [self updateMinSize];
    [self setNeedsDisplay];
}
-(void)updateMinSize{
    self.minSizeBall = 100000;
    for (MetaBall *metaBall in self.metaBalls) {
        if (metaBall.mess < self.minSizeBall) {
            self.minSizeBall = metaBall.mess;
        }
    }
}
-(CGPathRef)pathForCurrentConfiguration{
    CGMutablePathRef path = CGPathCreateMutable();
    for (MetaBall *metaBall in self.metaBalls) {
        metaBall.trackingPosition = [self trackTheBorder:GLKVector2Add(metaBall.centerPosition, GLKVector2Make(0, 1))];
        metaBall.borderPosition = metaBall.trackingPosition;
        
        metaBall.tracking = YES;
    }
    for (MetaBall *metaBall in self.metaBalls) {
        CGPathMoveToPoint(path, nil, metaBall.borderPosition.x, metaBall.borderPosition.y);
        for (NSInteger i = 0; i< 1000; i++) {
            if (!metaBall.tracking) {
                break;
            }
            // 存储旧的跟踪位置
            // 沿着切线走
            metaBall.trackingPosition = [self rungeKutta2:metaBall.trackingPosition h:rungKutaStep targetFunction:^GLKVector2(GLKVector2 position) {
                GLKVector2 tenant = [self tangentAt:position];
                return tenant;
            }];
            // 校正步向边界
            metaBall.trackingPosition = [self stepOnceTowardsBorder:metaBall.trackingPosition];
            CGPathAddLineToPoint(path, nil, metaBall.trackingPosition.x, metaBall.trackingPosition.y);
            // 检查我们是否走了一个完整的圆圈或击中了其他的边缘跟踪器
            for (MetaBall *otherBall in self.metaBalls) {
                if ((otherBall != metaBall || i > 3) && GLKVector2Distance(otherBall.borderPosition, metaBall.trackingPosition) < rungKutaStep) {
                    if (otherBall != metaBall) {
                        CGPathAddLineToPoint(path, nil, otherBall.borderPosition.x, otherBall.borderPosition.y);
                    }else{
                        CGPathCloseSubpath(path);
                    }
                    metaBall.tracking = NO;
                }
            }
        }
    }
    return path;
}
-(GLKVector2)tangentAt:(GLKVector2)position{
    GLKVector2 np = [self normalAt:position];
    return GLKVector2Make(-np.y, np.x);
}
-(GLKVector2)rungeKutta2:(GLKVector2)position
                       h:(CGFloat)h
          targetFunction:(GLKVector2(^)(GLKVector2 position))targetFunction{
    GLKVector2 oneTime = GLKVector2MultiplyScalar(targetFunction(position), h/2);
    GLKVector2 nextInput = GLKVector2Add(position, oneTime);
    GLKVector2 twoTime = GLKVector2MultiplyScalar(targetFunction(nextInput), h);
    return GLKVector2Add(position, twoTime);
}
-(GLKVector2)trackTheBorder:(GLKVector2)position{
    GLKVector2 position1 = position;
    // Track the border of the metaball and return new coordinates
    currentForce = 1000000;
    while (currentForce > fieldThreshold) {
        position1 = [self stepOnceTowardsBorder:position1];
        if(position1.x <= self.frame.size.width && position1.y <= self.frame.size.height){
            continue;
        }
    }
    return position1;
}
-(GLKVector2 )stepOnceTowardsBorder:(GLKVector2)position{
    CGFloat force = [self forceAt:position];
    GLKVector2 np = [self normalAt:position];
    
    CGFloat stepSize = pow(self.minSizeBall / fieldThreshold, 1 / DistanceConstant) - pow(self.minSizeBall / force, 1 / DistanceConstant) + 0.01;
    
    currentForce = force;
    return GLKVector2Add(position, GLKVector2MultiplyScalar(np, stepSize));
}
-(GLKVector2)normalAt:(GLKVector2)position{
    GLKVector2 totalNormal = GLKVector2Make(0, 0);
    for (MetaBall *metaBall in self.metaBalls) {
        CGFloat div = pow(GLKVector2Distance(metaBall.centerPosition, position), (2+DistanceConstant));
        GLKVector2 addition = GLKVector2MultiplyScalar(GLKVector2Subtract(metaBall.centerPosition, position), (-DistanceConstant * metaBall.mess)/div);
        totalNormal = GLKVector2Add(totalNormal, addition);
    }
    return GLKVector2Normalize(totalNormal);
}
-(CGFloat)forceAt:(GLKVector2)position{
    CGFloat totalForce = 0;
    for (MetaBall *metaBall in self.metaBalls) {
        totalForce += [metaBall forceAt:position];
    }
    return totalForce;
}
-(void)setBallFillColor:(UIColor *)ballFillColor{
    _ballFillColor = ballFillColor;
    self.pathLayer.fillColor = ballFillColor.CGColor;
}
-(void)setCurrentPath:(CGPathRef)currentPath{
    _currentPath = currentPath;
    self.pathLayer.path = currentPath;
}
-(void)setMinSizeBall:(CGFloat)minSizeBall{
    _minSizeBall = minSizeBall;
    self.unitThreshold = fieldThreshold/minSizeBall;
}
@end
