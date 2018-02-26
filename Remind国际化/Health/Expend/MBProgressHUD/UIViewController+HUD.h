//
//  UIViewController+HUD.h
//
//  Created by Jamie Chapman on 12/02/2014.
//  Copyright (c) 2014 57Digital Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HUD_SECC @"请求成功"
#define HUD_ERR  @"网络异常!"

#define HUD_LOGIN_SECC @"登录成功!"

@class MBProgressHUD;

@interface UIViewController (HUD)

@property (nonatomic, strong) MBProgressHUD *hud;

#pragma mark - Show Options
- (void) showHudWithAutomatic:(NSString*)title; //Show ‘title’ 1s 消失
- (void) showHud; // Shows "加载中..." by default + animated
- (void) showHudAnimated:(BOOL)animated; // Shows "加载中..." by default, optional animation
- (void) showHudWithTitle:(NSString*)title; // Animated by default
- (void) showHudWithTitle:(NSString*)title animated:(BOOL)animated;
- (void) showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle; // Animated by default
- (void) showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle animated:(BOOL)animated;

#pragma mark - Hide Options

- (void) hideHud; // Animated by default
- (void) hideHudAnimated:(BOOL)animated;

@end
