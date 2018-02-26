//
//  HUDUtils.h
//  omayhr
//
//  Created by user on 13-8-12.
//  Copyright (c) 2013年 zhiduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define HUD_SECC @"请求成功"
#define HUD_ERR  @"网络异常!"

#define HUD_LOGIN_SECC @"登录成功!"



@interface HUDUtils : NSObject

+ (UIView *)showHUDTxt:(NSString *)txt;
+ (UIView *)showHUDToast:(NSString *)title;
+ (UIView *)showHUDProgress:(NSString *)title;
+ (void)dismiss;
+ (void)txtDismiss;
+ (NSString *)getErrorMessage:(NSString *)code;
@end
