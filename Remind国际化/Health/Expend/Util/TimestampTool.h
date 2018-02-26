//
//  TimestampTool.h
//  HlrtDoctor
//
//  Created by ZZY on 15/3/25.
//  Copyright (c) 2015年 吕仁军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimestampTool : NSObject

/**
 *  获取 时间戳
 */
+ (NSString *)haoSecond;

/**
 *  获取MD5加密的时间
 */
+ (NSString*)getTimestampMD5:(NSString*)strMd5;

/**
 *  通过时间戳获取时间
 */
+(NSString *)haoSecondToTime:(NSString *)haoSecond;

/**
 *  通过时间戳获取时间 hh:mm
 */
+(NSString *)haoSecondToTime2:(NSNumber *)haoSecond;
@end
