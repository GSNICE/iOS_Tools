//
//  NSArray+Enum.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "NSArray+Enum.h"

@implementation NSArray (Enum)

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

@end
