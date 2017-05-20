//
//  WCHUserDefault.m
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHUserDefault.h"

@implementation WCHUserDefault

/* 记录是否展示过push授权说明页面 */
+ (void)recordPushAuthorityIntroduction {
    // 记录
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"done" forKey:@"pushAuthorityIntroduction"];
}

+ (BOOL)hasShowPushAuthorityIntroduction {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *install = [ud stringForKey:@"pushAuthorityIntroduction"];
    if (install) {
        return YES;
    } else {
        return NO;
    }
}


/* 读写本地token */
+ (NSString *)readDeviceToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [ud stringForKey:@"deviceToken"];
    return deviceToken;
}

+ (BOOL)recordDeviceToken:(NSString *)deviceToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:deviceToken forKey:@"deviceToken"];
    return YES;
}


/* push权限 */
+ (BOOL)isPushAllowed {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *pa = [ud stringForKey:@"pushAuthority"];
    if (pa) {
        NSLog(@"push权限开启");
        return YES;
    } else {
        NSLog(@"push权限关闭");
        return NO;
    }
}

+ (void)pushAuthorityIsOpen {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"mmd" forKey:@"pushAuthority"];
}

+ (void)pushAuthorityIsClose {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"pushAuthority"];
}


#pragma mark - 登录/账户相关
/* 登录注册or退出登录 */
+ (BOOL)recordLoginInfo:(NSDictionary *)loginInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:loginInfo[@"uid"] forKey:@"uid"];  // 用户id，微博用户就是微博id，邮箱用户就是邮箱地址
    [ud setObject:loginInfo[@"user_type"] forKey:@"user_type"];  // 用户类型，是微博还是邮箱
    [ud setObject:loginInfo[@"nickname"] forKey:@"nickname"];  // 用户昵称，微博用户默认是微博昵称
    [ud setObject:loginInfo[@"portrait"] forKey:@"portrait"];  // 用户头像，微博用户默认是微博头像，邮箱用户默认是默认头像
    [ud setDouble:[loginInfo[@"login_token"] intValue] forKey:@"login_token"];  // 判断过期或其他设备登录
    [ud setObject:loginInfo[@"phone"] forKey:@"phone"];  // 用户手机号（手机号登录的用户，uid就是手机号，但请分别记录）
    
    if (loginInfo[@"weibo_access_token"] && [loginInfo[@"user_type"] isEqualToString:@"weibo"]) {
        // 若是微博用户，且access_token有值
        [ud setObject:loginInfo[@"weibo_access_token"] forKey:@"weibo_access_token"];
    }
    
    return YES;
}

+ (NSDictionary *)readLoginInfo
{
    // 取登录信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginInfo = @{
                                @"uid": [ud stringForKey:@"uid"],
                                @"user_type": [ud stringForKey:@"user_type"],
                                @"nickname": [ud stringForKey:@"nickname"],
                                @"portrait": [ud stringForKey:@"portrait"]
                                };

    return loginInfo;
}

+ (BOOL)cleanLoginInfo
{
    // 退出登录时，清理登录信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"uid"];
    [ud removeObjectForKey:@"user_type"];
    [ud removeObjectForKey:@"nickname"];
    [ud removeObjectForKey:@"portrait"];
    [ud removeObjectForKey:@"phone"];
    [ud removeObjectForKey:@"deviceToken"];  // token也需要清理
    return YES;
}

+ (BOOL)isLogin
{
    // 通过检查uid是否有值，判断是否登录
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [ud stringForKey:@"uid"];
    if (uid) {
        return YES;
    } else {
        return NO;
    }
}


/* 修改昵称 */
+ (BOOL)changeNickname:(NSString *)newNickname
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:newNickname forKey:@"nickname"];
    return YES;
}





#pragma mark - 微博互粉
/* 微博互粉 */
+ (BOOL)recordWeiboFriends:(NSArray *)weiboFriendsArr
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:weiboFriendsArr forKey:@"weiboFriends"];
    return YES;
}

+ (NSArray *)readWeiboFriends
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *a = [ud arrayForKey:@"weiboFriends"];
    return a;
}




/* 手机号&通讯录 */
+ (NSString *)readPhone
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *phone = [ud stringForKey:@"phone"];
    return phone;
}

+ (BOOL)recordAddressBook:(NSArray *)abList
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:abList forKey:@"addressBookList"];
    return YES;
}

+ (NSArray *)readAddressBook
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *abList = [ud arrayForKey:@"addressBookList"];
    return abList;
}



@end
