//
//  NSArray+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (GS)

/// 返回成员变量为 String 的元素下标
- (NSInteger)indexOfString:(NSString *_Nullable)string;

/// 安全访问数组下标元素（可防止数组越界）
- (nullable id)safetyObjectAtIndex:(NSUInteger)index;

/// 检查是否越界和 NSNull 如果是返回 nil
- (id)objectAtIndexCheck:(NSUInteger)index;

/// 是否真是数组 [self isKindOfClass:[NSArray class]]
@property (nonatomic, assign, readonly) BOOL isAClass;

/// 数组 转为 JsonStr
@property (nonatomic, copy, readonly) NSString *jsonStr;

/// 根据一个字符串来将数组连接成一个新的字符串，这里根据逗号
@property (nonatomic, copy, readonly) NSString *combinStr;

/// 将接收返回的数组按【字段】进行排序
- (NSArray *)sortbyKey:(NSString *)key asc:(BOOL)ascend;

/// 数组比较
- (BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array;

/// 数组计算交集
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/// 数组计算差集
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray;


@end

NS_ASSUME_NONNULL_END
