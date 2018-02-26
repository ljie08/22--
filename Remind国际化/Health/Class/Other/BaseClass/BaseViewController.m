//
//  BaseViewController.m
//  JLMoney
//
//  Created by ZZY on 16/5/23.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "BaseViewController.h"

static const int  NavicationViewControllersCount = 1;

@interface BaseViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    if (self.navigationController.viewControllers.count != NavicationViewControllersCount && !self.isHideNavigationBack) {//不是顶级试图
        
        DZXBarButtonItem *backItem = [DZXBarButtonItem buttonWithImageNormal:[UIImage imageNamed:@"ic_back_nor"]
                                                               imageSelected:[UIImage imageNamed:@"ic_back_nor"]];
        [backItem addTarget:self action:@selector(navigationBackClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationLeftButton = backItem;
    }
    
    
}


#pragma mark - Public Method

/**
 *  点击返回按钮调用(可在子类中重写)
 */
- (void)navigationBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
