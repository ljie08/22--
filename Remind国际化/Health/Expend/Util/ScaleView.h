//
//  ScaleView.h
//  Health
//
//  Created by 魔曦 on 2017/8/17.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleView : UIView

@property (nonatomic, strong)UIColor *bgColor;
@property (nonatomic, assign)CGFloat  roateAngel;

- (void)actionRotateAnimationClockwise:(BOOL)clockwise;
@end
