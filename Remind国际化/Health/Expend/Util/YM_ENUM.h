//
//  YM_ENUM.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/23.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#ifndef YM_ENUM_h
#define YM_ENUM_h

typedef NS_ENUM  (NSInteger, UserDataType){
    UserDataTypeDate           = 0,   //时间
    UserDataTypeGender         = 1,   //性别
    UserDataTypeAge            = 2,   //年龄
    UserDataTypeSmokeAge       = 3,   //烟龄
    UserDataTypeSmokeCount     = 4,   //抽烟几盒
    UserDataTypeDosage         = 5,   //剂量
    UserDataTypeCup            = 6,   //容量
};

typedef NS_ENUM  (NSInteger, TimerRemindType){

    kTimerRemindDrug           =1,//吃药
    kTimerRemindBlood          =2,//测血糖
    kTimerRemindPluse          =3,//测脉搏
    kTimerRemindCheck          =4,//复查
    kTimerRemindCure           =5,//理疗
    kTimerRemindDrinkWater     =6,//喝水
    kTimerRemindSport          =7,//运动
    kTimerRemindSleep          =8,//睡眠

};
#endif /* YM_ENUM_h */
