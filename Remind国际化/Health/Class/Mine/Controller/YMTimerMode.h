//
//  YMTimerMode.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/28.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "BaseJsonMode.h"

@interface YMTimerMode : BaseJsonMode

@property (nonatomic, strong) YMTimerMode *result;

@property (nonatomic, strong) NSString *remindTitle;//标题
@property (nonatomic, strong) NSString *rTime;//提醒的几个时间，逗号拼接
@property (nonatomic, assign) NSInteger remindType;//提醒的类型（1~8，吃药、测血压等等）
@property (nonatomic, strong) NSString *remindId;//
@property (nonatomic, strong) NSString *durationTime;//

@end
