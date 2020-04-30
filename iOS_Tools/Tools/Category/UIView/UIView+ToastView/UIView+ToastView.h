//
//  UIView+ToastView.h
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ToastView)

- (void)showToast:(CGPoint)point withTopic:(NSString *)topic withSubtitle:(NSString *)subtitle;

- (void)showToast:(CGPoint)point withTopic:(NSString *)topic;

@end

NS_ASSUME_NONNULL_END
