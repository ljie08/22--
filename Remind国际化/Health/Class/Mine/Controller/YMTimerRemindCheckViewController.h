//
//  YMTimerRemindCheckViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/4/1.
//  Copyright © 2017年 PerfectBao. All rights reserved.
// 复查

#import "BaseTableViewController.h"
#import "YMTimerRemindMode.h"

@interface YMTimerRemindCheckViewController : BaseTableViewController

@property (nonatomic, assign)TimerRemindType remindType;
@property (nonatomic, strong)YMTimerRemindMode *content;

@end
