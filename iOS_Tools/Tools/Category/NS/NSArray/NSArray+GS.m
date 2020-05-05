//
//  NSArray+GS.m
//  iOS_Tools
//
//  Created by Gavin on 2020/5/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import "NSArray+GS.h"

@implementation NSArray (GS)

#pragma mark - 返回成员变量为 String 的元素下标
- (NSInteger)indexOfString:(NSString *)string
{
    NSInteger idx = -1;
    for (NSString *str in self) {
        if ([string isEqualToString:str]) {
            idx = [self indexOfObject:str];
            break;
        }
    }
    return idx;
}

#pragma mark - 安全访问数组下标元素（可防止数组越界）
- (nullable id)safetyObjectAtIndex:(NSUInteger)index
{
    if (!self || self.count == 0 || self.count <= index) {
        return nil;
    }
    
    return self[index];
}

#pragma mark - 检查是否越界和 NSNull 如果是返回 nil
- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index < self.count) {
        return self[index];
    } else {
        //数组越界了就返回nil
        return nil;
    }
}

#pragma mark - 是否真是数组 [self isKindOfClass:[NSArray class]]
- (BOOL)isAClass
{
    return [self isKindOfClass:[NSArray class]];
}

#pragma mark - 数组 转为 JsonStr
- (NSString *)jsonStr
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:NULL] encoding:NSUTF8StringEncoding];
}

#pragma mark - 根据一个字符串来将数组连接成一个新的字符串，这里根据逗号
- (NSString *)combinStr
{
    return [self componentsJoinedByString:@","];
}

#pragma mark - 请接收返回的数组 按 字段 给数组排序
- (NSArray *)sortbyKey:(NSString *)key asc:(BOOL)ascend
{
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascend]]];
}

#pragma mark 数组比较
- (BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array
{
    NSSet *set1 = [NSSet setWithArray:self];
    NSSet *set2 = [NSSet setWithArray:array];
    return [set1 isEqualToSet:set2];
}

#pragma mark - 数组计算交集
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray
{
    NSMutableArray *intersectionArray = [NSMutableArray array];
    if (self.count == 0) return nil;
    if (otherArray == nil) return nil;
    //遍历
    for (id obj in self) {
        if (![otherArray containsObject:obj]) continue;
        //添加
        [intersectionArray addObject:obj];
    }

    return intersectionArray;
}

#pragma mark - 数组计算差集
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray
{
    if (self == nil) return nil;
    if (otherArray == nil) return self;
    NSMutableArray *minusArray = [NSMutableArray arrayWithArray:self];
    //遍历
    for (id obj in otherArray) {
        if (![self containsObject:obj]) continue;
        //移除
        [minusArray removeObject:obj];
    }
    return minusArray;
}

@end
