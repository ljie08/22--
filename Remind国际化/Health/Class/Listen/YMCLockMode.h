//
//  YMCLockMode.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/31.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "BaseJsonMode.h"

@interface YMCLockMode : NSObject

@property (nonatomic, strong) YMCLockMode *result;

@property (nonatomic, strong) NSString *remindBellId;//闹铃ID
@property (nonatomic, strong) NSString *remindTime;//提醒的时间
@property (nonatomic, assign) BOOL     isOpenShake;//震动
@property (nonatomic, assign) BOOL     isOpenClock;//闹钟开关
@property (nonatomic, assign) BOOL     isOpenWeek;//周期

@property (nonatomic, strong) NSArray *remindPeriod;//提醒日期，逗号拼接
@property (nonatomic, assign) NSInteger clockType;//提醒的类型（1~4，单次，不定时，工作日，每天）

@end
