//
//  UILabel+Additions.h
//  FoodSays
//
//  Created by ZZY on 15/4/13.
//  Copyright (c) 2015年 czy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

/**
 *  设置UILable标签中指定文本的大小
 *
 *  @param sizeup 前面的字体
 *  @param sizedown  后面的字体
 */
-(void)setRangeOfString:(NSString *)string withSizeUp:(CGFloat )sizeup WithSizeDown:(CGFloat)sizedown;

/**
 *  设置UILable标签中指定文本的颜色
 *
 *  @param string 指定的文本
 *  @param color  设置的颜色
 */
-(void)setRangeOfString:(NSString *)string withColor:(UIColor *)color;

/*!
 *  @brief  添加删除线
 *
 *  @param color 删除线颜色
 */
- (void)setTrikethroughColor:(UIColor*)color;

/*!
 *  @brief  设置背景图片
 *
 *  @param backgroundImg 图片
 */
-(void)setBackgroundImage:(UIImage *)backgroundImg;

/*!
 *  @brief  获取内容的尺寸
 *
 *  @return CGSize
 */
- (CGSize)getContentSize;

@end
