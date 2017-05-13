//
//  WCHWelcomeVC.m
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHWelcomeVC.h"
#import "WCHUserDefault.h"
#import "WCHColorManager.h"
#import "WCHThirdLoginVC.h"
#import "WCHMobilLoginVC.h"

@interface WCHWelcomeVC ()

@end

@implementation WCHWelcomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"Welcome";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕长宽（pt）
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIPart];
}

-(void)viewDidAppear:(BOOL)animated {
    // 检查是否登录,如果已经登录则自动退出此页面
    if ([WCHUserDefault isLogin]) {
        
        // 创建一个广播(登录状态变化)
        NSDictionary *info = @{@"message": @"ok"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginInfoChange" object:info];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 构建UI
- (void)createUIPart
{
    /* 新浪微博登录 */
    UIButton *weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboLoginButton addTarget:self
                         action:@selector(goToThirdLogin)
               forControlEvents:UIControlEventTouchUpInside];
    [weiboLoginButton setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [weiboLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    weiboLoginButton.frame = CGRectMake(15, _screenHeight-15-50*2-10, _screenWidth-30, 50);
    weiboLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    weiboLoginButton.tintColor = [UIColor whiteColor];
    weiboLoginButton.layer.masksToBounds = YES;
    weiboLoginButton.layer.cornerRadius = 8;
    weiboLoginButton.backgroundColor = [WCHColorManager yellowBackground];
    [self.view addSubview:weiboLoginButton];
    
    /* 邮箱登录或注册 */
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton addTarget:self
                     action:@selector(goToMailLogin)
           forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"手机号登录/注册" forState:UIControlStateNormal];
    [signupButton setTitleColor:[WCHColorManager yellowText] forState:UIControlStateNormal];
    signupButton.frame = CGRectMake(15, _screenHeight-15-50, _screenWidth-30, 50);
    signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    signupButton.tintColor = [WCHColorManager yellowText];
    signupButton.layer.masksToBounds = YES;
    signupButton.layer.cornerRadius = 8;
    signupButton.backgroundColor = [WCHColorManager lightYellowBackground];
    [self.view addSubview:signupButton];
    
    
    /* logo */
    unsigned int hh = (_screenHeight-120)*2/5.0 - 190/2.0;
    UIView *logoBackground = [[UIView alloc] initWithFrame:CGRectMake((_screenWidth-200)/2.0, hh, 200, 190)];
    [self.view addSubview:logoBackground];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((200-107)/2.0, 0, 107, 107)];
    logoView.image = [UIImage imageNamed:@"coco_logo.png"];
    [logoBackground addSubview: logoView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 107+25, 200, 20)];
    label1.text = @"COCO";
    label1.font = [UIFont fontWithName:@"Helvetica Bold" size:20];
    label1.textColor = [WCHColorManager lightTextColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [logoBackground addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 107+25+20+3, 200, 20)];
    label2.text = @"你的百变魔音";
    label2.font = [UIFont fontWithName:@"Helvetica" size:14];
    label2.textColor = [WCHColorManager lightTextColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [logoBackground addSubview:label2];
    
    
    /* 退出页面 */
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
    action:@selector(clickCancelButton)
    forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"退出" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 500, _screenWidth-40, 40);
    //button.frame = CGRectMake(0, 0, 40, 40);
    backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    backButton.tintColor = [UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1];
    backButton.backgroundColor = [UIColor colorWithRed:(207/255.0) green:(237/255.0) blue:(228/255.0) alpha:1];

    [backButton.layer setMasksToBounds:YES];
    [backButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [backButton.layer setBorderWidth:1.0];   //边框宽度
    [backButton.layer setBorderColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1].CGColor];

    [self.view addSubview:backButton];
}




/*
 * IBAction
 *
 *
 */
#pragma mark - IBAction
- (void)goToMailLogin
{
    WCHMobilLoginVC *mobilLoginPage = [[WCHMobilLoginVC alloc] init];
    [self presentViewController:mobilLoginPage animated:YES completion:nil];
}

- (void)goToThirdLogin
{
    WCHThirdLoginVC *thirdLoginPage = [[WCHThirdLoginVC alloc] init];
    [self presentViewController:thirdLoginPage animated:YES completion:nil];
}

- (void)clickCancelButton
{
    NSLog(@"移除welcome模态");
    [self dismissViewControllerAnimated:NO completion:nil];
}




/*
 * 代理方法
 *
 *
 */

- (void)loginCallBack {
    [self clickCancelButton];
}

- (void)signupCallBack {
    [self clickCancelButton];
}


@end
