//
//  UITextView+Additions.h
//  JLMoney
//
//  Created by ZZY on 16/5/31.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Additions)

- (void)markAttributedText:(NSString*)text WithLineSpacing:(CGFloat)lineSpacing WithFoot:(UIFont*)foot;

@end
