//
//  UIView+ToastView.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "UIView+ToastView.h"
#import <Masonry/Masonry.h>
#import "ColorMacro.h"
#import "UIView+Extension.h"
#import "UIViewExt.h"
#import "LayoutMacro.h"
#import "UIUtils.h"


@implementation UIView (ToastView)

- (void)showToast:(CGPoint)point withTopic:(NSString *)topic withSubtitle:(NSString *)subtitle
{
    __block UIView *toastBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    toastBottomView.backgroundColor = Macro_COLORA_Hex(0X000000, 0.6);
    [self addSubview:toastBottomView];
    [toastBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, CGRectGetWidth(toastBottomView.frame), 20)];
    topicLabel.text = topic;
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.textColor = [UIColor whiteColor];
    topicLabel.adjustsFontSizeToFitWidth = YES;
    topicLabel.font = [UIFont systemFontOfSize:20.0];
    [toastBottomView addSubview:topicLabel];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(toastBottomView);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toastBottomView.frame)-17, toastBottomView.frame.size.width, 20)];
    subtitleLabel.text = subtitle;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont systemFontOfSize:12.0];
    [toastBottomView addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(toastBottomView);
        make.bottom.mas_equalTo(-16);
        make.height.mas_equalTo(20);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastBottomView removeFromSuperview];
        toastBottomView = nil;
    });

}

- (void)showToast:(CGPoint)point withTopic:(NSString *)topic
{
    __block UIView *toastBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    toastBottomView.backgroundColor = Macro_COLORA_Hex(0X000000, 0.6);
    [self addSubview:toastBottomView];
    
    UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(toastBottomView.frame)-20)/2, CGRectGetWidth(toastBottomView.frame), 20)];
    topicLabel.text = topic;
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.adjustsFontSizeToFitWidth = YES;
    topicLabel.textColor = [UIColor whiteColor];
    topicLabel.numberOfLines = 0;
    topicLabel.font = [UIFont systemFontOfSize:20.0];
    topicLabel.minimumScaleFactor = 0.7;
    [toastBottomView addSubview:topicLabel];
    float toastWidth = 160;
    float width = [UIUtils getSizeWithLabel:topic withFont:topicLabel.font withSize:CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT)].width;
    if (width >= toastBottomView.width) {
        toastWidth = SCREEN_WIDTH - 2*30;
    }
    [toastBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(toastWidth);
        make.height.mas_equalTo(80);
    }];
    
    
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(toastBottomView);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastBottomView removeFromSuperview];
        toastBottomView = nil;
    });
}

@end
