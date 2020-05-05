//
//  NSTimer+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (GS)

/// scheduled 的初始化方法将以默认 mode 直接添加到当前的 runloop 中。
+ (id)runTimer:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock rep:(BOOL)inRepeats;

/// 不用 scheduled 方式初始化的，需要手动 addTimer:forMode: 将 timer 添加到一个 runloop 中。   [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats;

/// 暂停
- (void)pause;

/// 继续
- (void)goOn;

/// interval 秒后继续
- (void)goOn:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
