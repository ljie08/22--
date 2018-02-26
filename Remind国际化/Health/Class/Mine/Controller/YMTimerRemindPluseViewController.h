//
//  YMTimerRemindPluseViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/29.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//  脉搏

#import "BaseTableViewController.h"
#import "YMTimerRemindMode.h"

@interface YMTimerRemindPluseViewController : BaseTableViewController

@property (nonatomic, assign)TimerRemindType remindType;
@property (nonatomic, strong)YMTimerRemindMode *content;
@property (nonatomic, copy) NSString *navTitle;

@end
