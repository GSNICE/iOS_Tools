//
//  NSArray+Enum.h
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Enum)

- (NSInteger)indexOfString:(NSString *_Nullable)string;

/// 安全访问数组下标元素（可防止数组越界）
- (nullable id)safetyObjectAtIndex:(NSUInteger)index;

@end
