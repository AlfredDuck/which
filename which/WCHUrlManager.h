//
//  WCHUrlManager.h
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCHUrlManager : NSObject
+ (NSString *)urlHost;
+ (BOOL)printToken;  // 微博登录时打印token，方便获取新的token
@end
