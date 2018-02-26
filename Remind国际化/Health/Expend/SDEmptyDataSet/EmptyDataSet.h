//
//  EmptyDataSet.h
//  Applications
//
//  Created by ZZY on 16/4/8.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EmptyDataSetType.h"

@class EmptyDataSetTitle;
@class EmptyDataSetDetail;

@interface EmptyDataSet : NSObject

@property (nonatomic, strong) EmptyDataSetTitle *displayTitle;
@property (nonatomic, strong) EmptyDataSetDetail *displayDetail;
@property (nonatomic, strong) UIColor *displayBackColor;            //背景图片
@property (nonatomic, assign) CGFloat spaceHeight;                  //间隔
@property (nonatomic, assign) CGFloat verticalOffset;               //垂直激距离
@property (nonatomic, strong) NSString *iconName;

- (instancetype)initWithEmptyDataSetType:(EmptyDataSetType)type;

- (instancetype)initWithEmptyDataSetType:(EmptyDataSetType)type WithTitleText:(NSString*)titleText;

@end




@interface EmptyDataSetTitle : NSObject

@property (nonatomic, strong) NSString *TitleText;          //标题
@property (nonatomic, strong) UIFont   *TitleFont;          //字体
@property (nonatomic, strong) UIColor  *TitleTextColor;     //字体颜色

@end


@interface EmptyDataSetDetail : NSObject

@property (nonatomic, strong) NSString *DetailText;          //标题
@property (nonatomic, strong) UIFont   *DetailFont;          //字体
@property (nonatomic, strong) UIColor  *DetailTextColor;     //字体颜色
@property (nonatomic, assign) CGFloat  DetailLineSpacing;

@end