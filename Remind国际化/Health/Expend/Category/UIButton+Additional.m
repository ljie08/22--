//
//  UIButton+Additional.m
//  JLMoney
//
//  Created by ZZY on 16/5/27.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "UIButton+Additional.h"

@implementation UIButton (Additional)

- (void)setFont:(UIFont *)font {
    
    self.titleLabel.font = font;
    
}


+ (UIButton*)makeCustomBtn:(CGRect)rect WithTitle:(NSString*)title {
    
    return [UIButton makeCustomBtn:rect WithTitle:title WithBackgroundColor:COLOR_002];
}


+ (UIButton*)makeCustomBtn:(CGRect)rect
                 WithTitle:(NSString*)title
       WithBackgroundColor:(UIColor*)backColor {
    
    UIButton *unifyBtn = [[UIButton alloc] initWithFrame:rect];
    
    UIImage *backInmg = [[UIImage imageNamed:@"Other_002"] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    [unifyBtn setBackgroundImage:backInmg forState:UIControlStateNormal];
    
    [unifyBtn setBackgroundImage:[[UIImage imageNamed:@"other_009"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateDisabled];
    [unifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [unifyBtn setTitleColor:COLOR_001 forState:UIControlStateNormal];
    [unifyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [unifyBtn setTitle:title forState:UIControlStateNormal];
    [unifyBtn setCornerRadius:5.0f WithBoraderWidth:0.0 WithBoraderColor:nil];
  
    return unifyBtn;
}





@end
