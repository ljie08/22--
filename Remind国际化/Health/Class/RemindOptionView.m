//
//  RemindOptionView.m
//  Health
//
//  Created by 魔曦 on 2017/8/16.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "RemindOptionView.h"

@interface RemindOptionView()

@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imgArr;
@end

@implementation RemindOptionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *view=[[UIView alloc] initWithFrame:frame];
        view.backgroundColor=[UIColor blackColor];
        view.layer.opacity=0.8;
        [self addSubview:view];
        
        
        self.titleArr = [NSArray arrayWithObjects:LOCALIZED(@"吃药"),LOCALIZED(@"测血糖"),LOCALIZED(@"测脉搏"),LOCALIZED(@"复查"),LOCALIZED(@"理疗"),LOCALIZED(@"喝水"),LOCALIZED(@"运动"),LOCALIZED(@"睡眠"), nil];
        self.imgArr = [NSArray arrayWithObjects:@"timer_drug",@"timer_blood",@"timer_pulse",@"check",@"cure",@"drink",@"timer_run",@"timer_sleep", nil];
        [self headerView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)headerView{
    
    if (!_headerView) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH , SCREEN_WIDTH)];
        view.centerY = SCREEN_HEIGHT /2.0;
        view.centerX = SCREEN_WIDTH / 2.0;
        view.backgroundColor=CLEARCOLOR;//[[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self addSubview:view];
        
        //[UIColor colorWithRed:69 green:113 blue:161 alpha:0.5]
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH + 10)];
        _headerView.centerY = SCREEN_HEIGHT /2.0;
        _headerView.centerX = SCREEN_WIDTH / 2.0;
        _headerView.backgroundColor = CLEARCOLOR;//[[Tools hexStringToColor:@"183b7b"] colorWithAlphaComponent:0.5];
        [self addSubview:_headerView];
        _headerView.layer.cornerRadius = 10;
        _headerView.layer.masksToBounds = YES;
        CGFloat width = 75;
        CGFloat height = _headerView.height/3.0;
        CGPoint center = CGPointMake(SCREEN_WIDTH/2.0 + 35, _headerView.height/2.0);
        CGFloat radius = _headerView.width/3.0;
        CGFloat sAngel = - M_PI_2;

        for (NSInteger i = 0; i < 8; i++) {
            
            UIImage *img = IMGNAME(self.imgArr[i]);
            
            NSInteger l = 1;//(i<= 6 && i >= 0) ? 1 : -1;
            NSInteger m = (i<= 7 && i >= 0) ? 1 : 0;
    
            CGFloat originX = center.x + (radius * cos(sAngel) + width * m * (-1))*l;
            CGFloat originY = center.y + (radius * sin(sAngel) + width * m  * (-1))*l;
            
            CGPoint orign = CGPointMake(originX,originY);
            
            sAngel += M_PI * 2/8.0 ;
            
            CGRect frame = CGRectMake(0, 0,width,width);
            frame.origin = orign;
            UIView *bgView = [[UIView alloc] initWithFrame:frame];
            bgView.backgroundColor = CLEARCOLOR;
            bgView.tag = 101 + i;
//            bgView.layer.cornerRadius = width/2.0;
            bgView.layer.masksToBounds = YES;
            [_headerView addSubview:bgView];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:IMGNAME(self.imgArr[i])];
            imgView.top = (width - img.size.height - 15)/2.0;
            imgView.centerX = width/2.0;
            imgView.userInteractionEnabled = YES;
            [bgView addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 2, width, 15)];
            label.centerX = width/2.0;
            label.bottom = width - 15;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = CLEARCOLOR;
            label.font = FONTSIZE(12);
            label.text = self.titleArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled= YES;
            [bgView addSubview:label];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            tap.cancelsTouchesInView = NO;
            [bgView addGestureRecognizer:tap];
            
        }
        
        
    }
    return _headerView;
}

//- (UIView *)headerView{
//    
//    if (!_headerView) {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - 60 , 180 * 1.5)];
//        view.centerY = SCREEN_HEIGHT /2.0;
//        view.centerX = SCREEN_WIDTH / 2.0;
//        view.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
//        [self addSubview:view];
//        
//        //[UIColor colorWithRed:69 green:113 blue:161 alpha:0.5]
//        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - 60 , 180 * 1.5)];
//        _headerView.centerY = SCREEN_HEIGHT /2.0;
//        _headerView.centerX = SCREEN_WIDTH / 2.0;
//        _headerView.backgroundColor = [[Tools hexStringToColor:@"183b7b"] colorWithAlphaComponent:0.5];
//        [self addSubview:_headerView];
//        _headerView.layer.cornerRadius = 10;
//        _headerView.layer.masksToBounds = YES;
//        CGFloat width = (SCREEN_WIDTH - 60)/3.0;
//        CGFloat height = _headerView.height/3.0;
//        for (NSInteger i = 0; i < 8; i++) {
//            UIImage *img = IMGNAME(self.imgArr[i]);
//            CGRect frame = CGRectMake( width * (i%3), height * (i/3),width,height);
//            UIView *bgView = [[UIView alloc] initWithFrame:frame];
//            bgView.backgroundColor = CLEARCOLOR;
//            bgView.tag = 101 + i;
//            [_headerView addSubview:bgView];
//            
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:IMGNAME(self.imgArr[i])];
//            imgView.top = (height - img.size.height - 15)/2.0;
//            imgView.centerX = width/2.0;
//            imgView.userInteractionEnabled = YES;
//            [bgView addSubview:imgView];
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 2, width, 15)];
//            label.centerX = width/2.0;
//            label.bottom = height - 15;
//            label.textColor = [UIColor whiteColor];
//            label.backgroundColor = CLEARCOLOR;
//            label.font = FONTSIZE(14);
//            label.text = self.titleArr[i];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.userInteractionEnabled= YES;
//            [bgView addSubview:label];
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
//            tap.cancelsTouchesInView = NO;
//            [bgView addGestureRecognizer:tap];
//            
//        }
//        
//        
//    }
//    return _headerView;
//}

- (void)tapView:(UIGestureRecognizer *)tap{

    UIView *view = tap.view;
//    view.backgroundColor = [Tools hexStringToColor:@"4571a1"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectecRemindType:)]) {
        [self.delegate didSelectecRemindType:view.tag - 100];
    }
    
    [self hideWithAnimate:YES];
}

- (void)hide{
    [self hideWithAnimate:YES];
}

- (void)showWithAnimate:(BOOL)animate{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (animate) {
        
        [self showAnimateBeginAlpha:0.0 endAlpha:1.0];
    }
}

- (void)hideWithAnimate:(BOOL)animate{
    
    if (animate) {
        
        [self showAnimateBeginAlpha:1.0 endAlpha:0.0];
    }
    [self removeFromSuperview];
}

- (void)showAnimateBeginAlpha:(CGFloat)beginAlpha  endAlpha:(CGFloat)endAlpha{
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.1;
    theAnimation.fromValue=[NSNumber numberWithFloat:beginAlpha];
    theAnimation.toValue=[NSNumber numberWithFloat:endAlpha];
    [self.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
}


@end
