//
//  BaseViewController.h
//  JLMoney
//
//  Created by ZZY on 16/5/23.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "DZXViewController.h"

@interface BaseViewController : DZXViewController

@property (nonatomic, assign) NSInteger requestPage;

@property (nonatomic, assign) BOOL      isHideNavigationBack;
@property (nonatomic, strong) UIImageView    *childrenView;

/**
 *  点击返回事件，如果有其他的处理方法，子类可以重写此方法
 */
- (void)navigationBackClick;

#pragma mark - 添加刷新

- (void)addRefreshingHeadView:(UITableView*)tableView refreshingAction:(void (^)())block;

- (void)addRefreshingFooterView:(UITableView *)tableView refreshingAction:(void (^)())block;

- (void)hideRefreshing;

@end
