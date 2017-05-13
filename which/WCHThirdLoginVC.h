//
//  WCHThirdLoginVC.h
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHThirdLoginVC : UIViewController
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
- (void)requestForWeiboAuthorize;  // 新浪微博授权请求
- (void)waitForWeiboAuthorizeResult;  // 注册观察者
@end
