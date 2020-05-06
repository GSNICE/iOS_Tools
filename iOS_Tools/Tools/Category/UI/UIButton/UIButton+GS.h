//
//  UIButton+GS.h
//  iOS_Tools
//
//  Created by Gavin on 2020/5/6.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GSButtonEdgeInsetsStyle) {
    GSButtonEdgeInsetsStyleTop,     // Image在上，Label在下
    GSButtonEdgeInsetsStyleLeft,    // Image在左，Label在右
    GSButtonEdgeInsetsStyleBottom,  // Image在下，Label在上
    GSButtonEdgeInsetsStyleRight    // Image在右，Label在左
};

@interface UIButton (GS)

/**设置点击时间间隔*/

@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(GSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
