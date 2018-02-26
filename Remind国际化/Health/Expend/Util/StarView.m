//
//  StarView.m
//  Health
//
//  Created by 魔曦 on 2017/8/18.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "StarView.h"

#define kClockW   200
#define angle2radion(angle) ((angle) / 180.0 * M_PI)

//动画时长
static CGFloat animationDuration = 0.35f;
@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = CLEARCOLOR;
//        UIImageView *imgVIew =[[ UIImageView alloc] initWithImage:IMGNAME(@"star")];
//        imgVIew.origin = CGPointZero;
//        [self addSubview:imgVIew];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor{
    self.backgroundColor = bgColor;
}

- (void)setRoateAngel:(CGFloat)roateAngel{
    _roateAngel = roateAngel;
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor ;
    // 设置锚点
    layer.anchorPoint = CGPointMake(0.5, 1);
    layer.position = CGPointMake(SCREEN_WIDTH * 0.5, 280 * 0.5);
    layer.bounds = CGRectMake(0, 0, 4, SCREEN_WIDTH * 0.5 - 40);
    layer.cornerRadius = 120 + 20;
    [self.layer addSublayer:layer];
    
    self.layer.transform = CATransform3DMakeRotation(angle2radion(roateAngel), 0, 0, 1);
}

@end
