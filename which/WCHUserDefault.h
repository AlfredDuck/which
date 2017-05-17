//
//  WCHUserDefault.h
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCHUserDefault : NSObject
/* 记录是否展示过push授权说明页面 */
+ (void)recordPushAuthorityIntroduction;
+ (BOOL)hasShowPushAuthorityIntroduction;

/* 读写本机token */
+ (NSString *)readDeviceToken;
+ (BOOL)recordDeviceToken:(NSString *)deviceToken;

/* push权限 */
+ (BOOL)isPushAllowed;
+ (void)pushAuthorityIsClose;
+ (void)pushAuthorityIsOpen;

/* 登录注册or退出登录 */
+ (BOOL)recordLoginInfo:(NSDictionary *)loginInfo;
+ (NSDictionary *)readLoginInfo;
+ (BOOL)cleanLoginInfo;  // 退出登录后清理所有用户信息
+ (BOOL)isLogin;  // 判断当前是否登录

/* 修改昵称 */
+ (BOOL)changeNickname:(NSString *)newNickname;

/* 微博互粉 */
+ (BOOL)recordWeiboFriends:(NSArray *)weiboFriendsArr;
+ (NSArray *)readWeiboFriends;

/* 手机号&通讯录 */
+ (NSString *)readPhone;
+ (BOOL)recordAddressBook:(NSArray *)abList;
+ (NSArray *)readAddressBook;

@end
