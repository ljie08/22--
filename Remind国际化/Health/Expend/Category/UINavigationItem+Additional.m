//
//  UIBarButtonItem+Additional.m
//  CloudPhoto
//
//  Created by ZZY on 15/6/11.
//  Copyright (c) 2015年 phb. All rights reserved.
//

#import "UINavigationItem+Additional.h"

@implementation UINavigationItem (Additional)

static const CGFloat  kUIBarButtonItemTitleDefaultFontSize = 14.0f;

/**
 *  添加UINavigationItem左侧（右侧）按钮
 *
 *  @param type   添加的位置
 *  @param title  标题
 *  @param image  背景图片
 *  @param target 事件监听的对象
 *  @param action 事件
 */
-(void)addButtonType:(enum XLAddCustomLeftOrRightButtonType)type withTitle:(NSString *)title withBackgroundImage:(UIImage *)image withTarget:(id)target withAction:(SEL)action{
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (image) {
        
        customBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [customBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (title.length > 0) {
        
        [customBtn setTitle:title forState:UIControlStateNormal];
        customBtn.titleLabel.font      = [UIFont systemFontOfSize:kUIBarButtonItemTitleDefaultFontSize];
        [customBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [customBtn sizeToFit];
        
    }
    
    if (target && action) {
        
        [customBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:customBtn];
    
    type == XLAddCustomLeftOrRightButtonTypeLeft?(self.leftBarButtonItem = barButtonItem):(self.rightBarButtonItem = barButtonItem);
}


@end
