//
//  WCHUrlManager.m
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHUrlManager.h"

@implementation WCHUrlManager
+ (NSString *)urlHost
{
//    return @"http://127.0.0.1:3000";  // 本地测试
    return @"http://cocochat.online:3000";  // 阿里云测试
//    return @"http://cocochat.online:2020";  // 阿里云正式
}

+ (BOOL)printToken
{
    return YES;
//    return NO;
}
@end
