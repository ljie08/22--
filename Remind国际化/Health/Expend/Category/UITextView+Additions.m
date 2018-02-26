//
//  UITextView+Additions.m
//  JLMoney
//
//  Created by ZZY on 16/5/31.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "UITextView+Additions.h"

@implementation UITextView (Additions)



- (void)markAttributedText:(NSString*)text WithLineSpacing:(CGFloat)lineSpacing WithFoot:(UIFont*)foot{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:foot,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}



@end
