//
//  UITextField+Image.m
//  Guitar
//
//  Created by 金朗泰晟 on 17/3/6.
//  Copyright © 2017年 yarmy. All rights reserved.
//

#import "UITextField+Image.h"

@implementation UITextField (Image)

- (void)setLeftImageWithImageName:(NSString *)imgName{
    
    UIImage *image = [UIImage imageNamed:imgName];
    CGRect frame = CGRectZero;
    frame.size = image.size;
    frame.origin.x = 20;
    frame.size.width = image.size.width+10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeCenter;
    self.leftView = imgView;
//    [self  setLeftViewMode:UITextFieldViewModeAlways];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    
    
}
- (void)setRightImageWithImageName:(NSString *)imgName{

    UIImage *image = [UIImage imageNamed:imgName];
    CGRect frame = CGRectZero;
    frame.size = image.size;
    frame.origin.x = 10;
    frame.size.width = image.size.width+10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeCenter;
    self.rightView = imgView;
    [self  setRightViewMode:UITextFieldViewModeAlways];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}


@end
