//
//  AppDelegate.m
//  Sleep
//
//  Created by perfectbao on 17/3/13.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "HMAlertView.h"
#import "YMClockManager.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "YMTimerRemindViewController.h"
#import "RemindListViewController.h"


@interface AppDelegate ()

@property (nonatomic, strong) DZXNavigationController *RootController;

@end

@implementation AppDelegate
{
    UIBackgroundTaskIdentifier _bgTaskId;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    YMTabbarViewController *tabBarRootController = [[YMTabbarViewController alloc] init];
//      YMTimerRemindViewController *VC = [[YMTimerRemindViewController alloc] init];

    RemindListViewController *VC = [[RemindListViewController alloc] init];
    
    self.RootController = [[NavigationController alloc] initWithRootViewController:VC];
    
    self.window.rootViewController = self.RootController;
    
    [self.window makeKeyAndVisible];

   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    NSDictionary *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentSleepDetailController" object:nil];
    }
    
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types==UIUserNotificationTypeNone) {//注册本地通知
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
    [self cancelLocalNotification];
    
    return YES;
}

- (void)cancelLocalNotification{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[YMClockManager shareManager] cancelAllLocalNotifications];
        
        NSLog(@"first launch");
    }

}

#pragma mark - Method


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

//    NSDictionary *userInfo = notification.userInfo;
//    if ([[userInfo.allKeys lastObject] hasPrefix:@"睡眠"]) {
//        
//        if (application.applicationState == UIApplicationStateInactive ||  application.applicationState == UIApplicationStateBackground) {
//            
//            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//            YMTabbarViewController *tabbar = (YMTabbarViewController *)nav.viewControllers.firstObject;
//            
//            for (UIViewController *childVC in tabbar.childViewControllers) {
//                if ([childVC isKindOfClass:NSClassFromString(@"YMListenViewController")]) {
//                    
//                    YMSleepDetailViewController *vc = [[YMSleepDetailViewController alloc] init];
//                    
//                    YMListenViewController *listenVC = (YMListenViewController *)childVC;
//                    [listenVC.navigationController pushViewController:vc animated:YES];
//                }
//            }
//        }
//    }else if ([[userInfo.allKeys lastObject] hasPrefix:@"DownLoadSingsKey"]){//DownLoadSingsKey
//        
//        if (application.applicationState == UIApplicationStateInactive ||  application.applicationState == UIApplicationStateBackground) {
//            
//            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//            YMTabbarViewController *tabbar = (YMTabbarViewController *)nav.viewControllers.firstObject;
//            
//            for (UIViewController *childVC in tabbar.childViewControllers) {
//                if ([childVC isKindOfClass:NSClassFromString(@"YMMineViewController")]) {
//                    
//                    YMDownloadListViewController *vc = [[YMDownloadListViewController alloc] init];
//                    
//                    YMMineViewController *mineVC = (YMMineViewController *)childVC;
//                    [mineVC.navigationController pushViewController:vc animated:YES];
//                }
//            }
//        }
//    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [application beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVAudioSessionInterruptionNotification object:nil];
    
//    _bgTaskId = [AppDelegate backgroundPlayerId:_bgTaskId];
}

+(UIBackgroundTaskIdentifier)backgroundPlayerId:(UIBackgroundTaskIdentifier)backTaskId{
    
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
    
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// 接受远程通知
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    // 判断是否为远程通知
    if (event.type == UIEventTypeRemoteControl) {
        if (self.receivedWithEventBlock) {
            self.receivedWithEventBlock(event);
        }
    }
}



@end
