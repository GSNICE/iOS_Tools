//
//  GSLandAlertController.m
//  GSNICE
//
//  Created by Gavin on 2017/8/8.
//  Copyright © 2017 GSNICE. All rights reserved.
//

#import "GSLandAlertController.h"

@interface GSLandAlertController ()

@end

@implementation GSLandAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate{
    //是否允许转屏
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if([UIApplication sharedApplication].statusBarOrientation== UIInterfaceOrientationLandscapeLeft ||
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        return [UIApplication sharedApplication].statusBarOrientation;
    else
        return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}

@end
