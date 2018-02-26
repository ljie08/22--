//
//  HMAlertView.h
//  HMAlertView
//
//  Created by Kevin Cao on 13-4-29.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMAlertImage.h"

extern NSString *const HMAlertViewWillShowNotification;
extern NSString *const HMAlertViewDidShowNotification;
extern NSString *const HMAlertViewWillDismissNotification;
extern NSString *const HMAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, HMAlertViewButtonType) {             //Button Type
    HMAlertViewButtonTypeDefault = 0,
    HMAlertViewButtonTypeDestructive,
    HMAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, HMAlertViewBackgroundStyle) {
    HMAlertViewBackgroundStyleGradient = 0,
    HMAlertViewBackgroundStyleSolid,
};

typedef NS_ENUM(NSInteger, HMAlertViewTransitionStyle) {
    HMAlertViewTransitionStyleSlideFromBottom = 0,
    HMAlertViewTransitionStyleSlideFromTop,
    HMAlertViewTransitionStyleFade,
    HMAlertViewTransitionStyleBounce,
    HMAlertViewTransitionStyleDropDown
};

@class HMAlertView;
typedef void(^HMAlertViewHandler)(HMAlertView *alertView);

@interface HMAlertView : UIView

@property (nonatomic, assign) BOOL isAutoDissmiss;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, assign) HMAlertViewTransitionStyle transitionStyle; // default is HMAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) HMAlertViewBackgroundStyle backgroundStyle; // default is HMAlertViewButtonTypeGradient

@property (nonatomic, copy) HMAlertViewHandler willShowHandler;
@property (nonatomic, copy) HMAlertViewHandler didShowHandler;
@property (nonatomic, copy) HMAlertViewHandler willDismissHandler;
@property (nonatomic, copy) HMAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont  *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont  *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont  *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0


@property (nonatomic, assign) BOOL isComment;   //标记是否是评论满足140个字的提示，因其黑背景会影响键盘收回
//title+message+确定按钮
- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(HMAlertViewButtonType)type handler:(HMAlertViewHandler)handler;

//图+message+确定按钮
- (instancetype)initWithImage:(NSString *)imageName andMessage:(NSString *)message;

- (void)dismissAnimated:(BOOL)animated;
- (void)show;

+ (HMAlertView *)currentAlertView;

@end
