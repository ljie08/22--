//
//  YMTimerRemindMode.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/24.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "BaseJsonMode.h"

@interface YMTimerRemindMode : BaseJsonMode

@property (nonatomic, strong) YMTimerRemindMode *result;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *remindTitle;//标题
@property (nonatomic, strong) NSString *remindBellId;//闹铃ID
@property (nonatomic, strong) NSString *remindTime;//提醒的几个时间，逗号拼接
@property (nonatomic, assign) NSInteger remindShake;//震动
@property (nonatomic, strong) NSString *remindPeriod;//提醒日期，逗号拼接
@property (nonatomic, strong) NSString *remindStatus;//闹钟开关
@property (nonatomic, strong) NSString *remindVoice;//语音
@property (nonatomic, strong) NSString *medicineInfo;//剂量 吃药剂量和单位用逗号拼接的方式传给我eg:2,片
@property (nonatomic, assign) NSInteger remindType;//提醒的类型（1~8，吃药、测血压等等）
@property (nonatomic, strong) NSString *remindId;//

@end
