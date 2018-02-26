//
//  SDEmptyTableView.m
//  SDEmptyDataSet
//
//  Created by ZZY on 16/4/10.
//  Copyright © 2016年 ZZY. All rights reserved.
//

#import "SDEmptyTableView.h"
#import "EmptyDataSetType.h"
#import "EmptyDataSet.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBConvertColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

#define RGBAConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

@interface SDEmptyTableView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, setter = setEmptyDataSetType:) EmptyDataSetType emptyDataSetType;
@property (nonatomic, strong) EmptyDataSet     *emptyDataSet;

@end


@implementation SDEmptyTableView
@synthesize emptyDataSetType = _emptyDataSetType;
@synthesize emptyDataSet = _emptyDataSet;
@synthesize loading = _loading;



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
    }
    return self;
}


#pragma mark - Public Method

/**
 *  展示EmptyData
 *
 *  @param emptyType 类型
 *  @param textLable 简介
 */
- (void)ShowEmptyDataSet:(EmptyDataSetType)emptyType WithTextLable:(NSString*)textLable {
    
    if (emptyType == EmptyDataSetTypeLoading) {
        
        _loading = YES;
    }else {
        _loading = NO;
    }
    
    self.emptyDataSetType = emptyType;
    
    self.emptyDataSet = [[EmptyDataSet alloc] initWithEmptyDataSetType:self.emptyDataSetType WithTitleText:textLable];
    
    [self reloadEmptyDataSet];


}

/**
 *  展示EmptyData
 *
 *  @param emptyType 类型
 */
- (void)ShowEmptyDataSet:(EmptyDataSetType)emptyType {
    
    if (emptyType == EmptyDataSetTypeLoading) {
        
        _loading = YES;
    }else {
        _loading = NO;
    }
    
    self.emptyDataSetType = emptyType;
    
    self.emptyDataSet = [[EmptyDataSet alloc] initWithEmptyDataSetType:self.emptyDataSetType];
    
    [self reloadEmptyDataSet];
}


- (void)RemoveEmptyDataSet {
    
    _loading = NO;
    
    self.emptyDataSetType = EmptyDataSetTypeUndefined;
    
    self.emptyDataSet = [[EmptyDataSet alloc] initWithEmptyDataSetType:self.emptyDataSetType];
    
    [self reloadEmptyDataSet];
}



#pragma mark - SET

- (void)setEmptyDataSetType:(EmptyDataSetType)emptyDataSetType {

    if (emptyDataSetType != _emptyDataSetType) {
        _emptyDataSetType = emptyDataSetType;
    }
    
}


- (void)setEmptyDataSet:(EmptyDataSet *)emptyDataSet {
    
    if (emptyDataSet != _emptyDataSet) {
        _emptyDataSet = emptyDataSet;
    }
    
}


- (void)setLoading:(BOOL)loading {
    
    if (_loading != loading) {
        _loading = loading;
        
        [self reloadEmptyDataSet];
    }
}

#pragma mark - GET

- (EmptyDataSetType)emptyDataSetType {
    
    return _emptyDataSetType;
}


- (EmptyDataSet*)emptyDataSet {
    
    return _emptyDataSet;
}

- (BOOL)isLoading {
    
    return _loading;
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text     = self.emptyDataSet.displayTitle.TitleText;
    UIFont *font       = self.emptyDataSet.displayTitle.TitleFont;
    UIColor *textColor = self.emptyDataSet.displayTitle.TitleTextColor;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    if (!text) {
        return nil; 
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.emptyDataSet.displayDetail.DetailText;
    UIFont *font = self.emptyDataSet.displayDetail.DetailFont;
    UIColor *textColor = self.emptyDataSet.displayDetail.DetailTextColor;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    paragraph.lineSpacing = self.emptyDataSet.displayDetail.DetailLineSpacing;
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
//    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0X00adf1) range:[attributedString.string rangeOfString:@"add favorites"]];
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }else {
        return [UIImage imageNamed:self.emptyDataSet.iconName];
    }
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = [[NSString stringWithFormat:@"button_background_%@",@""] lowercaseString];
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyDataSet.displayBackColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyDataSet.verticalOffset;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyDataSet.spaceHeight;

}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.loading = YES;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
}




@end
