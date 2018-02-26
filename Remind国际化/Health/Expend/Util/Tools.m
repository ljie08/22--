//
//  Tools.m
//  GroupPurchase
//
//  Created by MacPro.com on 14-8-26.
//
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"

@implementation Tools

+ (NSString *)md5:(NSString *)string;

{   const char *original_str = [string UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
 
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(CGFloat)widthForWithNSSting:(NSString *)string stringHeight:(CGFloat )stringHeight fontSize:(CGFloat)fontSize
{    
    CGRect rect=  [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, stringHeight) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil];
    return rect.size.width;
}
+(CGFloat)heightForWithNSSting:(NSString *)string stringWidth:(CGFloat )stringWidth fontSize:(CGFloat)fontSize;
{
    CGRect rect=  [string boundingRectWithSize:CGSizeMake(stringWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil];
    return rect.size.height;
    
}
+(void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
+(void )saveObject:(id)string ToNSDefaultsWithKey:(NSString *)key;
{
    if (![string isKindOfClass:[NSString class]] && ![string isKindOfClass:[NSDictionary class]] && ![string isKindOfClass:[NSArray class]]) {
       string=@"";
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)string;
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:dic forKey:key];
        [archiver finishEncoding];
        string = (NSData *)data;
    }
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:key];
    [userDefaults synchronize];
}

+(NSString *)loadStandUserDefaultObjectForKey:(NSString *)key
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return str;
}

+(NSDictionary *)loadDataUserDefaultObjectForKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data && data.length) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return myDictionary;
    }
    return nil;
}


//取消键盘第一响应;
+(void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
    
}


//判断手机号;
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *phoneRegex = @"^((14[5,7])|(13[0-9])|(15[^4,\\D])|(17[0,6-8])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}


//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证判定
+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

+(NSMutableAttributedString*)setString:(NSString*)string spacingHight:(NSInteger)spacing
{
    NSMutableAttributedString* attString =[[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle * paragraphStyle =[[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:spacing];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    return attString;
}
//打电话

+(void)call:(NSString *)phoneNumber
{
    NSString *phoneNum=[NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:phoneNum]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]]; //拨号
    }else{
        HMAlertView *alertView = [[HMAlertView alloc]initWithTitle:@"您的设备不支持打电话" andMessage:@""];
        [alertView addButtonWithTitle:@"确定" type:HMAlertViewButtonTypeDefault handler:^(HMAlertView *alertView) {
            
        }];
        
        [alertView show];
    }
}

#pragma mark 清空字符串中的空白字符
+ (NSString *)trimString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";

    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}


+ (BOOL)isNull:(id)object
{
    if ([object isKindOfClass:[NSNumber class]]) {
        object = [NSString stringWithFormat:@"%@",object];
    }
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (object==nil)
    {
        return YES;
    }else if ([object isEqualToString:@"<null>"]){
        return YES;
    }else if ([object isEqualToString:@"null"])
    {
        return YES;
    }
    else if ([object isEqualToString:@"(null)"])
    {
        return YES;
    }
    else if ([object isEqualToString:@""]){
        return YES;
    }
    return NO;
}

//得到当前时间
+(NSString *)getNowDateAndWeek{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger week=[comps weekday];
    NSString *weekDay;
    switch (week) {
        case 1:
            weekDay=@"周日";
            break;
        case 2:
            weekDay=@"周一";
            break;
        case 3:
            weekDay=@"周二";
            break;
        case 4:
            weekDay=@"周三";
            break;
        case 5:
            weekDay=@"周四";
            break;
        case 6:
            weekDay=@"周五";
            break;
        case 7:
            weekDay=@"周六";
            break;
        default:
            break;
    }
    
    NSString *str=[NSString stringWithFormat:@"%ld年%ld月%ld日  %@",(long)year,(long)month,(long)day,weekDay];
    return  str;
}

//得到当前时间
+(NSString *)getNowDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
//    NSInteger week=[comps weekday];
    
    NSString *str=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    return  str;
}




/*
 *  DES加密
 *
 */

static Byte iv[8]={1,2,3,4,5,6,7,8};

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString*)key

{
    
    NSString *ciphertext =nil;
    
    NSData* data=[plainText dataUsingEncoding: NSUTF8StringEncoding];
    
   // NSLog(@"plainTextBytes with UTF-8 encoding:%@",[XYDESdataToHex:data]);
    
    
    
    NSUInteger bufferSize=([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    
    char buffer[bufferSize];
    
    memset(buffer, 0,sizeof(buffer));
    
    size_t bufferNumBytes;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                         
                                         kCCAlgorithmDES,
                                         
                                         kCCOptionPKCS7Padding,
                                         
                                         [key UTF8String],
                                         
                                         kCCKeySizeDES,
                                         
                                         iv   ,
                                         
                                         [data bytes],
                                         
                                         [data length],
                                         
                                         buffer,
                                         
                                         bufferSize,
                                         
                                         &bufferNumBytes);
    
    
    
    if (cryptStatus ==kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
        
        
        ciphertext = [GTMBase64 stringByEncodingData:data];
        
        
        
        NSLog(@"objccipherTextBase64:%@",ciphertext);
        
        NSLog(@"JavacipherTextBase64:%@",@"1y6iSDPEcx/plgtI23Beevmat3LG5uGc6PP46hbuUpc=");
        
        
        
    }   
    
    
    
    return ciphertext;
    
}


/*
 *  DES解密
 *
 */

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key

{
    
    NSData* data = [GTMBase64 decodeString:cipherText];
    
    NSUInteger bufferSize=([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    
    char buffer[bufferSize];
    
    memset(buffer, 0,sizeof(buffer));
    
    size_t bufferNumBytes;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                         
                                         kCCAlgorithmDES,
                                         
                                         kCCOptionPKCS7Padding,
                                         
                                         [key UTF8String],
                                         
                                         kCCKeySizeDES,
                                         
                                         iv,
                                         
                                         [data bytes],
                                         
                                         [data length],
                                         
                                         buffer,
                                         
                                         bufferSize,
                                         
                                         &bufferNumBytes);
    
    NSString* plainText = nil;
    
    
    
    if (cryptStatus ==kCCSuccess) {
        
        NSData *plainData =[NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
        
        
        
        plainText = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
        
        
        
    }
    
    return plainText;
    
}







@end
