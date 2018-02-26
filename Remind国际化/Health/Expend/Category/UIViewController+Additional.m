//
//  UIViewController+Additional.m
//  puhuibao
//
//  Created by ZZY on 15/8/24.
//  Copyright (c) 2015年 普惠宝科技. All rights reserved.
//

#import "UIViewController+Additional.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "UILabel+Additions.h"


#define ADD_BACK_HEIGHT  200.0                          //背景高度
#define ADD_IMG_H_W      (IS_IPHONE_5_6?80.0:70.0)      //图片宽高
#define ADD_Default_H_W  (IS_IPHONE_5_6?120.0:100.0)

@implementation UIViewController (Additional)


#pragma mark - Public Method

- (void)showDefaultViewShow:(BOOL)isShow {
    
    [self showDefaultViewShow:isShow WithType:ShowContentBackViewTypeDefault];
    
}

- (void)showDefaultViewShow:(BOOL)isShow WithType:(ShowContentBackViewType)showType {
    
    [self showContentView:showType WithShow:isShow WithDetail:@"" WithClickTitle:@"" WithExecuteFinished:nil];
}


- (void)showDefaultViewShow:(BOOL)isShow WithDetail:(NSString*)detail {
    
    [self showContentView:ShowContentBackViewTypeList WithShow:isShow WithDetail:detail WithClickTitle:@"" WithExecuteFinished:nil];
}


- (void)dismissViewShow {
    
    UIView *backView = [self.view viewWithTag:ADD_TAG_BACKVIEW];
    
    if (backView) {
        [backView removeFromSuperview];
    }
}

#pragma mark - Private Method

- (void)showContentView:(ShowContentBackViewType)contentBackType
               WithShow:(BOOL)isShow
             WithDetail:(NSString*)detail
         WithClickTitle:(NSString*)title
    WithExecuteFinished:(executeFinishedBlock)block {
    
    if (isShow) {
        
        UIView *backView = [self.view viewWithTag:ADD_TAG_BACKVIEW];
        if (backView) {
            [backView removeFromSuperview];
        }
        
        switch (contentBackType) {
                
            case ShowContentBackViewTypeDefault:        //默认
            {
                backView = [self makeCustomBackViewWithImageName:@"contentview_Default" WithDetail:detail WithClickTitle:title WithExecuteFinished:block];
            }
                break;
            case ShowContentBackViewTypeList:           //默认无数据
            {
                backView = [self makeCustomBackViewWithImageName:@"contentview_List" WithDetail:detail WithClickTitle:title WithExecuteFinished:block];
            }
                break;
            case ShowContentBackViewTypeRedPacket:      //红包
            {
                backView = [self makeCustomBackViewWithImageName:@"contentview_Red" WithDetail:detail WithClickTitle:title WithExecuteFinished:block];
            }
                break;
            case ShowContentBackViewTypeInfo:           //信息
            {
                backView = [self makeCustomBackViewWithImageName:@"contentview_Info" WithDetail:detail WithClickTitle:title WithExecuteFinished:block];
            }
                break;
            case ShowContentBackViewTypeJustTitle:      //只有文字
            {
                backView = [self makeCustomBackViewWithImageName:@"" WithDetail:detail WithClickTitle:title WithExecuteFinished:block];
            }
                break;
                
            default:
                break;
        }
        
        [self.view addSubview:backView];
        
    }else {
        
        UIView *backView = [self.view viewWithTag:ADD_TAG_BACKVIEW];
        
        if (backView) {
            [backView removeFromSuperview];
        }
        
    }
}



/*!
 *  @brief  创建 BackView
 *
 *  @param ImageName 图片的名称
 *  @param detail    简介内容
 *  @param title     可点击内容
 *
 *  @return View
 */
- (UIView*)makeCustomBackViewWithImageName:(NSString*)ImageName
                                WithDetail:(NSString*)detail
                            WithClickTitle:(NSString*)title
                       WithExecuteFinished:(executeFinishedBlock)block {

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADD_BACK_HEIGHT)];
    [backView setCenter:CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
    [backView setTag:ADD_TAG_BACKVIEW];
    
    UIImageView *imgBack = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-ADD_IMG_H_W)/2.0, 0.0, ADD_IMG_H_W, ADD_IMG_H_W)];
    
    if ([ImageName isEqualToString:@"contentview_Default"]) {
        [imgBack setFrame:CGRectMake((SCREEN_WIDTH-ADD_Default_H_W)/2.0, 0.0, ADD_Default_H_W, ADD_Default_H_W)];
    }
    
    [imgBack setImage:[UIImage imageNamed:ImageName]];
    [backView addSubview:imgBack];
    
    WPHotspotLabel *Lab_FooterView = [[WPHotspotLabel alloc] initWithFrame:CGRectMake(0, ADD_IMG_H_W+10, SCREEN_WIDTH, ADD_BACK_HEIGHT-ADD_IMG_H_W-10)];
    [Lab_FooterView setBackgroundColor:[UIColor clearColor]];
    [Lab_FooterView setTextAlignment:NSTextAlignmentCenter];
    [Lab_FooterView setLineBreakMode:NSLineBreakByCharWrapping];
    [Lab_FooterView setNumberOfLines:3];
    [Lab_FooterView setTextColor:[UIColor add_colorWithRed255:210 green255:210 blue255:210]];
    
    NSDictionary* style3 = @{@"body":[UIFont boldSystemFontOfSize:14.0],
                             @"link1":[WPAttributedStyleAction styledActionWithAction:^{
                                 
                                 block();
                             }],
                             @"link": Color_Button};
    
    Lab_FooterView.attributedText = [detail attributedStringWithStyleBook:style3];
    
    [backView addSubview:Lab_FooterView];
    
    [Lab_FooterView setRangeOfString:title withSizeUp:16.0 WithSizeDown:18.0];
    [Lab_FooterView sizeToFit];
    [Lab_FooterView setFrame:CGRectMake((SCREEN_WIDTH-Lab_FooterView.size.width)/2.0, ADD_IMG_H_W+10, Lab_FooterView.size.width, Lab_FooterView.size.height)];
    
    return backView;
}



@end
