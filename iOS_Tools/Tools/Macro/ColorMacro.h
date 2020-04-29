//
//  ColorMacro.h
//  iOS_Tools
//
//  Created by Gavin.Guo on 2018/1/26.
//  Copyright © 2018年 GSNICE. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

//MARK: - 设置RGB颜色
#define Macro_ColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//MARK: - 设置RGBA颜色
#define Macro_Color_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//MARK: - 十六进制色值
#define Macro_COLOR_Hex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//MARK: - 十六进制色值+透明度
#define Macro_COLORA_Hex(rgbValue,alph) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alph]

//MARK: - 设置随机颜色
#define Macro_RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//MARK: - Clear 背景颜色
#define Macro_ClearColor [UIColor clearColor]

#endif /* ColorMacro_h */
