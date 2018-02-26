//
//  NSString+Additional.m
//  SAMCategory
//
//  Created by MilanPanchal on 08/09/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "NSString+Additional.h"

@implementation NSString (Additional)

#pragma mark - Validations

- (BOOL)isNull {

    if (self == nil || [self isKindOfClass:[NSNull class]] || [self isEmpty]
        || ![self length]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}


- (BOOL)isEmail {
    
    //Create a regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    //Create predicate with format matching your regex string
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    //return true if email address is valid
    return [emailTest evaluateWithObject:self];
    
}

/**
 *  银行卡
 *
 *  @param cardNo 银行卡
 *
 *  @return 是否
 */
+ (BOOL)checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

- (BOOL)isStartsWithACapitalLetter {
    
    unichar firstCharacter = [self characterAtIndex:0];
    return [[NSCharacterSet uppercaseLetterCharacterSet]
            characterIsMember:firstCharacter];
    
}

#pragma mark - 

- (NSString *)trimWhitespace {
    
//    NSMutableString *str = [self mutableCopy];
//    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
//    return str;
    
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfWords {
    __block NSUInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                            options:NSStringEnumerationByWords|NSStringEnumerationSubstringNotRequired
                         usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                             count++;
                         }];
    return count;
}

- (NSString *)reverseString {
    
//    int len = [self length];
//    
//    NSMutableString *reversedStr = [NSMutableString stringWithCapacity:len];
//    while (len--) {
//        [reversedStr appendFormat:@"%C", [self characterAtIndex:len]];
//    }
    
    // New way
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,[self length])
                             options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                  [reversedString appendString:substring];
                              }];

    
    return reversedString;
}

- (NSString *)concat:(NSString *)string {
 
    if (!string) {
        return self;
    }
    
    return [NSString stringWithFormat:@"%@%@",self, string];
}

- (BOOL)contains:(NSString *)string {
    
    if (string) {
        NSRange range = [self rangeOfString:string];
        return (range.location != NSNotFound);
        
    }else {
        return NO;
    }

}


+ (NSString *)truncateString:(NSString *) string toCharacterCount:(NSUInteger) count {
    
    NSRange range = { 0, MIN(string.length, count) };
    range = [string rangeOfComposedCharacterSequencesForRange: range];
    NSString *trunc = [string substringWithRange: range];
    
    if (trunc.length < string.length) {
        trunc = [trunc stringByAppendingString: @"..."];
    }
    
    return trunc;
    
} // truncateString

#pragma mark - URL Encoding and Decoding
- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();@&=+$,?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

#pragma mark - Date Format

- (NSDate *)dateFromFormat: (NSString *)formatter {

    //    debug(@"dateString %@",dateString);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:formatter];
    
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    return dateFromString;
}



#pragma mark - 判断字符串 中文字符 字母 数字 以及下划线

-(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    NSInteger len = string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}

/*!
 *  @brief  判断是否为整形
 *
 *  @param string 数据
 *
 *  @return 是否
 */
- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/*!
 *  @brief  判断是否为浮点数
 *
 *  @param string 数据
 *
 *  @return 是否
 */
- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/*!
 *  @brief  替换字符串
 *
 *  @param beginCount 开始位置
 *  @param endCount   结束位置
 *  @param replace    代替字符串
 *
 *  @return NSString
 */
- (NSString*)hideMiddleStringBegin:(NSInteger)beginCount WithEnd:(NSInteger)endCount WithToString:(NSString*)replace {
    
    if (self.length >= (beginCount+endCount)) {
        
        NSInteger raplaceCount = self.length - (beginCount+endCount);
        
        NSMutableArray *by_replace = [NSMutableArray arrayWithCapacity:raplaceCount];
        
        for (int i=0; i<4; i++) {
            [by_replace addObject:replace];
        }
        
        return [self stringByReplacingCharactersInRange:NSMakeRange(beginCount, raplaceCount) withString: [by_replace componentsJoinedByString:@""]];
    }
    
    return self;
}


/*!
 *  @brief  密码判定
 *
 *  @param _password 密码
 *
 *  @return 是否符合  声明：包含大写/小写/数字/ 6-16
 */
+ (BOOL) judgePasswordStrength:(NSString*) _password
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    BOOL isRegex = [passWordPredicate evaluateWithObject:_password];
    
    if (isRegex) {
        NSMutableArray* resultArray = [[NSMutableArray alloc] init];
        
        NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
        
        NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
        NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
        
        [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
        [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
        
        int intResult=0;
        for (int j=0; j<[resultArray count]; j++)
        {
            if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
            {
                intResult++;
            }
        }
        
        if (intResult > 1 && [_password length] >= 6 && [_password length] <= 16)
        {
            return YES;
        }
        return NO;
        
    }else {
        
        return isRegex;
    }
}

//是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}


/*!
 *  @brief  小数点保留
 *
 *  @param values 要处理的数据
 *  @param count  保留的位数
 *
 *  @return 结果
 */
+ (NSString*)reservePointCount:(double)values WithCount:(int)count {

    for (int i=0; i<count+1; i++) {
        
        double nomalValue = values;
        
        NSString *formatStr = @"%0.";
        formatStr = [formatStr stringByAppendingFormat:@"%df", i];
        
        double reserveValue = [[NSString stringWithFormat:formatStr,nomalValue] doubleValue];
        
        if (reserveValue == nomalValue) {
            return [NSString stringWithFormat:formatStr,nomalValue];
        }else if (i == count) {
            return [NSString stringWithFormat:formatStr,nomalValue];
        }
    }
    
    return @"";
}

/*!
 *  @brief  时间格式化
 *
 *  @param haoSecond 毫秒数
 *
 *  @return 结果
 */
+ (NSString *)haoSecondToTime:(NSNumber *)haoSecond WithFormat:(NSString*)format {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:format];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[haoSecond doubleValue]/1000];
    NSString *value = [formatter stringFromDate:date];
    
    return  value;
}


+ (NSString*)disposeResult:(NSNumber*)result {
    
    return [NSString disposeResult:result WithCount:10];
}


+ (NSString*)disposeResult:(NSNumber*)result WithCount:(int)count {
    
    if ([result doubleValue] >= 10000.0) {
        return [NSString stringWithFormat:@"%@万", [NSString reservePointCount:[result doubleValue]/10000.0 WithCount:count]?:@"0"];
    }
    
    return [NSString stringWithFormat:@"%@元",result?:@"0"];
}



- (CGFloat)getStringHeight:(NSLineBreakMode)lineBreakMode
             WithAlignment:(NSTextAlignment)alignment
                 WithFootL:(UIFont*)foot
                  WithSize:(CGSize)size {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_0
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    NSDictionary *attributes = @{ NSFontAttributeName : foot,
                                  NSParagraphStyleAttributeName : paragraphStyle };
    
    CGSize contentSize = [self boundingRectWithSize:size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize.height;
#else
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self];
    // 获取该段attributedString的属性字典
    // 计算文本的大小
    CGSize textSize = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size; // context上下文。包括一些信息，例如如何调整
    
    return textSize.height;
#endif
    
}


- (NSArray*)jsonSerialization {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]){
        
        NSArray *nsArray = (NSArray *)jsonObject;
        return nsArray;
    }
    
    return nil;
}

/**
 *  判断是否是表情符号
 *
 *  @return 是否
 */
- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f9c0) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if(ls == 0xfe0f || ls == 0x20e3 || ls == 0xd83c ) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                
                if (0x2100 <= hs && hs <= 0x27ff ) {
                    
                    if(hs >= 0x278b && hs <= 0x2792){
                        returnValue = NO;
                    }
                    else{
                        returnValue = YES;
                    }
                    
                }
                else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}


/**
 *  判断中英混合的的字符串长度
 *
 *  @return 长度
 */
- (int)convertToInt
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}


@end
