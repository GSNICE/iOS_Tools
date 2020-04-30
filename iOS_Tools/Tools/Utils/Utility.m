//
//  Utility.m
//  iOS_Tools
//
//  Created by Gavin on 2020/4/5.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import "Utility.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//@import CoreTelephony.CTTelephonyNetworkInfo;
//@import CoreTelephony.CTCarrier;

static CTTelephonyNetworkInfo *NetworkInfo = nil;

@implementation Utility

+ (NSString *)appVersion {
    static NSString * string = nil;
    if (!string.length) {
        string = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
//    NSAssert(string.length, @"不能为空");
    return string;
}
+ (NSString *)appBuildVersion {
    static NSString * string = nil;
    if (!string.length) {
        string = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    }
//    NSAssert(string.length, @"不能为空");
    return string;
}
+ (NSString *)appName {
    static NSString * string = nil;
    if (!string.length) {
        string = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    }
//    NSAssert(string.length, @"不能为空");
    return string;
}
+ (NSString *)bundleIdentifier {
    static NSString * string = nil;
    if (!string.length) {
        string = [[NSBundle mainBundle] bundleIdentifier];
    }
//    NSAssert(string.length, @"不能为空");
    return string;
}
+ (NSString *)idfa {
    NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    return idfa;
}
+ (BOOL)advertisingTrackingEnabled {
    return [ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled;
}
+ (NSString *)identifierForVendor {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}
+ (NSString *)carrierName {
    if (!NetworkInfo) {
        NetworkInfo = CTTelephonyNetworkInfo.new;
    }
    NSString *carrierName = NetworkInfo.subscriberCellularProvider.carrierName;
//    MLCLog(@"menglc carrierName = %@", carrierName);
//    NSAssert(carrierName.length, @"不能为空");
    return carrierName;
}
+ (NSString *)currentRadioAccessTechnology {
    if (!NetworkInfo) {
        NetworkInfo = CTTelephonyNetworkInfo.new;
    }
    NSString *radioAccessTechnology = NetworkInfo.currentRadioAccessTechnology;
    if(radioAccessTechnology == nil) return nil;
    
    NSString *type = nil;
    if([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
        type = @"GPRS";
    }
    else if([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
        type = @"Edge";
    }
    else if([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        type = @"CDMA";
    }
    else if([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        type = @"4G";
    }
    else {
        type = @"3G";
    }
//    NSAssert(type.length, @"不能为空");
    return type;
}
+ (UIEdgeInsets)safeAreaInsets {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = window.safeAreaInsets;
        if (insets.top < 20) {
            insets.top = 20;
        }
        return insets;
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}
+ (void)openURL:(NSURL*)url {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        if ([app canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [app openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            } else {
                [app openURL:url options:nil completionHandler:^(BOOL success) {
                    
                }];
            }
        }
        
    }
}

@end
