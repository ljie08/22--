//
//  UIWindow+Additional.m
//  puhuibao
//
//  Created by ZZY on 15/4/29.
//  Copyright (c) 2015年 吕仁军. All rights reserved.
//

#import "UIWindow+Additional.h"

@implementation UIWindow (Additional)

/*!
 *  @brief  获取UIWindow
 *
 *  @return UIWindo
 */
+ (UIWindow*)GetMainWindow {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}

/*!
 *  @brief  屏幕截图并保存路径
 *
 *  @param path 路径
 *
 *  @return 是否成功
 */
+ (BOOL)CGA_takeScreenshotAndSaveToPath:(NSString *)path {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, NO, 0);
    [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    
    return [data writeToFile:path atomically:YES];
}


@end
