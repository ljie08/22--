//
//  RemindDataManager.h
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMTimerRemindMode.h"

@interface RemindDataManager : NSObject

+ (RemindDataManager *)manager;

- (NSArray *)queryRemindList;
- (void)updateLocalRemindData:(YMTimerRemindMode *)content;
- (void)insertRemindData:(YMTimerRemindMode *)content;
- (void)removeRelationShipOfRemindContent:(YMTimerRemindMode *)content;

@end
