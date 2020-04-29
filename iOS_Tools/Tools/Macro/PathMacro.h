//
//  PathMacro.h
//  iOS_Tools
//
//  Created by Gavin.Guo on 2018/1/26.
//  Copyright © 2018年 GSNICE. All rights reserved.
//

#ifndef PathMacro_h
#define PathMacro_h

//MARK: - 获取沙盒 Temp
#define Macro_PathTemp NSTemporaryDirectory()

//MARK: - 获取沙盒 Document
#define Macro_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//MARK: - 获取沙盒 Cache
#define Macro_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#endif /* PathMacro_h */
