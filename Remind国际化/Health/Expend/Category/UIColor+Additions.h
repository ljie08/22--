
//
//  UIColor+Additions.h
//

#import <UIKit/UIKit.h>

/**
 * 颜色类型（unsigned int类型.
 **/
typedef unsigned int ADDColorType;

/**
 * Category `UIColor`的增加方便的方法来操作的颜色。
 **/
@interface UIColor (Additions)

/*!
 *  @brief  创建一个随机的颜色
 *
 *  @return 该`UIColor`实例
 */
+ (UIColor *)randomColor;

/** *************************************************** **
 * @name 十六进制的支持
 ** *************************************************** **/

/** 
 * 创建从RGB十六进制整数值的颜色。
 * @参数RGB值在十六进制整数表示的RGB颜色。
 * @return：该`UIColor`实例。
 **/
+ (UIColor*)add_colorWithRGBHexValue:(ADDColorType)rgbHexValue;

/**
 * 创建从RGBA十六进制整数值的颜色。
 * @param rgbaHexValue RGB值然后RGBA颜色代表一个十六进制整数。
 * @return：该`UIColor`实例。
 **/

+ (UIColor*)add_colorWithRGBAHexValue:(ADDColorType)rgbaHexValue;

/** 
 * 创建从RGB十六进制字符串值的颜色。
 * @param rgbHexString RGB值在十六进制字符串表示的RGB颜色。
 * @return：该`UIColor`实例。
 **/
+ (UIColor*)add_colorWithRGBHexString:(NSString*)rgbHexString;

/** 
 *创建从RGBA十六进制字符串值的颜色。
 * @param rgbaHexString RGB值然后RGBA颜色代表一个十六进制的字符串。
 * @return：该`UIColor`实例。 **/
+ (UIColor*)add_colorWithRGBAHexString:(NSString*)rgbaHexString;

/**
 * 检索RGB十六进制整数。 
 * @param rgbHexValue RGB值的指针的整数，其中的值将被写入。
 * @return YES，如果可以被检索的颜色说明，否则NO。
 **/
- (BOOL)add_getRGBHexValue:(ADDColorType*)rgbHexValue;

/** 
 * 检索RGBA十六进制整数。
 * @param rgbaHexValue RGBA值一个指向一个整数，其中的值将被写入。
 * @return YES，如果可以被检索的颜色说明，否则NO。
 **/
- (BOOL)add_getRGBAHexValue:(ADDColorType*)rgbaHexValue;

/**
  * 检索RGB十六进制字符串值。
  * @return 的RGB十六进制字符串表示或为零。
  **/
- (NSString*)add_RGBHexString;

/**
 * 检索RGBA十六进制字符串值。
 * @return 该RGBW十六进制字符串表示或为零。
 **/
- (NSString*)add_RGBAHexString;

/** *************************************************** **
 * @name RGB支持
 ** *************************************************** **/

/**
  * 创建从RGB（0-255范围）的值的颜色。
  * @param red 红色0-255范围内的红色值。
  * @param green 绿色0-255范围内的绿色价值。
  * @param blue 蓝0-255范围内的蓝色值。
  * @return 从RGB值的新颜色。
  **/
+ (UIColor*)add_colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue;

/**
  * 创建的RGBA（0-255范围）值的颜色。
  * @param red 红色0-255范围内的红色值。
  * @param green 绿色0-255范围内的绿色价值。
  * @param blue 蓝0-255范围内的蓝色值。
  * @param alpha α的0-255范围内的Alpha值。
  * @return 从RGB值的新颜色。
  **/
+ (UIColor*)add_colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue alpha255:(CGFloat)alpha;

/** *************************************************** **
 * @name Luminiscence
 ** *************************************************** **/

/** 
 * 当前颜色为灰度转换。
 * @return 新的灰度颜色。
 * @discussion此方法使用L = R *0.2989+ G *0.5870+ B *0.1140的发光的公式。
 **/
- (UIColor*)add_grayColor;

/**
  * 一个便捷的方法，表示如果色彩被认为是“轻”。
  * @return YES如果颜色被认为是“轻”，NO，否则。
  **/
- (BOOL)add_isLightColor;

/**
  * 一个便捷的方法，表示如果色彩被认为是“黑暗”。
  * @return YES如果颜色被认为是“黑暗”，NO，否则。
  **/
- (BOOL)add_isDarkColor;

/** *************************************************** **
 * @name 修改颜色
 ** *************************************************** **/

/**
  * 创建从当前通过改变饱和度的新颜色。
  * @param newSaturation
  * @return 一个新的颜色。
  **/
- (UIColor*)add_colorWithSaturation:(CGFloat)newSaturation;

/**
 * 创建从当前通过改变亮度的新的颜色。
 * @param newBrightness 消息亮度
 * @return 一个新的色彩。 
 **/
- (UIColor*)add_colorWithBrightness:(CGFloat)newBrightness;

/**
  * 创建一个新的颜色变浅。
  * @param value 值浮点值从0到1，其中0表示没有变化，1表示最亮可能的颜色。
  * @return 一个新的颜色。
  **/
- (UIColor*)add_lighterColorWithValue:(CGFloat)value;

/**
  * 创建一个新的更暗的颜色。
  * @param value 值浮动值从0到1，其中0表示没有变化，1是指最黑暗的可能的颜色。
  * @return 一个新的颜色。
  **/
- (UIColor*)add_darkerColorWithValue:(CGFloat)value;


/** *************************************************** **
 * @name 通过颜色创建图片
 ** *************************************************** **/


/**
  * 返回由一种颜色生成一个UIImage。 （有用的设置按钮背景图片的状态是纯色。）
  *
  * @param color 颜色创建映像出的颜色。
  *
  * @return 传递的颜色的UIImage的。
  */
+ (UIImage *)imageFromColor:(UIColor *)color;

/*!
 *  @brief  创建一个渐变的颜色
 *
 *  @param c1     颜色一
 *  @param c2     颜色二
 *  @param height 颜色的高度
 *
 *  @return 一个新的颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

@end
