//
//  NSObject+PVToast.h
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface UIView (Toast)

@property (nonatomic, strong) NSString *toastStr;

- (void)showToast:(NSString *)str isVoiceCenter:(BOOL)voiceCenter;

@end
