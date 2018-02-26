//
//  MacroNotifacation.h
//  Health
//
//  Created by perfectbao on 17/3/23.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#ifndef MacroNotifacation_h
#define MacroNotifacation_h

#define kRSAEncode     @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJPd8kRjByoz3miSskvIcgmCOutZJwUqg0KAJa1vyZP/C0EkxL1xYdaY339heq1p5htSouTlOFx9mmnSXWreF9cCAwEAAQ=="

#define KNotificationLoginSucc  @"KNotificationLoginSucc"   //登录成功
#define KNotificationLogOutSucc @"KNotificationLogOutSucc"  //登录失败
#define KNotificationLogin      @"KNotificationLogin"       //登录

#define KNotificationUserInfoUpdate     @"KNotificationUserInfoUpdate"  //刷新用户信息
#define KNotificationChangeUserInfo     @"KNotificationChangeUserInfo"  //改变用户头像


//腾讯云云通信服务AppId
#define kTCIMSDKAppId                        @"1400029558"
#define kTCIMSDKAccountType                  @"	12275"

//Http配置
#define kHttpServerAddr                      @"http://182.92.179.84:81/callback/Live_callback.php"

#define kHttpTimeout                         30

//录屏需要用到此配置,请改成您的工程配置文件中的app groups的配置
#define APP_GROUP                            @"group.com.tencent.fx.rtmpdemo"

//错误码
#define kError_InvalidParam                            -10001
#define kError_ConvertJsonFailed                       -10002
#define kError_HttpError                               -10003

//IMSDK群组相关错误码
#define kError_GroupNotExist                            10010  //该群已解散
#define kError_HasBeenGroupMember                       10013  //已经是群成员

//错误信息
#define  kErrorMsgNetDisconnected  @"网络异常，请检查网络"

//直播端错误信息
#define  kErrorMsgCreateGroupFailed  @"创建直播房间失败,Error:"
#define  kErrorMsgGetPushUrlFailed  @"拉取直播推流地址失败,Error:"
#define  kErrorMsgOpenCameraFailed  @"无法打开摄像头，需要摄像头权限"
#define  kErrorMsgOpenMicFailed  @"无法打开麦克风，需要麦克风权限"

//播放端错误信息
#define kErrorMsgGroupNotExit @"直播已结束，加入失败"
#define kErrorMsgJoinGroupFailed @"加入房间失败，Error:"
#define kErrorMsgLiveStopped @"直播已结束"
#define kErrorMsgRtmpPlayFailed @"视频流播放失败，Error:"

//提示语
#define  kTipsMsgStopPush  @"当前正在直播，是否退出直播？"



#endif /* MacroNotifacation_h */
