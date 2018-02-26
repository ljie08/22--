//
//  YMClockManager.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/22.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMCLockMode.h"

@interface YMClockManager : NSObject

+ (YMClockManager *)shareManager;

//获取时间

- (NSString *)getNowDay;

- (NSString *)getCurrentTimeBy12Hours;//12小时制度

- (NSString *)getCurrentTimeBy24Hours;//24小时

- (NSString *)getCurrentTimeString;

- (NSTimeInterval)getCurrentSeconds;

- (NSInteger)getCurrentWeekDay;

- (NSInteger)getCurrentLocalWeekDay;

- (NSDate *)getFireDataWithClockTime:(NSString *)clockTime selectedDay:(NSInteger)selectDay;//day是负数时，为单次提醒

- (NSTimeInterval )getSecondFromNowToClockTime:(NSString *)clockTime;

- (NSInteger )getMinutesFromNowToClockTime:(NSString *)clockTime;

- (NSString *)getTimeGapWithClockTime:(NSString *)clockTime;//剩余xx小时xx分钟


- (BOOL)isShowClockTime;

- (NSTimeInterval )getSecondsWithClockTime:(NSString *)clockTime;

//24小时制 - > 12小时制

- (NSString *)getTimeWith24HourTimeStr:(NSString *)sTime;

//12小时制 - > 24小时制
- (NSString *)getTimeWith12HourTimeStr:(NSString *)sTime;


//存储
//- (YMCLockMode *)getClockData;

- (void)saveClockData:(YMCLockMode *)mode;

- (NSString *)getRemindBellId;

- (NSString *)getRemindTime;

- (BOOL)isOpenShake;

- (BOOL)isOpenWeek;

- (BOOL)isOpenClock;

- (NSArray *)getRemindPeriod;

- (NSInteger)getClockType;


- (void)removeClockData;

//添加本地通知

- (void)addLocalNotificationWithNavTitle:(NSString *)navTitle
                             remindTitle:(NSString *)remindTitle
                                 weekDay:(NSString *)weekDay
                               clockTime:(NSString *)cTime
                          RepeatInterval:(NSCalendarUnit)repeatInterval;

- (void)addLocalNotificationForFireDate:(NSDate *)fireDate
                                 forKey:(NSString *)key
                              alertBody:(NSString *)alertBody
                            alertAction:(NSString *)alertAction
                              soundName:(NSString *)soundName
                               userInfo:(NSDictionary *)userInfo
                             badgeCount:(NSInteger)badgeCount
                         repeatInterval:(NSCalendarUnit)repeatInterval;

//移除本地通知

- (void)cancelLocalNotificationWithNavTitle:(NSString *)navTitle
                                remindTitle:(NSString *)remindTitle
                                    weekDay:(NSString *)weekDay
                                  clockTime:(NSString *)cTime;

- (void)cancelLocalNotificationWithKey:(NSString *)key;


- (void)cancelAllLocalNotifications;


@end
