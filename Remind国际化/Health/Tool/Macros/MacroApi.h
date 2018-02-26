//
//  MacroApi.h
//  Health
//
//  Created by perfectbao on 17/3/13.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#ifndef MacroApi_h
#define MacroApi_h

//开发
#define kBaseURL       @"http://182.92.179.84:81"  //192.168.1.108:8080
#define KBasePicURL    @"http://182.92.179.84:81/sleep/"
#define KBaseIDPicURL  @"http://182.92.179.84:81/sleep/uploadFile.shtml?method=download&fileId="
#define KBaseDownloadURL @"http://182.92.179.84:81/sleep/uploadFile/downloadLargeFile.shtml?fileId="

//后台人员的本地地址
//#define kBaseURL       @"http://182.92.5.226:7001"
//#define KBasePicURL    @"http://182.92.5.226:7001/sleep/"
//#define KBaseIDPicURL  @"http://182.92.5.226:7001/sleep/uploadFile.shtml?method=download&fileId="
//#define KBaseDownloadURL @"http://182.92.5.226:7001/sleep/uploadFile/downloadLargeFile.shtml?fileId="


//后台人员的本地地址
//#define kBaseURL       @"http://192.168.1.200:8080"
//#define KBasePicURL    @"http://192.168.1.200:8080/sleep/"
//#define KBaseIDPicURL  @"http://192.168.1.200:8080/sleep/uploadFile.shtml?method=download&fileId="
//#define KBaseDownloadURL @"http://192.168.1.200:8080/sleep/uploadFile/downloadLargeFile.shtml?fileId="



#pragma mark -- 登录注册

#define KFeedback                 @"/sleep/feedback/saveFeedback.shtml"                 //意见反馈
#define kCheckUpdate              @"/sleep/version/getVersion.shtml"                   //检查更新
#define kLogin                    @"/sleep/users/userLogin.shtml"                      //登陆
#define KRegister                 @"/sleep/users/userRegister.shtml"                   //注册
#define kvalidCode                @"/sleep/sendSMS/sendValidCode.shtml"                //获取短信验证码
#define kcheckMobile              @"/sleep/users/checkMobile.shtml"                    //手机是否已注册
#define kForgetPass               @"/sleep/users/findPassword.shtml"                   //找回登录密码
#define kUploadPicture            @"/sleep/upload.shtml"                               //上传头像
#define kSaveChangeUserInfo       @"/sleep/users/modifyMyInfo.shtml"                   //修改用户信息


#pragma mark -- 听听
#define kGetMusicsList @"/sleep/musics/getMusicsByType.shtml"     //获取音乐列表
#define kMusicDetail   @"/sleep/musics/getMusic.shtml"            //获取歌曲详情
#define kCommentList   @"/sleep/comment/getComments.shtml"        //评论列表
#define kWriteComment   @"/sleep/comment/writeComment.shtml"      //写评论
#define kDetailRecomMixMusic @"/sleep/musics/getMixMusics.shtml"  //获取详情默认推荐的歌曲
#define kMusicLike     @"/sleep/collection/iWannaCollect.shtml"   //点赞、取消点赞
#define kGetWarning    @"/sleep/warning/getWarning.shtml"         //获取警示语

#pragma mark -- 我的

#define kTimerRemind   @"/sleep/remind/saveRemind.shtml"          //上传定时提醒数据
#define kGetTimerRemind   @"/sleep/remind/getRemind.shtml"          //查询提醒数据


#pragma mark -- 测试    
#define kTestType             @"/sleep/testQuestionsType/getTestQuestionsType.shtml"   //测试类型
#define kGetTestQuestionsList @"/sleep/testQuestionsEntries/getTestQuestionsEntries.shtml" //测试问题列表
#define kGetTestQuestions     @"/sleep/testQuestions/getTestQuestions.shtml"               //测试问题
#define kGetTestQuestionResult @"/sleep/testQuestionsResult/getTestQuestionsResult.shtml"  //测试结果

#pragma mark -- 健康    

#define kGetHealthType     @"/sleep/healthyType/getHealthyType.shtml"                //健康类型
#define kGetHealthContent  @"/sleep/healthy/getHealthy.shtml"                        //健康类型对应集合
#define kGetLargeFilePath  @"/sleep/uploadFile/getLargeFilePath.shtml"               //获取大型文件路径

#pragma mark -- 看看

#define kGetLiveList        @"/sleep/live/getLiveList.shtml"                           //获取直播列表
#define kCreateLiveRoom     @"/sleep/live/saveLive.shtml"                             //创建直播房间
#define kLiveSwitch         @"/sleep/live/liveSwitch.shtml"                            //直播间开关



#endif /* MacroApi_h */
