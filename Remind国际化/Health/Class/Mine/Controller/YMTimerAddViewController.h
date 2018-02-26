//
//  YMTimerAddViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/24.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//  吃药和喝水

#import "BaseTableViewController.h"
#import "YMTimerRemindMode.h"

@interface YMTimerAddViewController : BaseTableViewController

@property (nonatomic, assign)TimerRemindType remindType;
@property (nonatomic, strong)YMTimerRemindMode *content;
@property (nonatomic, copy) NSString *navTitle;

@end
