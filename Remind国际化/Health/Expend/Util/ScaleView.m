//
//  ScaleView.m
//  Health
//
//  Created by 魔曦 on 2017/8/17.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "ScaleView.h"

#define kClockW   200
#define angle2radion(angle) ((angle) / 180.0 * M_PI)

//动画时长
static CGFloat animationDuration = 0.35f;
@implementation ScaleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 1;
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor{
    self.backgroundColor = bgColor;
}

- (void)setRoateAngel:(CGFloat)roateAngel{
    _roateAngel = roateAngel;
//    CALayer * layer = [CALayer layer];
//    layer.backgroundColor = [UIColor blackColor].CGColor ; // 设置锚点 layer.anchorPoint = CGPointMake(0.5, 1);
//    layer.position = CGPointMake(kClockW * 0.5, kClockW * 0.5);
//    layer.bounds = CGRectMake(0, 0, 4, kClockW * 0.5 - 40);
//    layer.cornerRadius = 4;
//    [self.layer addSublayer:layer];
   
    self.layer.transform = CATransform3DMakeRotation(angle2radion(roateAngel), 0, 0, 1);
}

/**
 执行旋转动画
 */
- (void)actionRotateAnimationClockwise:(BOOL)clockwise {

    //逆时针旋转
    CGFloat startAngle = M_PI + angle2radion(self.roateAngel);
    CGFloat endAngle = angle2radion(self.roateAngel);
    CGFloat duration = 0.75 * animationDuration;
    //顺时针旋转
    if (clockwise) {
        startAngle = angle2radion(self.roateAngel);
        endAngle = angle2radion(self.roateAngel) + M_PI;
        duration = animationDuration;
    }
    CABasicAnimation *roateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    roateAnimation.duration = duration; // 持续时间
    roateAnimation.fromValue = [NSNumber numberWithFloat:startAngle];
    roateAnimation.toValue = [NSNumber numberWithFloat:endAngle];
    roateAnimation.fillMode = kCAFillModeForwards;
    roateAnimation.removedOnCompletion = NO;
    [roateAnimation setValue:@"roateAnimation" forKey:@"animationName"];
    [self.layer addAnimation:roateAnimation forKey:nil];
    
}


@end
