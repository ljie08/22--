//
//  AppDelegate.h
//  Sleep
//
//  Created by perfectbao on 17/3/13.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionHandle)();


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (copy, nonatomic) void (^receivedWithEventBlock) (UIEvent *event);

@property (nonatomic,copy)  completionHandle backgroundSessionCompletionHandler;

@property (nonatomic, strong) NSMutableDictionary *completionHandlerDictionary;




@end

