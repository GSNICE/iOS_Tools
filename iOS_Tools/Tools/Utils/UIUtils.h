//
//  UlUtils.h
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/mount.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface UIUtils : NSObject

/**
 获取当前的时间戳
 
 @return 时间戳字符串
 */
+ (NSString *)currentTimeStr;

/**
 时间戳转时间
 
 @param str 时间戳字符串
 @param formate 时间格式
 @return 返回转换后的日期
 */
+ (NSString *)dateStringFromTimeStr:(NSString *)str formate:(NSString *)formate;


/**
 将日期格式化为NSString对象

 @param date 日期
 @param formate 格式
 @return NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;

/**
 将NSString格式化为日期对象
 
 @param string 日期
 @param formate 格式
 @return NSString
 */
+ (NSDate *)dateFromString:(NSString *)string formate:(NSString *)formate;

/**
 将当前时间转成北京时间

 @param nowDate 当前时间
 @return 北京时间
 */
+ (NSDate *)timeZoneToDate:(NSDate *)nowDate;

/**
 将日期转化为今天，昨天等

 @param date 日期
 @return 今天、昨天等
 */
+ (NSString *)compareDate:(NSDate *)date;

//将秒数转换成时间字符串，格式为00:00:00
+ (NSString*)stringFromSeconds:(float)seconds withHour:(BOOL)isHour;

/**
 校验图片是否为有效的PNG图片

 @param imageData 图片文件直接得到的NSData对象
 @return 是否为有效的PNG图片
 */
+ (BOOL)isValidPNGByImageData:(NSData*)imageData;

/**
 验证图片是否为完整的JPG图片
 
 @param jpeg 图片资源
 @return 0表示成功   其他表示失败
 */
+ (int)isJPEGValid:(NSData *)jpeg;

/**
 将十六进制颜色值转化为rgb值

 @param HEX 是十六进制值，不需要写#
 @return UIColor
 */
+ (UIColor *)transferHEXToRGB:(NSString *)HEX;

/**
 将数组中元素进行排序

 @param dataArray 数组
 @param key <#key description#>
 @param ascending yes 正序 no为倒叙
 @return 排序后的数组
 */
+ (NSArray *)sortArray:(NSArray *)dataArray withKey:(NSString *)key ascending:(BOOL)ascending;

/**
 计算某个目录下的文件大小

 @param directory 目录
 @return 目录下的文件大小
 */
+ (long long)countDirectorySize:(NSString *)directory;

/**
 获取手机总存储空间大小

 @return 手机存储空间大小
 */
+ (float)totalDiskSpace;

/**
 获取手机可用存储空间大小

 @return 手机存可用储空间大小
 */
+ (float)freeDiskSpace;

/**
 判断当前字符是否为数字

 @param inputString 输入字符
 @return 是否为数字
 */
+ (BOOL)isValidateNumber:(NSString *)inputString;

/**
 是否包含中文

 @param zhCharacter 字符串
 @return 是否包含中文
 */
//+ (BOOL)isZHCharacter:(NSString *)zhCharacter;

/**
 输入是否合法（数字、字母或下划线才合法）

 @param inputString 输入的文字
 @return 是否合法
 */
+ (BOOL)isValidaString:(NSString *)inputString;

/**
 *  根据des文字，获取文本的size
 *
 *  @param des  根据des文字，获取文本的size
 *  @param font 字体大小
 *  @param size 预留最大size
 *
 *  @return 实际文本的size
 */
+ (CGSize)getSizeWithLabel:(NSString *)des withFont:(UIFont *)font withSize:(CGSize)size;

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

/**
 *  值保留小数点后position位
 *
 *  @param price    小数值
 *  @param position 小数点几位
 *
 *  @return 小数点后position位的字符串
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position;

/** 
 *  语言国际化
 *
 *  @param string   本地化文字的key
 *
 *  @return 经过本地化的文字
 */
+ (NSString *)localizedString:(NSString *)string;

+ (NSString *)localizedString:(NSString *)string inBundle:(NSBundle *)bundle;


/**
 获取当前语言

 @return    如果用户有手动选择语言，则返回手动语言 （zh, en,.....,etc）
            如果没有手动选择语言，则跟随系统语言 （zh, en,......,etc）
 */
+ (NSString *)getCurrentLanguage;


/**
 *  获取手机型号
 *
 *  @return 手机具体型号，比如iPhone 6s
 */
+ (NSString *)platform;

/**
 *  获取手机设备的UUID
 *
 *  @return 手机设备的 UUID，比如 UUID
 */
+ (NSString *)uuid;


/**
 改变String中某些文字的颜色和字体

 @param content 原文字
 @param search 需要改变颜色和字体的文字
 @param font 字体大小
 @param color 颜色
 @return 返回属性字符串
 */
+ (NSMutableAttributedString *)stringFromContent:(NSString *)content Search:(NSString *)search font:(UIFont *)font color:(UIColor *)color;

/**
 获取本机的IP地址

 @return 本机IP地址
 */
+ (NSString *)deviceIPAdress;

/**
 *  获取文件大小
 *  @param path 文件路径
 *  @return 文件大小
 *
 */
+ (long long)fileSizeForPath:(NSString *)path;

/**
 判断是否是手机号

 @param patternStr 模板字符串
 @return 结果
 */
+ (BOOL)isPhoneNumber:(NSString *)patternStr;


/**
 是否是合法的邮箱

 @param patternStr 模板字符串
 @return 结果
 */
+ (BOOL)detectionIsEmailQualified:(NSString *)patternStr;

/**
 计算目录下文件大小
 
 @param filePath 文件路径
 @return 文件大小
 */
+ (NSInteger)fileSize:(NSString *)filePath;


/**
 获取Documents目录

 @return Documents目录
 */
+ (NSString *)getDocumentPath;

/**
 创建目录
 
 @param dirName 目录名
 @return 目录路径
 */
+ (NSString *)createDirectoryPath:(NSString *)dirName;

/**
 *  获取文件大小
 *  @param path 文件路径
 *  @return 文件大小
 *
 */
+ (long long)fileSizeForPath:(NSString *)path;

/**
 16进制转10进制
 
 @param aHexString 十六进制字符串
 @return 十进制
 */
+ (NSNumber *)numberHexString:(NSString *)aHexString;


/**
 将十进制数转换成十六进制数
 
 @param tmpid 十进制数
 @return 十六进制数
 */
+ (NSString *)ToHex:(long long int)tmpid;

/**
 获取文件MD5校验码
 
 @param path 文件的路径
 @return MD5校验码
 */
+ (NSString*)getFileMD5WithPath:(NSString*)path;

/**
 将十六进制字符串转化为NSData
 
 @param str 十六进制字符串
 @return data
 */
+ (NSData *)convertHexStrToData:(NSString *)str;

/**
 将十六进制data转为十六进制字符串
 
 @param data 十六进制data
 @return 十六进制字符串
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

/**
 根据颜色值生成纯色图片
 
 @param color 色值
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 改变图片颜色

 @param image 原图片
 @param color 颜色
 @return 新图片
 */
+ (UIImage *)changeImage:(UIImage *)image wiithColor:(UIColor *)color;

/**
 压缩图片质量和压缩图片尺寸结合
 如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
 https://www.cnblogs.com/silence-cnblogs/p/6346729.html
 
 @param image 目标图片
 @param maxLength 最大尺寸
 @return Data
 */
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/**
 获取当前系统时间，将系统时间转为海思特定格式时间字符串
 sysTime 年+月+日+时+分+秒 20170315144700
 
 @return 海思特定格式时间字符串
 */
+ (NSString *)getSystemTime;

/**
 Url编码
 
 @param str 原Url
 @return 编码之后的Url
 */
+ (NSString *)URLEncodedString:(NSString *)str;

+ (id)dictFromJson:(id)str;

/**
 将 UIView 类转 UIImage 解决失真模糊
 
 @param view UIView
 @return UIImage
 */
+ (UIImage*)convertViewToImageWithView:(UIView*)view;

+ (NSDictionary *)fetchSSIDInfo;

/**
 播放本地音频文件

 @param audioName 音频文件全称
 */
+ (void)playAudio:(NSString *)audioName;

/**
 将时间秒数转化为时分秒
 
 @param seconds 时间秒数
 @param isHour 是否显示小时
 @return 返回时分秒字符串
 */
- (NSString*)stringFromSeconds:(float)seconds withHour:(BOOL)isHour;

/**
 获取视频分辨率
 
 @param videoPath 视频路径
 @return 返回视频尺寸
 */
+ (CGSize)getVideoResolution:(NSString *)videoPath;

/**
 获取视频时长
 
 @param videoPath 视频路径
 @return 视频时长，单位为秒
 */
+ (NSInteger)getVideoDuration:(NSString *)videoPath;

/**
 把字典转换为 json

 @param object 字典
 @return json字符串
 */
+ (NSString*)jsonStringFromObject:(id)object;

/**
 json 字符串转字典或数组

 @param jsonString jsonString
 @return 数组或字典
 */
+ (id)jsonStringToDictOrArray:(NSString *)jsonString;

/**
 获取目录下的文件夹的名字
 
 @param directory 文件目录
 @return 文件夹下的文件列表
 */
+ (NSArray *)arrayOfDirectory:(NSString *)directory;

/**
 给 View 设置渐变色
 @param view 需要设置渐变色的 view
 @param startColor 开始原色
 @param endColor 结束原色
 @param startPoint 开始点
 @param endPoint 结束点
*/
+ (void)setGradientOfView:(UIView *)view withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint;

/**
 给 View 设置圆角边框
 @param view 需要设置圆角的view
 @param lineWidth 边框线宽度
 @param strokeColor strokeColor
 @param fillColor fillColor
 @param radius 圆角大小
*/
+ (void)setBoardlineOfView:(UIView *)view withLineWidth:(float)lineWidth withStrokeColor:(UIColor *)strokeColor withFillColor:(UIColor *)fillColor withCornerRadius:(float)radius;

/**
 给 View 设置圆角

 @param view 需要设置圆角的 view
 @param size 圆角的大小尺寸
 @param rectCorners 圆角的类型
 */
+ (void)setCornerOfView:(UIView *)view withSize:(CGSize)size withRectCorners:(UIRectCorner)rectCorners;

/**
 将UIView转换成一个UIImage对象
 
 @param view 需要截屏转换的View
 @return 转换之后的UIImage
 */
+ (UIImage *)transferViewToImage:(UIView *)view;

/**
 将图片裁剪成圆形图片
 
 @param radius 圆形图片的半径
 @param imageSize 图片大小
 @param image 原图片
 @return 裁剪之后的图片
 */
+ (UIImage*)cutImageWithRadius:(int)radius withImageSize:(CGSize)imageSize withImage:(UIImage *)image;

/**
 大文件拷贝，将大文件从fromPath拷贝到toPath
 
 @param fromPath 源文件路径
 @param toPath 目标文件路径
 @param block 拷贝完成的回调
 */
+ (void)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath withCompletion:(void(^)(BOOL result))block;


/**
 配置埋点字典
 
 @param productName 产品名
 @param snCode SN码
 */
+ (NSDictionary *)compenentAnalyisisDic:(NSString *)productName withSNCode:(NSString *)snCode;


/**
 获取App的相关信息  版本号，build版本号，手机系统版本等

 @return Dic
 */
+ (NSDictionary *)getAppDetailInfo;
@end
