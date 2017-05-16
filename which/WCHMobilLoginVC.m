//
//  WCHMobileLoginVC.m
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHMobilLoginVC.h"
#import "WCHUserDefault.h"
#import "WCHColorManager.h"
#import "AFNetworking.h"
#import "WCHUrlManager.h"
#import "WCHToastView.h"

@interface WCHMobilLoginVC ()

@end

@implementation WCHMobilLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"title";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIParts];
}


- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark - 构建UI
/** 构建UI */
- (void)createUIParts
{
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
    
    
    
    /* 切换控件 */
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"注册新帐号",@"登录",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segControl.frame = CGRectMake(45.0, 60, _screenWidth-90, 26.0);
    segControl.selectedSegmentIndex = 0;  //设置默认选择项索引
    segControl.tintColor = [WCHColorManager commonPink];
    [self.view addSubview: segControl];
    [segControl addTarget:self action:@selector(changeSegmentWith:) forControlEvents:UIControlEventValueChanged];  // 点击事件
    
    
    /* ------ 登录/注册组件 ------ */
    unsigned long hh = 103;
    /* 手机号输入框 */
    UIView *mailView = [[UIView alloc] initWithFrame:CGRectMake(45, hh, _screenWidth-90, 40)];
    mailView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    mailView.layer.masksToBounds = YES;  // 没这句话它圆不起来
    mailView.layer.cornerRadius = 5.0;  // 设置图片圆角的尺度
    [self.view addSubview: mailView];
    
    _mobilTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, _screenWidth-120, 40)];
    _mobilTextField.placeholder = @"手机号";
    _mobilTextField.textColor = [WCHColorManager mainTextColor];
    _mobilTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    [_mobilTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    [mailView addSubview: _mobilTextField];
    
    /* 密码输入框 */
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(45, hh+44+8, _screenWidth-90, 40)];
    passwordView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    passwordView.layer.masksToBounds = YES;  // 没这句话它圆不起来
    passwordView.layer.cornerRadius = 5.0;  // 设置图片圆角的尺度
    [self.view addSubview: passwordView];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, _screenWidth-120, 40)];
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.textColor = [WCHColorManager mainTextColor];
    _passwordTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    _passwordTextField.secureTextEntry = YES;  // 密码模式
    [_passwordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    [passwordView addSubview: _passwordTextField];
    
    /* 昵称输入框 */
    _nicknameView = [[UIView alloc] initWithFrame:CGRectMake(45, hh+(44+8)*2, _screenWidth-90, 40)];
    _nicknameView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    _nicknameView.layer.masksToBounds = YES;  // 没这句话它圆不起来
    _nicknameView.layer.cornerRadius = 5.0;  // 设置图片圆角的尺度
    [self.view addSubview: _nicknameView];
    _nicknameView.hidden = NO;
    
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, _screenWidth-120, 40)];
    _nicknameTextField.placeholder = @"昵称";
    _nicknameTextField.textColor = [WCHColorManager mainTextColor];
    _nicknameTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    [_nicknameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    [_nicknameView addSubview: _nicknameTextField];
    
    /* 登录按钮 */
    _loginButton = [[UIView alloc] initWithFrame:CGRectMake(45, hh+(44+8)+(44+12), _screenWidth-90, 40)];
    _loginButton.backgroundColor = [WCHColorManager commonPink];
    _loginButton.layer.masksToBounds = YES;  // 没这句话它圆不起来
    _loginButton.layer.cornerRadius = 5.0;  // 设置图片圆角的尺度
    _loginButton.hidden = YES;
    
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _screenWidth-90, 40)];
    _loginLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    _loginLabel.text = @"登录";
    _loginLabel.textColor = [UIColor whiteColor];
    _loginLabel.textAlignment = NSTextAlignmentCenter;
    [_loginButton addSubview: _loginLabel];
    // 为UIView添加点击事件
    _loginButton.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLoginButton)]; // 设置手势
    [_loginButton addGestureRecognizer:singleTapLogin]; // 给图片添加手势
    [self.view addSubview: _loginButton];
    
    
    /* 注册按钮 */
    _signupButton = [[UIView alloc] initWithFrame:CGRectMake(45, hh+(44+8)*2+(44+12), _screenWidth-90, 40)];
    _signupButton.backgroundColor = [WCHColorManager commonPink];
    _signupButton.layer.masksToBounds = YES;  // 没这句话它圆不起来
    _signupButton.layer.cornerRadius = 5.0;  // 设置图片圆角的尺度
    _signupButton.hidden = NO;
    
    _signupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _screenWidth-90, 40)];
    _signupLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    _signupLabel.text = @"注册";
    _signupLabel.textColor = [UIColor whiteColor];
    _signupLabel.textAlignment = NSTextAlignmentCenter;
    [_signupButton addSubview: _signupLabel];
    // 为UIView添加点击事件
    _signupButton.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapSignup = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSignupButton)]; // 设置手势
    [_signupButton addGestureRecognizer:singleTapSignup]; // 给图片添加手势
    [self.view addSubview:_signupButton];
    
}







#pragma mark - IBAction
/** 点击关闭按钮 */
- (void)clickCloseButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"已退出native登录注册页面");
    }];
}


/** 改变segment */
- (void)changeSegmentWith:(UIGestureRecognizer *)sender
{
    unsigned index = (unsigned)((UISegmentedControl *)sender).selectedSegmentIndex;
    if (index == 1) {
        // 切到登录
        _loginButton.hidden = NO;
        _signupButton.hidden = YES;
        _nicknameView.hidden = YES;
        _mobilTextField.placeholder = @"手机号";
        // 从0.0.3开始不再支持邮箱注册，但以往邮箱用户还可以登录
    } else if (index == 0) {
        // 切到注册
        _loginButton.hidden = YES;
        _signupButton.hidden = NO;
        _nicknameView.hidden = NO;
        _mobilTextField.placeholder = @"手机号";
    }
}


/** 点击登录按钮 */
- (void)clickLoginButton
{
    if (![_loginLabel.text isEqualToString:@"登录"]) {
        return;
    }
    
    NSString *phone = _mobilTextField.text;
    NSString *password = _passwordTextField.text;
    
    // 校验输入不为空
    if ([phone isEqualToString:@""] || [password isEqualToString:@""]){
        NSLog(@"请填写手机号和密码");
        return;
    }
    
    _loginButton.backgroundColor = [UIColor lightGrayColor];
    _loginLabel.text = @"登录中...";
    
    [self connectForLoginWithPhone:phone andPassword:password];
}


/** 点击注册按钮 */
- (void)clickSignupButton
{
    if (![_signupLabel.text isEqualToString:@"注册"]) {
        return;
    }
    
    NSString *phone = _mobilTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *nickname = _nicknameTextField.text;
    
    // 校验输入不为空
    if ([phone isEqualToString:@""] || [password isEqualToString:@""] || [nickname isEqualToString:@""]){
        NSLog(@"请填写手机号和密码");
        return;
    }
    // 校验手机号格式
    NSString *toast = [self valiMobile: phone];
    if (toast) {
        [WCHToastView showToastWith:toast isErr:NO duration:2.0 superView:self.view];
        return;
    }
    
    _signupButton.backgroundColor = [UIColor lightGrayColor];
    _signupLabel.text = @"注册中...";
    
    [self connectForSignupWithPhone:phone andPassword:password andNickname:nickname];
}





#pragma mark - UITextView 代理方法
// 隐藏键盘(点击空白处)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"隐藏键盘");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}






#pragma mark - 网络请求
/** 请求登录接口 */
- (void)connectForLoginWithPhone:(NSString *)phone andPassword:(NSString *)password
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/user/mail_login"];
    
    NSDictionary *parameters = @{
                                 @"uid": phone,
                                 @"password": password,
                                 @"plantform": @"ios"
                                 };
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"在轻闻server登录成功的data:%@", data);
        
        if (errcode == 1001) {  // 数据库出错
            NSLog(@"登录时出错");
            _loginLabel.text = @"登录";
            _loginButton.backgroundColor = [WCHColorManager commonPink];
            [WCHToastView showToastWith:@"服务器出错，请重试" isErr:NO duration:2.0 superView:self.view];
            return;
        }
        if (errcode == 1002) {  // 用户不存在，无法登陆
            NSLog(@"用户不存在，请先注册");
            _loginLabel.text = @"登录";
            _loginButton.backgroundColor = [WCHColorManager commonPink];
            [WCHToastView showToastWith:@"手机号或密码错误" isErr:NO duration:2.0 superView:self.view];
            return;
        }
        
        // 储存登录账户
        [self loginSuccessWith:data];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败");
        NSLog(@"Error: %@", error);
        _loginLabel.text = @"登录";
        _loginButton.backgroundColor = [WCHColorManager commonPink];
        [WCHToastView showToastWith:@"网络有点问题" isErr:NO duration:2.0 superView:self.view];
    }];

}



/** 注册请求 */
- (void)connectForSignupWithPhone:(NSString *)phone andPassword:(NSString *)password andNickname:(NSString *)nickname
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/user/mail_signup"];
    
    NSDictionary *parameters = @{
                                 @"uid": phone,
                                 @"password": password,
                                 @"nickname": nickname,
                                 @"phone": phone,
                                 @"user_type": @"phone",
                                 @"plantform": @"ios"
                                 };
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"在轻闻server注册成功的data:%@", data);
        
        if (errcode == 1001) {  // 数据库出错
            _signupLabel.text = @"注册";
            _signupButton.backgroundColor = [WCHColorManager commonPink];
            [WCHToastView showToastWith:@"服务器出错，请重试" isErr:NO duration:2.0 superView:self.view];
            return;
        }
        if (errcode == 1002) {  // 用户已注册，无法完成注册
            _signupLabel.text = @"注册";
            _signupButton.backgroundColor = [WCHColorManager commonPink];
            [WCHToastView showToastWith:@"此手机号已注册过，请直接登录" isErr:NO duration:2.0 superView:self.view];
            return;
        }
        
        // 储存登录账户
        [self loginSuccessWith:data];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        _signupLabel.text = @"注册";
        _signupButton.backgroundColor = [WCHColorManager commonPink];
        [WCHToastView showToastWith:@"网络有点问题" isErr:NO duration:2.0 superView:self.view];
    }];
}






#pragma mark - 登录or注册成功后储存账号
/** 登录or注册成功后储存在本地 */
- (void)loginSuccessWith:(NSDictionary *)data
{
    // 不论server下发的有什么内容，本地只按照某种标准格式储存
    NSDictionary *userData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              data[@"user_type"], @"user_type",  // 账户类型：邮箱、微博、微信等
                              data[@"nickname"] ,@"nickname",  // 昵称
                              data[@"uid"], @"uid",  // 用户id（对邮箱用户来说就是邮箱号）
                              data[@"portrait"], @"portrait",  // 头像url
                              data[@"login_token"], @"login_token",  // 登录过期、或换设备登录所用
                              data[@"uid"], @"phone",  // 手机号(为了方便匹配好友，所有用户都有这样一个属性)
                              nil];
    // 账号信息记录到本地
    [WCHUserDefault recordLoginInfo:userData];
    NSLog(@"登录成功：%@", userData);
    
    // 退出登录页面
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"退出登录页面");
    }];
}




#pragma mark - 手机号格式校验
/** 手机号格式校验 */
- (NSString *)valiMobile:(NSString *)mobile
{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}


@end
