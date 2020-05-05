//
//  NSObject+PVToast.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "NSObject+Toast.h"
#import "GSVoiceCenter.h"
#import <objc/message.h>

static NSString *toastStrKey  = @"toastStrKey";

@implementation UIView (Toast)

- (void)showToast:(NSString *)str isVoiceCenter:(BOOL)voiceCenter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.toastStr = str;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showToast) object:nil];//先取消前一次的操作
        [self performSelector:@selector(showToast)withObject:nil afterDelay:0.2f];
    });
    if (voiceCenter) {
        [GSVoiceCenter postString:str isInQueue:NO];
    }
}

- (void)showToast
{
    [self makeToast:self.toastStr duration:3 position:[NSValue valueWithCGPoint:self.center]];
}

-(void)setToastStr:(NSString *)str
{
    objc_setAssociatedObject(self, &toastStrKey, str, OBJC_ASSOCIATION_COPY);
}

-(NSString *)toastStr
{
    return objc_getAssociatedObject(self, &toastStrKey);
}


@end
