//
//  BaseTableViewController.m
//  JLMoney
//
//  Created by ZZY on 16/5/23.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "BaseTableViewController.h"
#import "EmptyDataSetType.h"
#import "EmptyDataSet.h"

@interface BaseTableViewController ()
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, setter = setEmptyDataSetType:) EmptyDataSetType emptyDataSetType;
@property (nonatomic, strong) EmptyDataSet     *emptyDataSet;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end

@implementation BaseTableViewController


/**
 *  初始化
 *
 *  @param style TableView类型
 *
 *  @return self
 */
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed  = YES;
        self.tableViewStyle = style;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.navigationController.viewControllers.count != 1 && !self.isHideNavigationBack) {//不是顶级试图
        
        DZXBarButtonItem *backItem = [DZXBarButtonItem buttonWithImageNormal:[UIImage imageNamed:@"ic_back_nor"]
                                                               imageSelected:[UIImage imageNamed:@"navi_back"]];
        [backItem addTarget:self action:@selector(navigationBackClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationLeftButton = backItem;
    }
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, self.view.height)];
    [bgImgView setImage:[UIImage imageNamed:@"bg"]];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    self.childrenView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, SCREEN_WIDTH, self.view.height-64)];
    self.childrenView.backgroundColor = CLEARCOLOR;
    self.childrenView.userInteractionEnabled = YES;
//    [_childrenView setImage:[UIImage imageNamed:@"bg"]];
    [self.view insertSubview:_childrenView belowSubview:self.navigationView];
    
    //自定义TableView
    //==========================================================================================//
    
    CGRect tabRect = CGRectMake(0.0, self.navigationView.bottom, SCREEN_WIDTH, self.view.height-self.navigationView.bottom);
    if (self.isTransparent) {        //透明的
        tabRect = CGRectMake(0.0, 0.0, SCREEN_WIDTH, self.view.height);
    }
    
    if ((self.tabBarController !=nil) && !self.tabBarController.tabBar.hidden) {
        
        tabRect.size.height = tabRect.size.height - self.tabBarController.tabBar.frame.size.height;
    }
    
    self.tableView = [[SDEmptyTableView alloc] initWithFrame:tabRect style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self setExtraCellLineHidden];
    
    self.tableView.separatorColor = [UIColor add_colorWithRGBHexString:@"eae9e9"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    
    self.requestPage = 0;
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method

/**
 *  点击返回按钮调用(可在子类中重写)
 */
- (void)navigationBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 *  @brief  设置标志隐藏
 *
 *  @param show 是否显示
 */
- (void)showMark:(BOOL)show  WithTitle:(NSString*)title{
    
    [self showDefaultViewShow:!show];
    
}

/**
 *  @author 15-03-20
 *
 *  去除多余表格线
 *
 */
-(void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
