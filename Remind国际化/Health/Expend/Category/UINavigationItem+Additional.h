//
//  UIBarButtonItem+Additional.h
//  CloudPhoto
//
//  Created by ZZY on 15/6/11.
//  Copyright (c) 2015年 phb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Additional)

/**
 *  添加按钮的位置
 */
typedef NS_ENUM(NSInteger, XLAddCustomLeftOrRightButtonType){
    /**
     *  左侧
     */
    XLAddCustomLeftOrRightButtonTypeLeft  = 0,
    /**
     *  右侧
     */
    XLAddCustomLeftOrRightButtonTypeRight,
};

/**
 *  添加UINavigationItem左侧（右侧）按钮
 *
 *  @param type   添加的位置
 *  @param title  标题
 *  @param image  背景图片
 *  @param target 事件监听的对象
 *  @param action 事件
 */
-(void)addButtonType:(enum XLAddCustomLeftOrRightButtonType)type withTitle:(NSString *)title withBackgroundImage:(UIImage *)image withTarget:(id)target withAction:(SEL)action;

@end
