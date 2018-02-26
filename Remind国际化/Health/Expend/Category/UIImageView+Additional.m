//
//  UIImageView+Additional.m
//  JLMoney
//
//  Created by ZZY on 16/5/25.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "UIImageView+Additional.h"

@implementation UIImageView (Additional)


/*!
 *  @brief  显示图片
 *
 *  @param url 图片地址
 *  @param img 默认图片
 */
- (void)setImgWithURL:(NSURL*)url WithPlaceImage:(UIImage*)placeholder {
    
    
    if ([url.absoluteString isEqualToString:KBaseIDPicURL]) {
        
        url = nil;
    }
    
    
}


@end
