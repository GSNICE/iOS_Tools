//
//  GSUlUtils.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVKit/AVKit.h>
#import <CoreLocation/CoreLocation.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8

#define FEET_CONVERSION 0.3048 //1 foot = 0.3048 m

@implementation UIUtils

#pragma mark - 获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

#pragma mark - 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)dateStringFromTimeStr:(NSString *)str formate:(NSString *)formate{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formate];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

#pragma mark - 将日期格式化为 NSString 对象
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *datestring = [dateFormatter stringFromDate:date];
    return datestring;
}

+ (NSDate *)dateFromString:(NSString *)string formate:(NSString *)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:formate];
	NSDate *resDate = [formatter dateFromString:string];
	return resDate;
}

#pragma mark - 将当前时间转成北京时间
+ (NSDate *)timeZoneToDate:(NSDate *)nowDate
{
	//获取本地时区(中国时区)
	NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
	//计算世界时间与本地时区的时间偏差值
	NSInteger offset = [localTimeZone secondsFromGMTForDate:nowDate];
	//世界时间＋偏差值 得出中国区时间
	NSDate *localDate = [nowDate dateByAddingTimeInterval:offset];
	return localDate;
}

#pragma mark - 将日期转化为今天，昨天等
+ (NSString *)compareDate:(NSDate *)date
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    today = [UIUtils timeZoneToDate:today];
    NSDate *tomorrow, *yesterday;
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    // 10 first characters of description is the calendar date:
    if ([today description].length <= 10 ||
        [yesterday description].length <= 10 ||
        [tomorrow description].length <= 10 ||
        [date description].length > 10) {
        return @"Error Date!";
    }
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
    
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

/**
 *  获取文件大小
 *  @param path 文件路径
 *  @return 文件大小
 *
 */
+ (long long)fileSizeForPath:(NSString *)path {
	
	long long fileSize = 0;
	NSFileManager *fileManager = [NSFileManager new]; // not thread safe
	if ([fileManager fileExistsAtPath:path]) {
		NSError *error = nil;
		NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
		if (!error && fileDict) {
			fileSize = [fileDict fileSize];
		}
	}
	return fileSize;
}

/**
 *  校验图片是否为有效的PNG图片
 *
 *  @param imageData 图片文件直接得到的NSData对象
 *
 *  @return 是否为有效的PNG图片
 */
+ (BOOL)isValidPNGByImageData:(NSData*)imageData
{
    UIImage* image = [UIImage imageWithData:imageData];
    //第一种情况：通过[UIImage imageWithData:data];直接生成图片时，如果image为nil，那么imageData一定是无效的
    if (image == nil && imageData != nil) {
        
        return NO;
    }
    
    //第二种情况：图片有部分是OK的，但是有部分坏掉了，它将通过第一步校验，那么就要用下面这个方法了。将图片转换成PNG的数据，如果PNG数据能正确生成，那么这个图片就是完整OK的，如果不能，那么说明图片有损坏
    NSData* tempData = UIImagePNGRepresentation(image);
    if (tempData == nil) {
        return NO;
    } else {
        return YES;
    }
}

/**
 验证图片是否为完整的JPG图片

 @param jpeg 图片资源
 @return 0表示成功   其他表示失败
 */
+ (int)isJPEGValid:(NSData *)jpeg {
    if ([jpeg length] < 4) return 1;
    const unsigned char * bytes = (const unsigned char *)[jpeg bytes];
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return 2;
    if (bytes[[jpeg length] - 2] != 0xFF ||
        bytes[[jpeg length] - 1] != 0xD9) return 3;
    return 0;
}

+ (UIColor *)transferHEXToRGB:(NSString *)HEX
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[HEX substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[HEX substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[HEX substringWithRange:range]]scanHexInt:&blue];
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return color;
}


/**描述：将数组中元素进行排序
 参数：ascending:yes 正序 no为倒叙
 */
+ (NSArray *)sortArray:(NSArray *)dataArray withKey:(NSString *)key ascending:(BOOL)ascending {
    if (!dataArray || !key) {
        return nil;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    return sortArray;
}

+ (long long)countDirectorySize:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取到目录下面所有的文件名
    NSArray *fileNames = [fileManager subpathsOfDirectoryAtPath:directory error:nil];
    
    long long sum = 0;
    for (NSString *fileName in fileNames) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        
        NSDictionary *attribute = [fileManager attributesOfItemAtPath:filePath error:nil];
        
        //        NSNumber *filesize = [attribute objectForKey:NSFileSize];
        long long size = [attribute fileSize];
        
        sum += size;
    }
    
    return sum;
}

/**描述：获取手机总存储空间大小
 *  @return 手机存储空间大小
 */
+ (float)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
   long long space =  [[fattributes objectForKey:NSFileSystemSize] longLongValue];
    float spaceFloat = space/1024.0/1024/1024;
    return spaceFloat;
}

/**描述：获取手机可用存储空间大小
 *  @return 手机存储空间大小
 */
+ (float)freeDiskSpace
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace/1024.0/1024/1024.0;
}

/**描述：判断当前字符是否为数字
 *
 */
+ (BOOL)isValidateNumber:(NSString *)inputString
{
    NSString *regex = @"(-)?[\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:inputString];
}

+ (BOOL)isValidaString:(NSString *)inputString
{
//    NSRegularExpression *regexNumberOrEnglishChar = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]+$" options:0 error:nil];
    NSString *regex = @"^[A-Za-z0-9_]+$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[\u4e00-\u9fa5]"];
    return [pred evaluateWithObject:inputString];
}

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}


#pragma mark - 获取 Label 的高度和宽度
+ (CGSize)getSizeWithLabel:(NSString *)des withFont:(UIFont *)font withSize:(CGSize)size
{
    if (![des isMemberOfClass:[NSNull class]]) {
        // iOS6使用的方法
        UIDevice *device = [UIDevice currentDevice];
        if ([device.systemVersion floatValue] >= 6.0) {
            CGSize textSize = [des sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];//MAXFLOAT
            return textSize;
        } else {
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize finalSize = CGSizeMake(size.width, MAXFLOAT);
            //iOS7中提供的计算文本尺寸的方法
            CGSize textSize1 = [des boundingRectWithSize:finalSize options:NSStringDrawingUsesLineFragmentOrigin |
                                NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
            return textSize1;
        }
        return size;
    }
    return CGSizeZero;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

#pragma mark - 获取手机型号
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",deviceString);
    free(machine);
    //未考虑iPhone3等较老设备，未考虑iPad设备（公司的应用不支持iPad）
    if ([deviceString hasPrefix:@"iPhone3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString hasPrefix:@"iPhone6"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //如果没有匹配直接返回系统提供的类似@iPhone5,3这种型号
    return deviceString;
}

+ (NSString *)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;

}

/**
 改变String中某些文字的颜色和字体
 
 @param content 原文字
 @param search 需要改变颜色和字体的文字
 @param font 字体大小
 @param color 颜色
 @return 返回属性字符串
 */
+ (NSMutableAttributedString *)stringFromContent:(NSString *)content Search:(NSString *)search font:(UIFont *)font color:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = [content rangeOfString:search];
    if (range.location == NSNotFound) {
        return str;
    }
    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, range.location)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    //    NSRange tempRange = NSMakeRange(range.location+range.length, str.length-(range.location+range.length));
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:tempRange];
    
    return str;
}

#pragma mark - 获取当前设备的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}


/**
 是否是合法的手机号

 @param patternStr  手机号
 @return 结果
 */
+ (BOOL)isPhoneNumber:(NSString *)patternStr
{
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}


/**
 是否是合法的邮箱

 @param patternStr 邮箱
 @return 结果
 */
+ (BOOL)detectionIsEmailQualified:(NSString *)patternStr
{
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}


/**
 计算目录下文件大小

 @param filePath 文件路径
 @return 文件大小
 */
+ (NSInteger)fileSize:(NSString *)filePath {
    //文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断字符串是否为文件/文件夹
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:filePath isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) return 0;
    //self是文件夹
    if (dir){
        //遍历文件夹中的所有内容
        NSArray *subpaths = [mgr subpathsAtPath:filePath];
        //计算文件夹大小
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths){
            //拼接全路径
            NSString *fullSubPath = [filePath stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO){//是文件
//                NSDictionary *attr = [mgr attributesOffItemAtPath:fullSubPath error:ni];
               NSDictionary *attr = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                totalByteSize += [attr[NSFileSize] integerValue];
            }
            return totalByteSize;
        }
    } else {//是文件
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        return [attr[NSFileSize] integerValue];
    }
    return 0;
}

/**
 创建目录
 
 @param dirName 目录名
 @return 目录地址
 */
+ (NSString *)createDirectoryPath:(NSString *)dirName
{
    NSString *directory = [[UIUtils getDocumentPath] stringByAppendingPathComponent:dirName];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directory;
}


+ (NSString *)getDocumentPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documents[0];
    return documentPath;
}

#pragma mark - 将秒数转换成时间字符串，格式为00:00:00
+ (NSString*)stringFromSeconds:(float)seconds withHour:(BOOL)isHour
{
    int hour = seconds / 3600;
    int minute = seconds / 60 - hour * 60;
    int second = ceil(seconds - minute * 60 - hour * 3600);
    NSString *result=@"";
    if (isHour) {
        result=[NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    }
    else{
        result=[NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    
    return result;
}


/**
 16进制转10进制

 @param aHexString 十六进制字符串
 @return 十进制
 */
+ (NSNumber *)numberHexString:(NSString *)aHexString
{
	// 为空,直接返回.
	if (nil == aHexString)
	{
		return nil;
	}
	
	NSScanner * scanner = [NSScanner scannerWithString:aHexString];
	unsigned long long longlongValue;
	[scanner scanHexLongLong:&longlongValue];
	
	//将整数转换为NSNumber,存储到数组中,并返回.
	NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
	
	return hexNumber;
}


/**
 将十进制数转换成十六进制数

 @param tmpid 十进制数
 @return 十六进制数
 */
+ (NSString *)ToHex:(long long int)tmpid
{
	NSString *nLetterValue;
	NSString *str =@"";
	long long int ttmpig;
	for (int i = 0; i<9; i++) {
		ttmpig=tmpid%16;
		tmpid=tmpid/16;
		switch (ttmpig)
		{
			case 10:
				nLetterValue =@"A";break;
			case 11:
				nLetterValue =@"B";break;
			case 12:
				nLetterValue =@"C";break;
			case 13:
				nLetterValue =@"D";break;
			case 14:
				nLetterValue =@"E";break;
			case 15:
				nLetterValue =@"F";break;
			default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
				
		}
		str = [nLetterValue stringByAppendingString:str];
		if (tmpid == 0) {
			break;
		}
  
	}
	return str;
}

/**
 获取文件MD5校验码

 @param path 文件的路径
 @return MD5校验码
 */
+ (NSString *)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)fileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}



CFStringRef fileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {

    // Declare needed variables

    CFStringRef result = NULL;

    CFReadStreamRef readStream = NULL;

    // Get the file URL

    CFURLRef fileURL =

    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,

                                  (CFStringRef)filePath,

                                  kCFURLPOSIXPathStyle,

                                  (Boolean)false);

    if (!fileURL) goto done;

    // Create and open the read stream

    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,

                                            (CFURLRef)fileURL);

    if (!readStream) goto done;

    bool didSucceed = (bool)CFReadStreamOpen(readStream);

    if (!didSucceed) goto done;

    // Initialize the hash object

    CC_MD5_CTX hashObject;

    CC_MD5_Init(&hashObject);

    // Make sure chunkSizeForReadingData is valid

    if (!chunkSizeForReadingData) {

        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;

    }

    // Feed the data to the hash object

    bool hasMoreData = true;

    while (hasMoreData) {

        uint8_t buffer[chunkSizeForReadingData];

        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));

        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {

            hasMoreData = false;

            continue;

        }

        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);

    }

    // Check if the read operation succeeded

    didSucceed = !hasMoreData;

    // Compute the hash digest

    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5_Final(digest, &hashObject);

    // Abort if the read operation failed

    if (!didSucceed) goto done;

    // Compute the string result

    char hash[2 * sizeof(digest) + 1];

    for (size_t i = 0; i < sizeof(digest); ++i) {

        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));

    }
    //801f85cf1ac4239ae6eea8b298af630b
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);



done:

    if (readStream) {

        CFReadStreamClose(readStream);

        CFRelease(readStream);

    }

    if (fileURL) {

        CFRelease(fileURL);

    }

    return result;

}

/**
 将十六进制字符串转化为NSData
 
 @param str 十六进制字符串
 @return data
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
	if (!str || [str length] == 0) {
		return nil;
	}
	
	NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
	NSRange range;
	NSInteger cLocation = 0;
	range = NSMakeRange(0, 2);
	for (NSInteger i = cLocation; i < [str length]; i += 2) {
		if (str.length - cLocation == 0) {
			break;
		}
		if (str.length - cLocation < 2) {
			range.length = 1;
		} else {
			range.length = 2;
		}
		range.location = cLocation;
		unsigned int anInt;
		NSString *hexCharStr = [str substringWithRange:range];
		NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
		
		[scanner scanHexInt:&anInt];
		NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
		[hexData appendData:entity];
		
		cLocation = cLocation + range.length;
	}
	return hexData;
}


/**
 将十六进制data转为十六进制字符串
 
 @param data 十六进制data
 @return 十六进制字符串
 */
+ (NSString *)convertDataToHexStr:(NSData *)data {
	if (!data || [data length] == 0) {
		return @"";
	}
	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
	
	[data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
		unsigned char *dataBytes = (unsigned char*)bytes;
		for (NSInteger i = 0; i < byteRange.length; i++) {
			NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
			if ([hexStr length] == 2) {
				[string appendString:hexStr];
			} else {
				[string appendFormat:@"0%@", hexStr];
			}
		}
	}];
	
	return string;
}


/**
 比较声呐本地版本和服务器版本，判断是否可以升级
 
 @param serviceVersion 服务器版本
 @param localVersion 本地版本
 @return 是否可以升级
 */
+ (BOOL)compareSonarVersion:(NSString *)serviceVersion withLocalVersion:(NSString *)localVersion
{
	BOOL isUpgrade = NO;
	NSString *subServiceVersion = [serviceVersion substringWithRange:NSMakeRange(serviceVersion.length - 6, 6)];
	NSString *subLocalVersion = [localVersion substringWithRange:NSMakeRange(localVersion.length - 6, 6)];
	if (![subLocalVersion isEqualToString:subServiceVersion]) {
		isUpgrade = YES;
	}
	return isUpgrade;
}


/**
 根据颜色值生成纯色图片

 @param color 色值
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 改变图片颜色

 @param image 原图片
 @param color 颜色
 @return 新图片
 */
+ (UIImage *)changeImage:(UIImage *)image wiithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 压缩图片质量和压缩图片尺寸结合
 如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
 https://www.cnblogs.com/silence-cnblogs/p/6346729.html
 
 @param
 @return
 */
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

/**
 获取当前系统时间，将系统时间转为海思特定格式时间字符串
 sysTime 年+月+日+时+分+秒 20170315144700
 
 @return 海思特定格式时间字符串
 */
+ (NSString *)getSystemTime {
    
    //    NSDate *date = [NSDate date]; // 获得时间对象
    ////    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    ////    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    ////    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    //
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    //
    //    long year = [dateComponent year];
    //    long month =  [dateComponent month];
    //    long day = [dateComponent day];
    //    long hour =  [dateComponent hour];
    //    long minute =  [dateComponent minute];
    //    long second = [dateComponent second];
    //
    //    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld%02ld%02ld%02ld", (long)year, (long)month, (long)day, (long)hour, (long)minute, (long)second];
    //    NSLog(@"最后年月日时分秒拼接的结果=====%@",timeStr);
    //
    //    return timeStr;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}


/**
 Url编码
 
 @param str 原Url
 @return 编码之后的Url
 */
+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (id)dictFromJson:(id)str {
    id resultDic;
    if ([str isKindOfClass:[NSDictionary class]]) {
        resultDic = str;
    }
    else if ([str rangeOfString:@"{"].length){ //json串
        resultDic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    }
    else { //字符串
        resultDic = str;
    }
    
    return resultDic;
}

/**
 将UIView类转UIImage;完美解决失真模糊
 
 @param
 @return
 */
+ (UIImage*)convertViewToImage:(UIView*)v {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 将海思时间字符串转换为NSDate
 
 @param dateStr 时间字符串
 @return 日期
 */
+ (NSDate *)dateFromString:(NSString *)dateStr
{
    //格式：20180121105213
    if (dateStr.length!=14) {
        return nil;
    }
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    NSString *hours = [dateStr substringWithRange:NSMakeRange(8, 2)];
    NSString *minutes = [dateStr substringWithRange:NSMakeRange(10, 2)];
    NSString *seconds = [dateStr substringWithRange:NSMakeRange(12, 2)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 要转换的日期字符串 格式：@"2011-05-03 23:11:40";
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", year, month, day, hours, minutes, seconds];
    
    // 设置为UTC时区
    // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:timezone];
    // 设置日期格式(为了转换成功)
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

#pragma mark --- 获取WiFi信息
//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
+ (NSDictionary *)fetchSSIDInfo{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

+ (NSString *)getWIFIName
{
    NSString *wifiName = nil;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo((CFStringRef)CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
            
        }
    }
    return wifiName;
}

#pragma mark - 播放音频文件
+ (void)playAudio:(NSString *)audioName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:audioName withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - 获取 WIFI 信号强度
+ (int)getSignalStrength
{
    if (@available(iOS 13, *)) {
        return 3;
    }else{
        UIApplication *app =[UIApplication sharedApplication];
        
        if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:
             NSClassFromString(@"UIStatusBar_Modern")]) {
            NSString *wifiEntry =[[[
                                    [app valueForKey:@"statusBar"]
                                    valueForKey:@"_statusBar"]
                                   valueForKey:@"_currentAggregatedData"]
                                  valueForKey:@"_wifiEntry"];
            
            int signalStrength =[[wifiEntry valueForKey:@"_displayValue"]intValue];
            return signalStrength;
        }
        else{
            NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
            NSString *dataNetworkItemView = nil;
            
            for (id subview in subviews) {
                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    dataNetworkItemView = subview;
                    break;
                }
            }
            
            int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
            return signalStrength;
        }
    }
}


/**
 将时间秒数转化为时分秒

 @param seconds 时间秒数
 @param isHour 是否显示小时
 @return 返回时分秒字符串
 */
- (NSString*)stringFromSeconds:(float)seconds withHour:(BOOL)isHour
{
	int hour = seconds / 3600;
	int minute = seconds / 60 - hour * 60;
	int second = ceil(seconds - minute * 60 - hour * 3600);
	NSString *result=@"";
	if (isHour) {
		result=[NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
	}
	else{
		result=[NSString stringWithFormat:@"%02d:%02d", minute, second];
	}
	
	return result;
}

/**
 获取视频分辨率
 
 @param videoPath 视频路径
 @return 返回视频尺寸 单位为
 */
+ (CGSize)getVideoResolution:(NSString *)videoPath
{
	//获取视频尺寸
	AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
	NSArray *array = asset.tracks;
	CGSize videoSize = CGSizeZero;
	
	for (AVAssetTrack *track in array) {
		if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
			videoSize = track.naturalSize;
		}
	}
	return videoSize;
}


/**
 获取视频时长

 @param videoPath 视频路径
 @return 视频时长，单位为秒
 */
+ (NSInteger)getVideoDuration:(NSString *)videoPath
{
	AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
	CMTime   time = [asset duration];
	int seconds = ceil(time.value/time.timescale);
	return seconds;
}

+ (NSString*)jsonStringFromObject:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (id)jsonStringToDictOrArray:(NSString *)jsonString
{
    NSError *error = nil;
    NSData *jsonData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

/**
 获取目录下的文件夹的名字

 @param directory 文件目录
 @return 文件夹下的文件列表
 */
+ (NSArray *)arrayOfDirectory:(NSString *)directory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:directory error:&error];
    return fileList;
}

/**
 给 View 设置渐变色
 @param view 需要设置渐变色的 view
 @param startColor 开始原色
 @param endColor 结束原色
 @param startPoint 开始点
 @param endPoint 结束点
*/
+ (void)setGradientOfView:(UIView *)view withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint
{
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //  设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    [view.layer insertSublayer:gradient atIndex:0];
}

/**
 给 View 设置圆角边框
 @param view 需要设置圆角的view
 @param lineWidth 边框线宽度
 @param strokeColor strokeColor
 @param fillColor fillColor
 @param radius 圆角大小
*/
+ (void)setBoardlineOfView:(UIView *)view withLineWidth:(float)lineWidth withStrokeColor:(UIColor *)strokeColor withFillColor:(UIColor *)fillColor withCornerRadius:(float)radius{
    //  使用贝塞尔曲线实现圆角边框
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = view.bounds;
    borderLayer.lineWidth = lineWidth;
    borderLayer.strokeColor = strokeColor.CGColor;
    borderLayer.fillColor = fillColor.CGColor;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:radius];
    borderLayer.path = bezierPath.CGPath;
    [view.layer insertSublayer:borderLayer atIndex:0];
}

/**
 给 View 设置圆角
 
 @param view 需要设置圆角的view
 @param size 圆角的大小尺寸
 @param rectCorners 圆角的类型
 */
+ (void)setCornerOfView:(UIView *)view withSize:(CGSize)size withRectCorners:(UIRectCorner)rectCorners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = view.bounds;
    view.layer.mask = maskLayer;
}


/**
 将 UIView 转换成一个 UIImage 对象

 @param view 需要截屏转换的 View
 @return 转换之后的UIImage
 */
+ (UIImage *)transferViewToImage:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 将图片裁剪成圆形图片

 @param radius 圆形图片的半径
 @param imageSize 图片大小
 @param image 原图片
 @return 裁剪之后的图片
 */
+ (UIImage*)cutImageWithRadius:(int)radius withImageSize:(CGSize)imageSize withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+imageSize.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+imageSize.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, imageSize.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, imageSize.width, imageSize.height), image.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

/**
 大文件拷贝，将大文件从 fromPath 拷贝到 toPath

 @param fromPath 源文件路径
 @param toPath 目标文件路径
 @param block 拷贝完成的回调
 */
+ (void)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath withCompletion:(void(^)(BOOL result))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:fromPath]) {
                return;
            }
            [fileManager createFileAtPath:toPath contents:nil attributes:nil];
            //打开源文件和目标文件
            NSFileHandle *oriFile = [NSFileHandle fileHandleForReadingAtPath:fromPath];
            NSFileHandle *finFile = [NSFileHandle fileHandleForWritingAtPath:toPath];
            //获取源文件大小，利用fileManager先获取文件属性，然后提取属性里面的文件大小，属性是一个字典，然后再把文件大小转化成整形
            NSDictionary *oriAttr = [fileManager attributesOfItemAtPath:fromPath error:nil];
            NSNumber *fileSize0=[oriAttr objectForKey:NSFileSize];
            NSInteger fileSize=[fileSize0 longValue];
            //先设定已读文件大小为0，和一个while判断值
            NSInteger fileReadSize=0;
            BOOL isEnd=YES;
            while (isEnd) {
                @autoreleasepool {
                    NSInteger sublength=fileSize-fileReadSize;//判断还有多少未读
                    NSData *data=nil;//先设定个空数据
                    if (sublength<=500) { //如果未读的数据少于500字节那么全都读取出来，并结束while循环
                        isEnd=NO;
                        data=[oriFile readDataToEndOfFile];
                    }else{
                        data=[oriFile readDataOfLength:500];//如果未读的大于500字节，那么读取500字节
                        fileReadSize+=500;//把已读的加上500字节
                        [oriFile seekToFileOffset:fileReadSize];//把光标定位在已读的末尾
                    }
                    [finFile writeData:data];//把以上存在data中得数据写入到目标文件中
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    });
}

#pragma mark - 获取App的相关信息  版本号，build版本号，手机系统版本等
+ (NSDictionary *)getAppDetailInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    return infoDictionary;
}

@end
