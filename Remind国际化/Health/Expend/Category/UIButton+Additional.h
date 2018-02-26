//
//  UIButton+Additional.h
//  JLMoney
//
//  Created by ZZY on 16/5/27.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additional)

- (void)setFont:(UIFont *)font;


+ (UIButton*)makeCustomBtn:(CGRect)rect WithTitle:(NSString*)title;


+ (UIButton*)makeCustomBtn:(CGRect)rect
                 WithTitle:(NSString*)title
       WithBackgroundColor:(UIColor*)backColor;

@end
