//
//  UIViewController+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/6.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSLandAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GS)

/**
 快速创建 AlertController：包括 Alert 和 ActionSheet
 
 @param title       标题文字
 @param message     消息体文字
 @param actions     可选择点击的按钮（不包括取消）
 @param cancelTitle 取消按钮（可自定义按钮文字）
 @param style       类型：Alert 或者 ActionSheet
 @param completion  完成点击按钮之后的回调（不包括取消）
 */
- (GSLandAlertController *)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion;

@end

NS_ASSUME_NONNULL_END
