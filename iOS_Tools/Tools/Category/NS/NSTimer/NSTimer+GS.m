//
//  NSTimer+GS.m
//  iOS_Tools
//
//  Created by Gavin on 2020/5/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import "NSTimer+GS.h"

@implementation NSTimer (GS)

#pragma mark - scheduled 的初始化方法将以默认 mode 直接添加到当前的 runloop 中。
+ (id)runTimer:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock rep:(BOOL)inRepeats {
    void (^block)(void) = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}
#pragma mark - 不用 scheduled 方式初始化的，需要手动 addTimer:forMode:  将 timer 添加到一个 runloop 中。
// [[NSRunLoop currentRunLoop]addTimer:he forMode:NSDefaultRunLoopMode];
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats {
    void (^block)(void) = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}
+ (void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if ([inTimer userInfo]) {
        void (^block)(void) = (void (^)(void))[inTimer userInfo];
        block();
    }
}

#pragma mark - 暂停
- (void)pause {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

#pragma mark - 继续
- (void)goOn {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

#pragma mark - interval 秒后继续
- (void)goOn:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
