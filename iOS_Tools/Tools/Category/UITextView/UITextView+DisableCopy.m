//
//  UITextView+DisableCopy.m
//  HazardousWaste
//
//  Created by Gavin on 2020/4/28.
//  Copyright © 2020 CECEP. All rights reserved.
//

#import "UITextView+DisableCopy.h"

@implementation UITextView (DisableCopy)
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 一旦双击，里面禁用。取消第一响应者，设置不可交互。
//    [self resignFirstResponder];
//    self.userInteractionEnabled = NO;
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }

    return NO;
}
@end
