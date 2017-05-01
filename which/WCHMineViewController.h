//
//  WCHMineViewController.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCHBasedTabViewController.h"

@interface WCHMineViewController :  WCHBasedTabViewController <UIActionSheetDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* 我的头像 */
@property (nonatomic, strong) NSString *portraitURL;
@property (nonatomic, strong) UIImageView *portraitImageView;
/* 昵称 */
@property (nonatomic, strong) UILabel *nicknameLabel;
@end
