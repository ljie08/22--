//
//  NSData+Conversion.h
//  PushChat
//
//  Created by Swapnil Godambe on 29/03/13.
//  Copyright (c) 2013 Medknow Publications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData_Conversion : NSObject
 
@end


@interface NSData (NSData_Conversion)

#pragma mark - String Conversion

/*!
 *  @brief  NSData返回十六进制字符串。如果数据是空的空字符串。
 */
- (NSString *)hexadecimalString;

@end