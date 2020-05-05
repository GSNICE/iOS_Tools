//
//  UIButton+ImageTitleSpacing.h
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/28/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ITSButtonEdgeInsetsStyle) {
    ITSButtonEdgeInsetsStyleTop,     // Image在上，Label在下
    ITSButtonEdgeInsetsStyleLeft,    // Image在左，Label在右
    ITSButtonEdgeInsetsStyleBottom,  // Image在下，Label在上
    ITSButtonEdgeInsetsStyleRight    // Image在右，Label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ITSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
