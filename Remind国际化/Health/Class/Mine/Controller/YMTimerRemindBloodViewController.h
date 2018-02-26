//
//  YMTimerRemindBloodViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/30.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//  测血糖

#import "BaseTableViewController.h"
#import "YMTimerRemindMode.h"

@interface YMTimerRemindBloodViewController : BaseTableViewController

@property (nonatomic, assign)TimerRemindType remindType;
@property (nonatomic, strong)YMTimerRemindMode *content;

@end
