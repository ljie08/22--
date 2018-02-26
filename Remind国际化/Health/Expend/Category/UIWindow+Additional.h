//
//  UIWindow+Additional.h
//  puhuibao
//
//  Created by ZZY on 15/4/29.
//  Copyright (c) 2015年 吕仁军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Additional)

/*!
 *  @brief  获取UIWindow
 *
 *  @return UIWindo
 */
+ (UIWindow*)GetMainWindow;

/*!
 *  @brief  屏幕截图并保存路径
 *
 *  @param path 路径
 *
 *  @return 是否成功
 */
+ (BOOL)CGA_takeScreenshotAndSaveToPath:(NSString *)path;

@end
