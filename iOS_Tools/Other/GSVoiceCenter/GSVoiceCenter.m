//
//  GSVoiceCenter.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "GSVoiceCenter.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const MuteBroadcastVoice_Key = @"MuteBroadcastVoice_Key";

static GSVoiceCenter *center = nil;

@interface GSVoiceCenter ()<AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSMutableArray *queueArray;
@end

@implementation GSVoiceCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[super allocWithZone:NULL] init];
    });
    return center;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultCenter];
}


+ (void)postVoiceString:(NSString *)string
{
    BOOL isMute = [[[NSUserDefaults standardUserDefaults] objectForKey:MuteBroadcastVoice_Key] boolValue];
    if (isMute) {//静音
        return;
    }
    
    if ([self defaultCenter]) {
        
        [[self defaultCenter] postVoice:string isInQueue:NO];
        
    };
}

+ (void)postString:(NSString *)string isInQueue:(BOOL)inQueue
{
    BOOL isMute = [[[NSUserDefaults standardUserDefaults] objectForKey:MuteBroadcastVoice_Key] boolValue];
    if (isMute) {//静音
        return;
    }
    
    if ([self defaultCenter]) {
        
        [[self defaultCenter] postVoice:string isInQueue:inQueue];
        
    };
}

- (void)postVoice:(NSString *)voice isInQueue:(BOOL)inQueue
{
//    BOOL isCancelVoice = [[PVFlightSettingModel defaultFlightSettingModel] isCancelVoiceBroadcast];
//    if ([voice rangeOfString:@"降"].location !=NSNotFound){//解决多音字问题
//        voice=[voice stringByReplacingOccurrencesOfString:@"降"withString:@"酱"];
//    }
//    if (isCancelVoice) {
//        return;
//    }
    if (self.closeVoice) {
        return;
    }
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc]init];
    }
    
    if (!inQueue || (inQueue && !_synthesizer.isSpeaking)) {
        if (_synthesizer.isSpeaking) {
            [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:voice];
        utterance.volume = 1;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            utterance.rate = 0.53f;
        }else{
            utterance.rate = 0.25f;
        }
        
        [_synthesizer speakUtterance:utterance];
        
    }else{
        
        if (!_queueArray) {
            _queueArray = [NSMutableArray array];
        }
        
        _synthesizer.delegate = self;
        [_queueArray addObject:voice];
    }
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if (_queueArray && _queueArray.count) {
        AVSpeechUtterance *newUtterance = [[AVSpeechUtterance alloc] initWithString:[_queueArray firstObject]];
        newUtterance.volume = 1;
        newUtterance.rate = utterance.rate;
        [_synthesizer speakUtterance:newUtterance];
        [_queueArray removeObjectAtIndex:0];
    }
}


@end
