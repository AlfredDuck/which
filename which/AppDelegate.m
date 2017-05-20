//
//  AppDelegate.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "Growing.h"
#import "YYWebImage.h"
#import "WCHRootViewController.h"
#import "WCHTokenManager.h"

#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0
#define kAPPKey        @"4247685982"  // which project
#define kRedirectURI   @"https://api.weibo.com/oauth2/default.html"
#define WXKey          @"wxf314baceef3b6975"  // which project

@interface AppDelegate () <WXApiDelegate, WeiboSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //    [NSThread sleepForTimeInterval:1.0];  //   启动等待时间
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;  // 状态栏小菊花
    
    // 启动GrowingIO
    [Growing startWithAccountId:@"b2f9d028b5f832af"];  // which项目
    
    // weibo SDK
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAPPKey];
    // weixin SDK 向微信注册
    [WXApi registerApp:WXKey];
    
    // 设置YY图片缓存的最大内存上限
    YYImageCache *YYcache = [YYWebImageManager sharedManager].cache;
    YYcache.memoryCache.costLimit = 300 * 1024 * 1024;
    YYcache.diskCache.costLimit = 1000 * 1024 * 1024;

    
    // 设置 RootViewController
    WCHRootViewController *rootVC = [[WCHRootViewController alloc] init];
    //    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    //    [navVC setNavigationBarHidden:YES];
    self.window.rootViewController = rootVC;
    return YES;
}




#pragma mark - weiboSDK & weixinSDK 要求
// 重写AppDelegate 的handleOpenURL和openURL方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // 通过判断url的前缀，决定用哪个
    NSString *string =[url absoluteString];
    NSLog(@"回调url的前缀：%@", string);
    
    if ([string hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([string hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return NO;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 调用growingio
    [Growing handleUrl:url];
    
    // 通过判断url的前缀，决定用哪个
    NSString *string =[url absoluteString];
    NSLog(@"回调url的前缀：%@", string);
    
    if ([string hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([string hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return NO;
    }
}



#pragma mark - 微博响应信息，如认证是否成功
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        // 分享到微信的返回值
        if(response.statusCode == 0){
            NSLog(@"新浪微博分享成功！");
            // 告知server端 code...

        } else if (response.statusCode == -1) {
            NSLog(@"用户取消分享");
        } else if (response.statusCode == -2) {
            NSLog(@"分享失败");
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        WBAuthorizeResponse *res = (WBAuthorizeResponse *)response;
        NSLog(@"新浪微博授权结果的响应！");
        NSLog(@"userID:%@", res.userID);
        NSLog(@"accessToken:%@", res.accessToken);
        NSLog(@"expirationDate:%@", res.expirationDate);
        NSLog(@"refreshToken%@", res.refreshToken);
        
        // 如果userinfo不为空，则授权成功
        if (res.userID) {
            NSLog(@"授权成功");
            // 创建一个广播：微博授权成功的广播
            NSDictionary *info = @{
                                   @"uid": res.userID,
                                   @"token": res.accessToken
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboAuthorizeSuccess" object:info];  // 广播出去
        }
        else {
            NSLog(@"授权失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboAuthorizeFalse" object:nil];  // 广播出去
        }
    }
}


#pragma mark - 微信的返回信息
- (void)onResp:(BaseResp*)resp
{
    //
    NSLog(@"从微信返回app");
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        NSLog(@"%@", strMsg);
        // 分享成功 errcode：0
        // 取消分享 errcode: -2
        if (resp.errCode == 0) {
            // 告知server端 code...
        }
        
    }
}







/*
 * 获取设备token
 *
 *
 *
 */

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


/*
 * 通知相关的设置，及token
 *
 *
 */
#pragma mark - token的代理
/** 获取token成功的回调 */
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"【device token】:%@", tokenStr);
    
    // 处理token格式
    NSString *tokenStrWithoutBlankChar = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenStrWithoutBlankChar = [tokenStrWithoutBlankChar stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStrWithoutBlankChar = [tokenStrWithoutBlankChar stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"去掉空格的token：%@", tokenStrWithoutBlankChar);
    
    // 上传token到服务器，及保存token到本地
    [WCHTokenManager uploadAndStoreToken:tokenStrWithoutBlankChar];
}


/** 获取token出错的回调 */
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"获取token时出错: %@", err];
    NSLog(@"%@",str);
    NSInteger code = err.code;
    NSLog(@"%ld", (long)code);
    /*
     token出错的情况，根据错误码做响应
     当用户拒绝授予应用程序发送推送通知的权限 code=
     当没有网络连接和用户授予的权限发送推送通知时。
     当用户禁用从应用程序的通知中心应用程序的推送通知。
     */
}


/** 收到push时的处理 */
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(application.applicationState == UIApplicationStateActive){
        // 程序在运行过程中受到推送通知(前台或后台）
        NSLog(@"%@", userInfo);
        NSString *audio = userInfo[@"audio"];
        NSString *ms = userInfo[@"aps"][@"alert"];
        // 播放提示音
        // [FTMAudioPlayManager playAudioWithID:audio];
        
        // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:ms delegate:self cancelButtonTitle:@"收到" otherButtonTitles: nil];
        // [alert show];
        
        // 创建一个广播(发送了一个message)，广播接收方是message list)
        NSDictionary *info = @{@"message": @"ok"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recieveAPNS" object:info];
        
    } else {
        // 程序未在运行状态受到推送通知
    }
}










#pragma mark - 暂时不用
/************** 暂时用不到 **************/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Core Data stack

//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"which"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//    
//    return _persistentContainer;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}

@end
