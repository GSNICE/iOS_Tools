//
//  UIViewController+GS.m
//  iOS_Tools
//
//  Created by Gavin on 2020/5/6.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import "UIViewController+GS.h"

@implementation UIViewController (GS)

- (GSLandAlertController *)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion {
    GSLandAlertController *alert = [GSLandAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (NSInteger index = 0; index < actions.count; index++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actions[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !completion ?  : completion(index);
        }];
        [alert addAction:action];
    }
    if (cancelTitle.length) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !completion ?  : completion(-1);
        }];
        [alert addAction:cancel];
    }
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end
