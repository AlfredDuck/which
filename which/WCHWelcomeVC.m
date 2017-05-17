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
#import "WCHTokenManager.h"

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

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"welcome appear");
    // 检查是否登录,如果已经登录则自动退出此页面
    if ([WCHUserDefault isLogin]) {
        
        // 创建一个广播(登录状态变化)
        NSDictionary *info = @{@"message": @"ok"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginInfoChange" object:info];

        [self dismissViewControllerAnimated:YES completion:^{
            // 登录成功后获取token
            [WCHTokenManager requestDeviceToken];
        }];
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
    weiboLoginButton.layer.masksToBounds = YES;
    weiboLoginButton.layer.cornerRadius = 8;
    weiboLoginButton.backgroundColor = [WCHColorManager commonPink];
    [self.view addSubview:weiboLoginButton];
    
    /* 邮箱登录或注册 */
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton addTarget:self
                     action:@selector(goToMailLogin)
           forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"手机号登录/注册" forState:UIControlStateNormal];
    [signupButton setTitleColor:[WCHColorManager commonPink] forState:UIControlStateNormal];
    signupButton.frame = CGRectMake(15, _screenHeight-15-50, _screenWidth-30, 50);
    signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    signupButton.layer.masksToBounds = YES;
    signupButton.layer.cornerRadius = 8;
    signupButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:228/255.0 blue:234/255.0 alpha:1.0];
    [self.view addSubview:signupButton];
    
    
    /* logo */
    unsigned int hh = (_screenHeight-120)*2/5.0 - 190/2.0;
    UIView *logoBackground = [[UIView alloc] initWithFrame:CGRectMake((_screenWidth-200)/2.0, hh, 200, 190)];
    [self.view addSubview:logoBackground];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((200-108)/2.0, 0, 108, 108)];
    logoView.image = [UIImage imageNamed:@"which_icon_border_216.png"];
    [logoBackground addSubview: logoView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 107+12, 200, 20)];
    label1.text = @"· 阿伯点点 ·";
    label1.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    label1.textColor = [WCHColorManager commentTextColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [logoBackground addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 107+25+12+3, 200, 20)];
    label2.text = @"全民帮我挑好物";
    label2.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];
    label2.textColor = [WCHColorManager lightTextColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [logoBackground addSubview:label2];
    
    
    /* 关闭按钮 */
    UIImage *oneImage = [UIImage imageNamed:@"close.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(14.5, 14.5, 15, 15); // 设置图片位置和大小
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [self.view addSubview:backView];
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

- (void)clickCloseButton
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
    [self clickCloseButton];
}

- (void)signupCallBack {
    [self clickCloseButton];
}


@end
