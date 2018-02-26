//
//  SDEmptyTableView.h
//  SDEmptyDataSet
//
//  Created by ZZY on 16/4/10.
//  Copyright © 2016年 ZZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "EmptyDataSetType.h"

@interface SDEmptyTableView : UITableView

@property (nonatomic, getter = isLoading) BOOL loading;

/**
 *  展示EmptyData
 *
 *  @param emptyType 类型
 */
- (void)ShowEmptyDataSet:(EmptyDataSetType)emptyType;

/**
 *  展示EmptyData
 *
 *  @param emptyType 类型
 *  @param textLable 简介
 */
- (void)ShowEmptyDataSet:(EmptyDataSetType)emptyType WithTextLable:(NSString*)textLable;

/**
 *  删除EmptyData
 */
- (void)RemoveEmptyDataSet;

@end
