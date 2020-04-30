//
//  GSVoiceCenter.h
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSVoiceCenter : NSObject

+ (instancetype)defaultCenter;

/**
 语音播报

 @param string 播报文本
 */
+ (void)postVoiceString:(NSString *)string;

/**
 语音播报

 @param string 播报文本
 @param inQueue 是否加入队列
 */
+ (void)postString:(NSString *)string isInQueue:(BOOL)inQueue;

/**
 关闭语音播报
 */
@property (nonatomic,assign)BOOL closeVoice;


@end
