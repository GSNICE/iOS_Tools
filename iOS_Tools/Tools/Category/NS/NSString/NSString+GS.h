//
//  NSString+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (GS)

/// 字典 转为 jsonStr
@property (nonatomic, copy, readonly) NSString *jsonStr;

@end

@interface NSString (GS)

// 😀😉😌😰😂 Emoji start
/// 将十六进制的编码转为 emoji 字符
+ (NSString *)emojiWithIntCode:(int)intCode;

/// 将十六进制的编码转为 emoji 字符
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/// 是否为 emoji 字符
- (BOOL)isEmoji;
/// 去掉 表情符号 可能漏了一些
- (NSString *)disableEmoji;
// 😀😉😌😰😂 Emoji end

/// 去空格 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
@property (nonatomic, copy, readonly) NSString *delBlank;

/// 去空格 stringByReplacingOccurrencesOfString:@" " withString:@""
@property (nonatomic, copy, readonly) NSString *delSpace;

/// 长时间戳对应的 NSDate
@property (nonatomic, strong, readonly) NSDate *date;

/// YYYY-MM-dd 对应的 NSDate
@property (nonatomic, strong, readonly) NSDate *date__YMd;

/// YYYY.MM.dd 对应的 NSDate
@property (nonatomic, strong, readonly) NSDate *date__YMd_Dot;

/// YYYY-MM-dd HH:mm:ss 对应的 NSDate
@property (nonatomic, strong, readonly) NSDate *date__YMdHMS;

/// 转为 Data
@property (nonatomic, copy, readonly) NSData *data;

/// 转为 base64string 后的 Data
@property (nonatomic, copy, readonly) NSData *base64Data;

/// 转为 base64String
@property (nonatomic, copy, readonly) NSString *base64Str;

/// 解 base64str 为 Str 解不了就返回原始的数值
@property (nonatomic, copy, readonly) NSString *decodeBase64;

/// 解 为字典 if 有
@property (nonatomic, strong, readonly) NSDictionary *jsonDic;

/// 解 为数组 if 有
@property (nonatomic, strong, readonly) NSArray *jsonArr;

/// 按字符串的，逗号分割为数组
@property (nonatomic, strong, readonly) NSArray *combinArr;

/// 32位 MD5 加密
@property (nonatomic, copy, readonly) NSString *MD5;
/// SHA1 加密
@property (nonatomic, copy, readonly) NSString *SHA1;

/// URLencode
@property (nonatomic, copy, readonly) NSString *encodeString;

/// URLdecode
@property (nonatomic, copy, readonly) NSString *decodeString;

#pragma mark - function
/// 适合的高度 默认 font 宽
- (CGFloat)heightWithFont:(NSInteger)font w:(CGFloat)w;

/// 适合的宽度 默认 font 高
- (CGFloat)widthWithFont:(NSInteger)font h:(CGFloat)h;

/// 根据字体大小与最大宽度 返回对应的 size
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/// 计算富(有间距)文本的 NSString 高度
- (CGFloat)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW lineSpacing:(NSInteger)lineSpacing;

/// 根据字体大小 返回对应的 size
- (CGSize)sizeWithFont:(UIFont *)font;

/// 是否包含对应字符
- (BOOL)containStr:(NSString *)subString;

/// 拼上字符串
- (NSString *)addStr:(NSString *)string;

/// 拼上int字符串
- (NSString *)addInt:(int)string;

/// 二维码图片 可以 再用 resize>> 放大一下
- (UIImage *)qrCode;

/// 是否中文
- (BOOL)isChinese;

/// 计算字符串长度 1个中文算2 个字符
- (int)textLength;

/// 限制的最大显示长度字符
- (NSString *)limitMaxTextShow:(NSInteger)limit;

/// 验证邮箱是否合法
- (BOOL)validateEmail;

/// 验证手机号码合法性
- (BOOL)checkPhoneNumInput;

/// 是否ASCII码
- (BOOL)isASCII;

/// 是含本方法定义的 “特殊字符”
- (BOOL)isSpecialCharacter;

/// 验证是否是数字
- (BOOL)isNumber;

/// 是否是纯浮点数  这里也可以拆分成纯数字判断
- (BOOL)isFloat;

/// 验证字符串里面是否都是数字
- (BOOL)isPureNumber;

/// 获取UUID
+ (NSString *)UUID;

@end

NS_ASSUME_NONNULL_END
