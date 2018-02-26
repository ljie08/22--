//
//  NSString+Additional.h
//  SAMCategory
//
//  Created by MilanPanchal on 08/09/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

#pragma mark - Validations

- (BOOL)isNull ;

- (BOOL)isEmpty ;

- (BOOL)isEmail ;

+ (BOOL)checkCardNo:(NSString*) cardNo;

- (BOOL)isStartsWithACapitalLetter;

#pragma mark - 

- (NSString *)trimWhitespace ;

- (NSUInteger)numberOfWords ;

- (NSString *)reverseString ;

- (NSString *)concat:(NSString *)string ;

- (BOOL)contains:(NSString *)string ;

+ (NSString *)truncateString:(NSString *) string toCharacterCount:(NSUInteger) count ;


#pragma mark - URL Encoding and Decoding

- (NSString *)urlEncode ;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding ;

- (NSString *)urlDecode ;

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding ;

#pragma mark - Date Format

- (NSDate *)dateFromFormat: (NSString *)formatter ;


#pragma mark - 判断字符串 中文字符 字母 数字 以及下划线

-(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string;

/*!
 *  @brief  判断是否为整形
 */
- (BOOL)isPureInt;

/*!
 *  @brief  判断是否为浮点数
 */
- (BOOL)isPureFloat;



/*!
 *  @brief  替换字符串
 *
 *  @param beginCount 开始位置
 *  @param endCount   结束位置
 *  @param replace    代替字符串
 *
 *  @return NSString
 */
- (NSString*)hideMiddleStringBegin:(NSInteger)beginCount WithEnd:(NSInteger)endCount WithToString:(NSString*)replace;


/*!
 *  @brief  密码判定
 *
 *  @param _password 密码
 *
 *  @return 是否符合  声明：包含大写/小写/数字/
 */
+ (BOOL) judgePasswordStrength:(NSString*) _password;

//是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password;

/*!
 *  @brief  小数点保留
 *
 *  @param values 要处理的数据
 *  @param count  保留的位数
 *
 *  @return 结果
 */
+ (NSString*)reservePointCount:(double)values WithCount:(int)count;

/*!
 *  @brief  时间格式化
 *
 *  @param haoSecond 毫秒数
 *
 *  @return 结果
 */
+ (NSString *)haoSecondToTime:(NSNumber *)haoSecond WithFormat:(NSString*)format;


+ (NSString*)disposeResult:(NSNumber*)result;

+ (NSString*)disposeResult:(NSNumber*)result WithCount:(int)count;

- (CGFloat)getStringHeight:(NSLineBreakMode)lineBreakMode
             WithAlignment:(NSTextAlignment)alignment
                 WithFootL:(UIFont*)foot
                  WithSize:(CGSize)size;


- (NSArray*)jsonSerialization;


/**
 *  判断是否是表情符号
 *
 *  @return 是否
 */
- (BOOL)stringContainsEmoji;

/**
 *  判断中英混合的的字符串长度
 *
 *  @return 长度
 */
- (int)convertToInt;

@end
