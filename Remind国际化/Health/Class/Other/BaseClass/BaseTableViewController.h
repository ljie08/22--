//
//  BaseTableViewController.h
//  JLMoney
//
//  Created by ZZY on 16/5/23.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "DZXViewController.h"
#import "SDEmptyTableView.h"


@interface BaseTableViewController : DZXViewController
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SDEmptyTableView *tableView;

@property (nonatomic, assign) NSInteger      requestPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL           isTransparent;
@property (nonatomic, assign) BOOL           isHideNavigationBack;
@property (nonatomic, strong) UIImageView    *childrenView;


/**
 *  初始化
 *
 *  @param style TableView类型
 *
 *  @return self
 */
- (id)initWithStyle:(UITableViewStyle)style;

/**
 *  点击返回事件，如果有其他的处理方法，子类可以重写父类的方法
 */
- (void)navigationBackClick;


#pragma mark - 添加刷新

- (void)addHeadViewRefreshingAction:(void (^)())block;

- (void)addFooterViewRefreshingAction:(void (^)())block;


- (void)hideRefreshing;


@end
