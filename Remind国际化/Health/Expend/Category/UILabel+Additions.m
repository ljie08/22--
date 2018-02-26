//
//  UILabel+Additions.m
//  FoodSays
//
//  Created by ZZY on 15/4/13.
//  Copyright (c) 2015年 czy. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)



/**
 *  设置UILable标签中指定文本的颜色
 *
 *  @param string 指定的文本
 *  @param color  设置的颜色
 */
- (void)setRangeOfString:(NSString *)string withColor:(UIColor *)color{
    
    NSRange range = [self.text rangeOfString:string];
    
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        [attributedText addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        [self setAttributedText:attributedText];
    }
}


//Arial-BoldItalicMT
/**
 *  设置UILable标签中指定文本的大小
 *
 *  @param sizeup 前面的字体
 *  @param sizedown  后面的字体
 */
- (void)setRangeOfString:(NSString *)string withSizeUp:(CGFloat )sizeup WithSizeDown:(CGFloat)sizedown{
    
    NSRange range = [self.text rangeOfString:string];
    
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiTC-Light" size:sizeup] range:NSMakeRange(0, range.location)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiTC-Light" size:sizedown] range:NSMakeRange(range.location, string.length)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiTC-Light" size:sizedown] range:NSMakeRange(range.location+string.length, self.text.length-(range.location+string.length))];
        
        [self setAttributedText:attributedText];
    }
    
}

/*!
 *  @brief  添加删除线
 *
 *  @param color 删除线颜色
 */
- (void)setTrikethroughColor:(UIColor*)color{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color?:[UIColor lightGrayColor] range:NSMakeRange(0, self.text.length)];
    [self setAttributedText:attri];
    
}


/*!
 *  @brief  设置背景图片
 *
 *  @param backgroundImg 图片
 */
- (void)setBackgroundImage:(UIImage *)backgroundImg {
    
    UIColor *color = [UIColor colorWithPatternImage:backgroundImg];
    self.backgroundColor = color;
}


/*!
 *  @brief  获取内容的尺寸
 *
 *  @return CGSize
 */
- (CGSize)getContentSize {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_0
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary *attributes = @{ NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle };
    
    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
#else
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
    // 获取该段attributedString的属性字典
    // 计算文本的大小
    CGSize textSize = [attrStr boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size; // context上下文。包括一些信息，例如如何调整
    
    return textSize;
#endif
    
}




@end
