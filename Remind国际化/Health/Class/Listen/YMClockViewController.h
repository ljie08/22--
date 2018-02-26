//
//  YMClockViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//  闹钟

#import "BaseTableViewController.h"
#import "YMTimerRemindMode.h"

@protocol  YMClockViewControllerDelegate<NSObject>

@optional
- (void)didSelectedClockTime:(NSString *)clockTime;

@end

@interface YMClockViewController : BaseTableViewController

@property (nonatomic, weak)id<YMClockViewControllerDelegate> delegate;
@property (nonatomic, assign)TimerRemindType remindType;
@property (nonatomic, strong)YMTimerRemindMode *content;

@end
