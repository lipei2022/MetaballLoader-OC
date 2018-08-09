//
//  MetaSpin.m
//  UEToken
//
//  Created by sulink on 2018/8/3.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import "MetaSpin.h"

@interface MetaSpin(){
    CGFloat _speed;
    CGFloat currentAngle;
    CGFloat maxAngle;
    BOOL flip;
    NSMutableDictionary *pathPool;
}


@property (assign,nonatomic) CGFloat cruiseRadius;


@property (strong,nonatomic) MetaBall *centralBall;
@property (strong,nonatomic) MetaBall *sideBall;
@property (strong,nonatomic) MetaBall *sideBall2;
@property (strong,nonatomic) MetaBall *sideBall3;
@property (strong,nonatomic) MetaField *metaField;
@end

@implementation MetaSpin

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.centralBallRadius = 50;
        self.sideBallRadius = 10;
        self.cruiseRadius = 20;
        self.ballFillColor = [UIColor whiteColor];
        _speed = 0.009;
        currentAngle = 0;
        maxAngle = 2.0*M_PI;
        flip = NO;
        pathPool = [NSMutableDictionary new];
        //
        
        //
        self.backgroundColor = [UIColor clearColor];
        self.metaField = [[MetaField alloc]initWithFrame:frame];
        _metaField.backgroundColor = [UIColor clearColor];
        
        [self addCentralBall];
        [self addSideBall];
        
        [self addSubview:self.metaField];
    }
    return self;
}
-(void)addCentralBall{
    self.centralBall = [[MetaBall alloc]initWithCenter:self.center radius:self.centralBallRadius];
    [self.metaField addMetaBall:self.centralBall];
}
-(void)addSideBall{
    self.sideBall = [[MetaBall alloc]initWithCenter:CGPointMake(self.center.x, self.center.y) radius:self.sideBallRadius];
    [self.metaField addMetaBall:self.sideBall];
    
}
-(void)animateSideBall{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveSideBall)];
    [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];

}
-(void)moveSideBall{
    [self nextAngle];
    CGFloat adjustedAngle = [self toEaseIn:[self toEaseIn:currentAngle]];
    
    self.sideBall.centerPosition = [self newCenter:adjustedAngle relatedToCenter:self.centralBall.centerPosition];
    CGFloat centerIndex = self.sideBall.centerPosition.x * self.sideBall.centerPosition.y;
    // We'll store the path and reuse it
    if (pathPool[@(centerIndex).stringValue] == nil) {
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        CGPathRef path = [self.metaField pathForCurrentConfiguration];
        bezier.CGPath = path;
        [pathPool setObject:bezier forKey:@(centerIndex).stringValue];
    }
    UIBezierPath *bezier = pathPool[@(centerIndex).stringValue];
    self.metaField.currentPath = bezier.CGPath;
    [self.metaField setNeedsDisplay];
    
}
-(GLKVector2)newCenter:(CGFloat)angle relatedToCenter:(GLKVector2)center{
    CGFloat x = center.x + self.cruiseRadius*(flip?-sin(angle):sin(angle));
    CGFloat y = center.y + (flip?self.cruiseRadius:-self.cruiseRadius) + self.cruiseRadius*(flip?-cos(angle):cos(angle));
    return GLKVector2Make(x, y);
}
-(void)nextAngle{
    if (currentAngle >= maxAngle) {
        currentAngle = 0;
        flip = !flip;
    }else{
        currentAngle += maxAngle *_speed;
    }
}
-(CGFloat)toEaseIn:(CGFloat)angle{
    CGFloat ratio = angle / (2*M_PI);
    CGFloat processed_ratio = ratio;
    if (ratio < 0.5) {
        processed_ratio = (1 - pow(1 - ratio, 3.0))*8 / 14;
    }else{
        processed_ratio = 1 - (1 - pow(ratio, 3.0))*8/14;
    }
    return processed_ratio * (2*M_PI);
}
#pragma mark - setter
-(void)setCentralBallRadius:(CGFloat)centralBallRadius{
    _centralBallRadius = centralBallRadius;
    self.centralBall.radius = centralBallRadius;
    self.cruiseRadius = (centralBallRadius + self.sideBallRadius)/2*1.3;
}
-(void)setSideBallRadius:(CGFloat)sideBallRadius{
    _sideBallRadius = sideBallRadius;
    self.sideBall.radius = sideBallRadius;
    self.cruiseRadius = (self.centralBallRadius+sideBallRadius)/2*1.3;
}
-(void)setBallFillColor:(UIColor *)ballFillColor{
    _ballFillColor = ballFillColor;
    self.metaField.ballFillColor = ballFillColor;
}
@end
