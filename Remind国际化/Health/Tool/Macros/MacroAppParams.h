//
//  MacroAppParams.h
//  Health
//
//  Created by perfectbao on 17/3/13.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#ifndef MacroAppParams_h
#define MacroAppParams_h


//由角度获取弧度
/** Float: Degrees -> Radian **/
#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180.0)
//有弧度获取角度
/** Float: Radians -> Degrees **/
#define RADIANS_TO_DEGREES(radians) ((radians * 180.0)/ M_PI)



/**Navigation - Go back - POP view controller **/
#define GOBACK [self.navigationController popViewControllerAnimated:YES]


//NavBar高度
#define NavigationBar_HEIGHT 44

/** Float: Return screen width **/
#define SCREEN_WIDTH    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define APPSCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)


/** Float: Return screen height **/
#define SCREEN_HEIGHT   ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define APPSCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


#define WIDTH_PROPORTION SCREEN_WIDTH /375.0
#define HEIGHT_PROPORTION SCREEN_HEIGHT /667.0

// Timer Invalidation 终止 NSTimer
#define UA_INVALIDATE_TIMER(t) [t invalidate]; t = nil;


// Device Info
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) /** BOOL: Detect if device is an iPad **/

#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) /** BOOL: Detect if device is an iPhone or iPod **/
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//#define IS_IPHONE5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE /** BOOL: Detect if device is an iPhone5 or not **/
#define IS_IPHONE_5_6 IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height > 568.0)

#define IS_IPHONE_4_4s IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height ==480.0)
#define IS_IPHONE_5_5s IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_4S_5 IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height ==480.0)||([[UIScreen mainScreen] bounds].size.height == 568.0)

#define IS_IPHONE_6_6s IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height ==667.0)

#define IS_IPHONE_6Plus_6sPlus IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height ==736.0)

#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER)) /** BOOL: Detect if device is an iPhone5 or not **/

#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)

#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)

#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)


/** BOOL: Is iOS version is greater than or equal to specified version**/
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

/** BOOL: retain屏 **/
#define IS_RETINA_DEVICE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] >= 2)

/** BOOL: 是否是支持多任务的设备 **/

#define IS_MULTI_TASKING_SUPPORTED ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported])


// Colors
#define UA_RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UA_RGB(r,g,b)       UA_RGBA(r, g, b, 1.0f)


// Return "YES" or "NO" string based on boolean value
#define NSStringFromBool(b) (b ? @"YES" : @"NO")

// Return content or @""
#define Transition(content)  content?:@""

// Debugging / Logging
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif


//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


/** Flush Auto Release Pool **/
#define FLUSH_POOL(p)   [p drain]; p = [[NSAutoreleasePool alloc] init]

/**
 
 Date formats:
 ===============
 
 MMM d, ''yy             Nov 4, '12
 'Week' w 'of 52'        Week 45 of 52
 'Day' D 'of 365'        Day 309 of 365
 m 'minutes past' h      9 minutes past 8
 h:mm a                  8:09 PM
 HH:mm:ss's'             20:09:00s
 HH:mm:ss:SS             20:09:00:00
 h:mm a zz               8:09 PM CST
 h:mm a zzzz             8:09 PM Central Standard Time
 yyyy-MM-dd HH:mm:ss Z	2012-11-04 20:09:00 -0600
 
 **/


#define DATE_FORMAT_DD_MM_YYYY              @"dd-MM-yyyy"               //e.g. 24-07-1990
#define DATE_FORMAT_MM_DD_YYYY              @"MM-dd-yyyy"               //e.g. 07-24-1990
#define DATE_FORMAT_YYYY_MM_DD              @"yyyy-MM-dd"               //e.g. 1990-07-24
#define DATE_FORMAT_YYYY__MM__DD            @"yyyy.MM.dd"               //e.g. 1990.07.24
#define DATE_FORMAT_YYYY_MM_DD_HH_MM_SS     @"yyyy.MM.dd HH:mm:ss"      //e.g. 1990-07-24 05:20:50
#define DATE_FORMAT_YYYY_MM_DD_HH_MM        @"yyyy-MM-dd HH:mm"         //e.g. 1990-07-24 05:20:50
#define DATE_FORMAT_DD_MM_YYYY_HH_MM_12H    @"dd-MM-yyyy hh:mm a"       //e.g. 24-07-1990 05:20 AM
#define DATE_FORMAT_MMM_DD_YYYY             @"MMM dd, yyyy"             //e.g. Jul 24, 1990
#define DATE_FORMAT_MMMM_DD                 @"MMMM dd"                  //e.g. July 24
#define DATE_FORMAT_MMMM                    @"MMMM"                     //e.g. July, November
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_SS    @"MMM dd, yyyy hh:mm:ss a"  //e.g. Jul 24, 2014 05:20:50 AM
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_12H   @"MMM dd, yyyy hh:mm a"     //e.g. Jul 24, 2014 05:20 AM
#define DATE_FORMAT_HH_MM_SS                @"HH:mm:ss"                 //e.g. 05:20:50 AM
#define DATE_FORMAT_E                       @"E"                        //e.g. Tue
#define DATE_FORMAT_EEEE                    @"EEEE"                     //e.g. Tuesday
#define DATE_FORMAT_QQQ                     @"QQQ"                      //e.g. Q1,Q2,Q3,Q4
#define DATE_FORMAT_QQQQ                    @"QQQQ"                      //e.g. 4th quarter


/** Convert object to nil if its from NSNull class**/

#define NULL_TO_NIL(obj) ({ _typeof_ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })


/** Try - catch block
 *Use TRY CATCH IN ANY METHOD LIKE THIS
 *- (void)anyMethodThatCanGenerateException {
 *  TRY_CATCH_START
 *    code that generate exception
 *
 *  TRY_CATCH_END
 * }
 **/

#define TRY_CATCH_START @try{

#define TRY_CATCH_END }@catch(NSException *e){NSLog(@"\n\n\n\n\n\n\
\n\n|EXCEPTION FOUND HERE...PLEASE DO NOT IGNORE\
\n\n|FILE NAME %s\
\n\n|LINE NUMBER %d\
\n\n|METHOD NAME %s\
\n\n|EXCEPTION REASON %@\
\n\n\n\n\n\n\n",strrchr(__FILE__,'/'),__LINE__, __PRETTY_FUNCTION__,e);};


#define DATE_COMPONENTS         NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit /** Return date component**/
#define TIME_COMPONENTS         NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit /** Return time component**/


#define USER_DEFAULTS           [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER     [NSNotificationCenter defaultCenter]
#define SHARED_APPLICATION      [UIApplication sharedApplication]


/** 获取Text的CGSize **/
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) {P = nil; }


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:@"png"]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------颜色类--------------------------
#define kRSAEncode     @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJPd8kRjByoz3miSskvIcgmCOutZJwUqg0KAJa1vyZP/C0EkxL1xYdaY339heq1p5htSouTlOFx9mmnSXWreF9cCAwEAAQ=="


//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
#define MyFont(F) [UIFont systemFontOfSize:F]


//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)



//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}



#endif /* MacroAppParams_h */
