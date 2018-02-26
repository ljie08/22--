//
//  BaseJsonMode.h
//  JLMoney
//
//  Created by ZZY on 16/5/25.
//  Copyright © 2016年 金朗理财. All rights reserved.
//
//  数据解析基类

#import "Jastor.h"

#define Status_Succ 1

@interface BaseJsonMode : Jastor

@property (strong, nonatomic) NSNumber *status;         //状态

@property (strong, nonatomic) NSString *message;        //message

@end
