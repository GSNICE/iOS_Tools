//
//  UIImage+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/6.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GS)

+ (nullable UIImage *)imageFromColor: (nonnull UIColor *)color withSize:(CGSize)size;

+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nullable)color
                        cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *_Nullable) buttonImageWithColor:(UIColor *_Nullable)color
                               cornerRadius:(CGFloat)cornerRadius
                                shadowColor:(UIColor *_Nullable)shadowColor
                               shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *_Nullable) circularImageWithColor:(UIColor *_Nullable)color
                                size:(CGSize)size;

- (UIImage *_Nullable) imageWithMinimumSize:(CGSize)size;

+ (UIImage *_Nullable) stepperPlusImageWithColor:(UIColor *_Nullable)color;
+ (UIImage *_Nullable) stepperMinusImageWithColor:(UIColor *_Nullable)color;

+ (UIImage *_Nullable) backButtonImageWithColor:(UIColor *_Nullable)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *_Nullable)addImage:(UIImage *_Nullable)useImage addMainImage:(UIImage *_Nullable)mainImage addMsakImage:(UIImage *_Nullable)maskImage withMainImage:(CGRect)mainRect withMaskRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
