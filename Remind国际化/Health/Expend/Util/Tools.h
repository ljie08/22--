//
//  Tools.h
//  GroupPurchase
//
//  Created by MacPro.com on 14-8-26.
//
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/**
 *  md5 加密;
 *
 *  @param string 传入要加密的字符串;
 *
 *  @return 加密后的字符串;
 */
+ (NSString *)md5:(NSString *)string;

/**
 *  16进制颜色(html颜色值)字符串转为UIColor
 *
 *  @param stringToConvert 16进制颜色(html颜色值)
 *
 *  @return UIColor
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

/**
 *  根据颜色返回一个 UIimage
 *
 *  @param color color description
 *  @param size  size description
 *
 *  @return UIimage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  根据一行字符串,高度,大小,返回一宽度;
 *
 *  @param string       string 字符串
 *  @param stringHeight stringHeight 一个字符高度
 *  @param fontSize     fontSize 字符大小
 *
 *  @return 宽度;
 */
+(CGFloat)widthForWithNSSting:(NSString *)string stringHeight:(CGFloat )stringHeight fontSize:(CGFloat)fontSize;
/**
 *   根据一行字符串,高度,大小,返回一高度;
 *
 *  @param string       string 字符串
 *  @param stringWidth stringWidth 一个字符宽度
 *  @param fontSize    fontSize 字符大小
 *
 *  @return 高度;
 */
+(CGFloat)heightForWithNSSting:(NSString *)string stringWidth:(CGFloat )stringWidth fontSize:(CGFloat)fontSize;

+(NSDictionary *)loadDataUserDefaultObjectForKey:(NSString *)key;

/**
 * 设置AlertView
 *
 *  @param title title
 */
+(void)showAlertViewWithTitle:(NSString *)title;
/**
 *  usdefault 储存值;
 *
 *  @param string 储存对象;
 *  @param key    key值;
 */
+(void )saveObject:(id)string ToNSDefaultsWithKey:(NSString *)key;
+(NSString *)loadStandUserDefaultObjectForKey:(NSString *)key;

/**
 *  取消键盘第一响应;
 *
 *  @param view 指定那个视图上的view;
 */
+(void)resignKeyBoardInView:(UIView *)view;

/**
 *  判断手机号;
 *
 *  @param mobileNum mobileNum 电话号码
 *
 *  @return return value Bool
 */
+(BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  邮箱
 *
 *  @param email email
 *
 *  @return return value Bool
 */
+ (BOOL) validateEmail:(NSString *)email;


/**
 *  身份证判定
 *
 *  @param value IDCard
 *
 *  @return return value Bool
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;


/**
 *  设置字符串 行间 高度
 *
 *  @param string  string description
 *  @param spacing spacing 高度;
 *
 *  @return return NSMutableAttributedString 对象
 */
+(NSMutableAttributedString*)setString:(NSString*)string spacingHight:(NSInteger)spacing;

/**
 *  打电话
 *
 */
+(void)call:(NSString *)phoneNumber;
/**
 *  截断字符串空格;
 *
 */
+ (NSString *)trimString:(NSString *)string;

/**
 *  当前设备 
 *
 */
+(NSString*)deviceString;



+ (BOOL)isNull:(id)object;

/**
 *  当前时间 例如2015年3月26日 周四
 *
 */
+(NSString *)getNowDateAndWeek;

/*!
 *  @brief  当前时间 例如2015年3月26日
 *
 */
+(NSString *)getNowDate;

/*!
 *  @brief  DES加密
 *
 *  @param plainText 数据
 *  @param key       Key
 *
 *  @return <#return value description#>
 */
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString*)key;

/*!
 *  @brief  DES解密
 *
 *  @param cipherText 加密数据
 *  @param key        Key
 *
 *  @return <#return value description#>
 */
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
@end
