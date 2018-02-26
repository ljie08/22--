//
//  YMClockManager.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/22.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMClockManager.h"
#import <AudioToolbox/AudioToolbox.h>

#define kDayConvertSecond     24*3600
#define kHourConvertSecond    3600
#define kMinuteConvertSecond  60

#define YMClockData          @"YMClockData"
#define YMRemindBellId       @"remindBellId"
#define YMRemindTime         @"remindTime"
#define YMShake              @"isOpenShake"
#define YMClock              @"isOpenClock"
#define YMWeek               @"isOpenWeek"
#define YMRemindPeriod       @"remindPeriod"
#define YMClockType          @"clockType"


@implementation YMClockManager

+ (YMClockManager *)shareManager{

    static YMClockManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YMClockManager alloc] init];
    });
    
    return manager;
}

- (NSString *)getNowDay{

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

//获取时间
- (NSString *)getCurrentTimeBy12Hours{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"hh:mm"];
    NSString *hour = [formatter stringFromDate:date];
    NSString *noon;
    if ([hour integerValue] < 12) {
        noon = @"上午";
    }else{
        noon = @"下午";
        
    }
    NSString *currentTime = [NSString stringWithFormat:@"%@%@",noon,[formatter1 stringFromDate:date]];
    
    return currentTime;
}

- (NSString *)getCurrentTimeBy24Hours{

    return [self getTimeWith12HourTimeStr:[self getCurrentTimeBy12Hours]];
}

- (NSString *)getCurrentTimeString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *timeStr = [formatter stringFromDate:date];
//    return timeStr;
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%ld",(NSInteger)interval];
}

- (NSTimeInterval)getCurrentSeconds{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss"];
    NSString *seconds = [dateFormatter stringFromDate:date];
    return  60 - [seconds integerValue];
}

- (NSInteger)getCurrentWeekDay{

    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unit = NSCalendarUnitWeekday;
    
    NSInteger weekday = [calendar component:unit fromDate:dateNow];

    return weekday;
}

- (NSInteger)getCurrentLocalWeekDay{
    
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSInteger unit = NSCalendarUnitWeekday;
    
    NSInteger weekday = [calendar component:unit fromDate:dateNow];
    
    return weekday;
}


- (NSDate *)getFireDataWithClockTime:(NSString *)clockTime selectedDay:(NSInteger)selectDay{

    NSDate *dateNow = [NSDate date];
    NSInteger weekday = [self getCurrentWeekDay];
    NSTimeInterval interval = [self getSecondsWithClockTime:clockTime];
    NSTimeInterval gapInterval = interval;
    if (selectDay >=0) {//不定时提醒
        
        if (weekday == 1) {
            weekday = 8;
        }
        gapInterval = interval + ((selectDay + 2) - weekday) * kDayConvertSecond;
    }
    
    if (gapInterval < 0) {
        if (selectDay >= 0) {
            gapInterval = gapInterval + 7 * 24 * 3600;
        }else{
            
            gapInterval = gapInterval + 24 * 3600;
        }
    }
    
    NSDate *fireDate = [dateNow dateByAddingTimeInterval:gapInterval];
    
    return fireDate;
}

- (NSTimeInterval )getSecondsWithClockTime:(NSString *)clockTime{//24小时

    NSString *nowDateStr = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
    NSArray *nArr = [nowDateStr componentsSeparatedByString:@":"];
    NSArray *cArr = [clockTime componentsSeparatedByString:@":"];
    
    NSInteger minutes = ([cArr[0] integerValue] - [nArr[0] integerValue]) * 60 + [cArr[1] integerValue] - [nArr[1] integerValue];

    NSInteger interval = minutes * 60;
    //秒数
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    NSString *seconds = [formatter stringFromDate:date];
    NSInteger s = [seconds integerValue];
    
    return interval - s;
}

- (NSTimeInterval )getSecondFromNowToClockTime:(NSString *)clockTime{
    
    NSString *cTimeStr = [self getCurrentTimeBy12Hours];
    
    NSTimeInterval interval ;
    if (([cTimeStr hasPrefix:@"上午"] && [clockTime hasPrefix:@"上午"])||([cTimeStr hasPrefix:@"下午"] && [clockTime hasPrefix:@"下午"])) {
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"上午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"上午"];
        NSInteger hour = [sArr[0] integerValue] - [cArr[0] integerValue] ;
        interval = hour * kHourConvertSecond +  ([sArr[1] integerValue] - [cArr[1] integerValue])*kMinuteConvertSecond;
        
    }else if ([cTimeStr hasPrefix:@"上午"] && [clockTime hasPrefix:@"下午"]){
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"上午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"下午"];
        interval = ([sArr[0] integerValue] + 12 - [cArr[0] integerValue]) * kHourConvertSecond + ([sArr[1] integerValue] - [cArr[1] integerValue])*kMinuteConvertSecond;
        
    }else if ([cTimeStr hasPrefix:@"下午"] && [clockTime hasPrefix:@"上午"]){
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"下午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"上午"];
        interval = ([sArr[0] integerValue]  - [cArr[0] integerValue] - 12) * kHourConvertSecond + ([sArr[1] integerValue] - [cArr[1] integerValue])*kMinuteConvertSecond;
    }
    //秒数
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    NSString *seconds = [formatter stringFromDate:date];
    NSInteger s = [seconds integerValue];
    return interval - s ;
}

- (NSInteger )getMinutesFromNowToClockTime:(NSString *)clockTime{
    
    NSString *cTimeStr = [self getCurrentTimeBy12Hours];
    NSInteger minutes = 0 ;
    if (([cTimeStr hasPrefix:@"上午"] && [clockTime hasPrefix:@"上午"])||([cTimeStr hasPrefix:@"下午"] && [clockTime hasPrefix:@"下午"])) {
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"上午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"上午"];
        
        NSInteger sHour = [sArr[0] integerValue];
        if ([clockTime hasPrefix:@"下午"] && sHour < 0) {
            sHour += 12;
        }
        NSInteger hour = sHour - [cArr[0] integerValue] ;
        minutes = hour * 60 + ([sArr[1] integerValue] - [cArr[1] integerValue]);
        if (minutes < 0) {
            minutes += 24 * 60;
        }
        
    }else if ([cTimeStr hasPrefix:@"上午"] && [clockTime hasPrefix:@"下午"]){
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"上午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"下午"];
        minutes = ([sArr[0] integerValue] + 12 - [cArr[0] integerValue]) * 60 + ([sArr[1] integerValue] - [cArr[1] integerValue]);
        
    }else if ([cTimeStr hasPrefix:@"下午"] && [clockTime hasPrefix:@"上午"]){
        
        NSArray *cArr = [self getTimeArrayWithTimeStr:cTimeStr Noon:@"下午"];
        NSArray *sArr = [self getTimeArrayWithTimeStr:clockTime Noon:@"上午"];
        
        minutes = ([sArr[0] integerValue] + 12 - [cArr[0] integerValue]) * 60 + ([sArr[1] integerValue] - [cArr[1] integerValue]);
    }
    
    //秒数
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    NSString *seconds = [formatter stringFromDate:date];
    NSInteger s = [seconds integerValue];
//    if (s > 0) {
//        --  minutes;
//        
//    }
    if (minutes < 0) {
        minutes = 0;
    }
    return minutes ;
}


- (NSArray *)getTimeArrayWithTimeStr:(NSString *)timeStr Noon:(NSString *)noon{
    
    NSArray *arr = [timeStr componentsSeparatedByString:@":"];
    NSString *str = arr[0];
    NSString *hour= [str substringWithRange:NSMakeRange(2,str.length - 2)];
    NSArray *array  = [NSArray arrayWithObjects:hour,arr[1], nil];
    
    return array;
}

- (NSString *)getTimeGapWithClockTime:(NSString *)clockTime{//时间差
    
    //    NSInteger minutes = [self getNowTimeStr:[self getCurrentTime] ClockTime:clockTime];
    NSInteger minutes = [self getMinutesFromNowToClockTime:clockTime];
    NSInteger hour = minutes/60;
    NSInteger minute = minutes %60;
    
    NSString *hourStr;
    if (hour < 10) {
        
        hourStr = [NSString stringWithFormat:@"0%ld",hour];
    }else{
        
        hourStr = [NSString stringWithFormat:@"%ld",hour];
    }
    
    NSString *minuteStr;
    if (minute < 10) {
        
        minuteStr = [NSString stringWithFormat:@"0%ld",minute];
    }else{
        
        minuteStr = [NSString stringWithFormat:@"%ld",minute];
        
    }
    return [NSString stringWithFormat:@"%@%@%@%@",hourStr,LOCALIZED(@"小时"),minuteStr,LOCALIZED(@"分钟")];
}

- (BOOL)isShowClockTime{
    
    //存储的闹钟时间
    NSString  *clockTime = [self getRemindTime];
    
    if (clockTime.length <=0 ) {
        return NO;
    }
    
    NSArray *sArray = [self getRemindPeriod];
    if (sArray.count > 0) {
        NSInteger weekDay = [[YMClockManager shareManager] getCurrentLocalWeekDay];
        if (weekDay == 0) {
            weekDay = 8;
        }
        weekDay = weekDay - 2;
        
        for (NSString *weekStr in sArray) {
            if ([weekStr integerValue] == 8) {//每天
                return  YES;
            }else if ([weekStr integerValue] == 7){//工作日
                
                if (weekDay == 4 || weekDay == 5) {//周五、周六不提醒
                    return  NO;
                }else{
                    
                    return  YES;
                }
            }
            
            if ([weekStr integerValue] == weekDay || [weekStr integerValue] == weekDay + 1) {
                return  YES;
            }
            
        }
    }
//    else{//单次
//        
//        NSInteger second = [self getSecondFromNowToClockTime:clockTime];
//        if (second > -60 ) {
//            
//            return YES;
//            
//        }else{
//          
//        }
//        
//    }
    
    return NO;
}

//24小时制 - > 12小时制

- (NSString *)getTimeWith24HourTimeStr:(NSString *)timeStr{

    NSMutableString  *mStr = [NSMutableString string];
    NSArray *arr = [timeStr componentsSeparatedByString:@":"];
    if ([arr[0] integerValue] < 12) {
        [mStr appendString:@"上午"];
        [mStr appendString:timeStr];
    }else{
        [mStr appendString:@"下午"];
        if ([arr[0] integerValue ]- 12 < 10) {
            [mStr appendFormat:@"0%ld:",[arr[0] integerValue] - 12];
            
        }else{
            [mStr appendFormat:@"%ld:",[arr[0] integerValue] - 12];
        }
        
        [mStr appendString:arr[1]];
    }
    
    return mStr;
}

//12小时制 - > 24小时制
- (NSString *)getTimeWith12HourTimeStr:(NSString *)sTime{

    NSMutableString *mStr = [NSMutableString string];
    
    if ([sTime hasPrefix:@"上午"] ) {
        [mStr appendString:[sTime substringFromIndex:2]];
    }else if ([sTime hasPrefix:@"下午"]){
        
        NSString *time = [sTime substringFromIndex:2];
        NSArray *tArr = [time componentsSeparatedByString:@":"];
        NSInteger hour = [tArr[0] integerValue]  < 12 ? [tArr[0] integerValue] + 12 : [tArr[0] integerValue];
        NSString *s = [NSString stringWithFormat:@"%ld:%@",hour,tArr[1]];
        [mStr appendString:s];
    }    return mStr;
}



- (void)saveClockData:(YMCLockMode *)mode{
    
    [USER_DEFAULTS setObject:mode.remindBellId forKey:YMRemindBellId];
    [USER_DEFAULTS setObject:mode.remindTime forKey:YMRemindTime];
    [USER_DEFAULTS setBool:mode.isOpenShake forKey:YMShake];
    [USER_DEFAULTS setBool:mode.isOpenWeek forKey:YMWeek];
    [USER_DEFAULTS setBool:mode.isOpenClock forKey:YMClock];
    [USER_DEFAULTS setObject:mode.remindPeriod forKey:YMRemindPeriod];
    [USER_DEFAULTS setInteger:mode.clockType forKey:YMClockType];
    
}

- (NSString *)getRemindBellId{

    return [USER_DEFAULTS objectForKey:YMRemindBellId];
}

- (NSString *)getRemindTime{
    return [USER_DEFAULTS objectForKey:YMRemindTime];

}

- (BOOL)isOpenShake{

    return [USER_DEFAULTS boolForKey:YMShake];
}

- (BOOL)isOpenWeek{
    return [USER_DEFAULTS boolForKey:YMWeek];
}

- (BOOL)isOpenClock{
    return [USER_DEFAULTS boolForKey:YMClock];
    
}

- (NSArray *)getRemindPeriod{

    NSArray *arr = [USER_DEFAULTS objectForKey:YMRemindPeriod];
    return arr;
}

- (NSInteger)getClockType{

    return [USER_DEFAULTS integerForKey:YMClockType];
}


- (void)removeClockData{

    NSLog(@"清除！");
    [USER_DEFAULTS removeObjectForKey:YMRemindBellId];
    [USER_DEFAULTS removeObjectForKey:YMRemindTime];
    [USER_DEFAULTS removeObjectForKey:YMShake];
    [USER_DEFAULTS removeObjectForKey:YMWeek];
    [USER_DEFAULTS removeObjectForKey:YMClock];
    [USER_DEFAULTS removeObjectForKey:YMRemindPeriod];
    [USER_DEFAULTS removeObjectForKey:YMClockType];

    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YMClockData];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//添加本地通知

- (NSString *)getNotificationIdWithNavTitle:(NSString *)navTitle
                                remindTitle:(NSString *)remindTitle
                                    weekDay:(NSString *)weekDay
                                  clockTime:(NSString *)cTime{
    
    return  [NSString stringWithFormat:@"%@%@%@%@",navTitle,remindTitle,weekDay,cTime];
}

- (void)addLocalNotificationWithNavTitle:(NSString *)navTitle
                             remindTitle:(NSString *)remindTitle
                                 weekDay:(NSString *)weekDay
                               clockTime:(NSString *)cTime
                          RepeatInterval:(NSCalendarUnit)repeatInterval{

    NSString *notificationID = [self getNotificationIdWithNavTitle:navTitle remindTitle:remindTitle weekDay:weekDay clockTime:cTime];//吃药  周一 第一次
    NSString *notificationName = [NSString stringWithFormat:@"%@Name",notificationID];
    NSDictionary *useInfo =@{notificationID:notificationName};
    NSString *bodyText = remindTitle.length > 0 ? remindTitle : navTitle ;
    
    NSInteger sDay = weekDay.length > 0 ? [weekDay integerValue] : -1;
    NSDate *fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:cTime selectedDay: sDay];
    
    NSLog(@"添加定时提醒: %@  fireDate = %@",notificationID,fireDate);
    [self addLocalNotificationForFireDate:fireDate forKey:notificationID alertBody:bodyText alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:repeatInterval];
}



- (void)addLocalNotificationForFireDate:(NSDate *)fireDate
                                 forKey:(NSString *)key
                              alertBody:(NSString *)alertBody
                            alertAction:(NSString *)alertAction
                              soundName:(NSString *)soundName
                               userInfo:(NSDictionary *)userInfo
                             badgeCount:(NSInteger)badgeCount
                         repeatInterval:(NSCalendarUnit)repeatInterval{

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification) {
        return;
    }
    
//    [self cancelLocalNotificationWithKey:key];
    
    localNotification.alertBody        = alertBody;
    localNotification.alertAction      = alertAction;
    localNotification.repeatInterval   = repeatInterval;
    localNotification.applicationIconBadgeNumber = badgeCount;
    localNotification.userInfo = userInfo;
    //Sound
    if (soundName.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSArray *array=[dic keysSortedByValueUsingSelector:@selector(compare:)];
        
        NSString *sName = dic[array[0]];
        NSLog(@"path = %@",path);
        localNotification.soundName = soundName;
    } else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    if (!fireDate) {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    } else {
        localNotification.fireDate = fireDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }

    
}

//移除本地通知

- (void)cancelAllLocalNotifications{

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

- (void)cancelLocalNotificationWithNavTitle:(NSString *)navTitle
                                remindTitle:(NSString *)remindTitle
                                    weekDay:(NSString *)weekDay
                                  clockTime:(NSString *)cTime{

    NSString *key = [self getNotificationIdWithNavTitle:navTitle remindTitle:remindTitle weekDay:weekDay clockTime:cTime];
    NSLog(@"取消定时提醒: %@",key);
    [self cancelLocalNotificationWithKey:key];
}

- (void)cancelLocalNotificationWithKey:(NSString *)key{

    NSArray *notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notiArray) {
        for (UILocalNotification *notification in notiArray) {
            NSDictionary *dic = notification.userInfo;
            if (dic) {
                for (NSString *key in dic) {
                    if ([key isEqualToString:key]) {
                        [[UIApplication sharedApplication] cancelLocalNotification:notification];
                    }
                }
            }
        }
    }
}

@end
