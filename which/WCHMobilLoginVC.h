//
//  WCHMobileLoginVC.h
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHMobilLoginVC : UIViewController
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

@property (nonatomic, strong) UITextField *mobilTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIView *loginButton;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UIView *signupButton;
@property (nonatomic, strong) UILabel *signupLabel;
@property (nonatomic, strong) UIView *nicknameView;
@end
