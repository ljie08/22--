//
//  UIViewController+Additional.h
//  puhuibao
//
//  Created by ZZY on 15/8/24.
//  Copyright (c) 2015年 普惠宝科技. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ADD_TAG_BACKVIEW   66666666

typedef void(^executeFinishedBlock)(void);

typedef enum : NSUInteger {
    ShowContentBackViewTypeDefault,         //默认
    ShowContentBackViewTypeList,            //默认无数据
    ShowContentBackViewTypeJustTitle,       //只有文字
    ShowContentBackViewTypeRedPacket,       //红包
    ShowContentBackViewTypeInfo             //消息
} ShowContentBackViewType;


@interface UIViewController (Additional)


- (void)showContentView:(ShowContentBackViewType)contentBackType
               WithShow:(BOOL)isShow
             WithDetail:(NSString*)detail
         WithClickTitle:(NSString*)title
    WithExecuteFinished:(executeFinishedBlock)block;

- (void)showDefaultViewShow:(BOOL)isShow WithType:(ShowContentBackViewType)showType;

- (void)showDefaultViewShow:(BOOL)isShow WithDetail:(NSString*)detail;

- (void)showDefaultViewShow:(BOOL)isShow;

- (void)dismissViewShow;

@end
