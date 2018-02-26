//
//  TimestampTool.m
//  HlrtDoctor
//
//  Created by ZZY on 15/3/25.
//  Copyright (c) 2015年 吕仁军. All rights reserved.
//

#import "TimestampTool.h"
#import <Security/Security.h>
#import "Tools.h"


#define  pubKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCI1M8/q9xX5KtYVqk1mLaRDf6BdemiEp2qO/UwE12A0yrh/jc7lDiwO/hBJXTyAbEPlj/JCL41Ej9YgDnk8UqkOG14oc6T3P+aCceWYzimkX3DyzcCWkUCSy5Ydn0Jiy6osLY9zbU6aDiLWS5nvr0+5bSYnKGpaeY6eI+spU1kswIDAQAB"

#define encodeStr = "QsJKerNUeLvEohYb9lhV68Orf139ZlwQWZZGRjLFiujpdQtQgZQwcIrHN4YTJ3BB7lAc7tYWUz5+vY+HZESmiIDcELhpbSUA0J6/rr+dFlA7o2ONJZ75dn9szpZpw1ERYqKfky1oURdSjGX/EUisSdMW1Sig2ORBgwZs5weX9VU="

@implementation TimestampTool

/**
 *  @author 15-03-25
 *
 *  获取 时间戳
 *
 *  @return 时间
 */
+ (NSString *)haoSecond {
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    double i=time;      //NSTimeInterval返回的是double类型
    
    return [NSString stringWithFormat:@"%.0f",i];
}


+(NSString *)haoSecondToTime:(NSNumber *)haoSecond{
   
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[haoSecond doubleValue]/1000];
    NSString *value = [formatter stringFromDate:date];
    return  value;
}

+(NSString *)haoSecondToTime2:(NSNumber *)haoSecond{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"dd日HH:mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[haoSecond doubleValue]/1000];
    NSString *value = [formatter stringFromDate:date];
    return  value;
}

/**
 *  @author 15-03-25
 *
 *  获取MD5加密的时间
 *
 *  @return 时间s
 */
+ (NSString*)getTimestampMD5:(NSString*)strMd5 {
    
    NSString *timMd5 = [NSString stringWithFormat:@"phb%@",strMd5];
    
    return [Tools md5:timMd5];
}


-(SecKeyRef)getPublicKey{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"keystore" ofType:@"p7b"];
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}









@end
