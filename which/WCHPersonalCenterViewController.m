//
//  WCHPersonalCenterViewController.m
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHPersonalCenterViewController.h"
#import "WCHColorManager.h"
#import "WCHUserDefault.h"
#import "WCHUrlManager.h"
#import "AFNetworking.h"
#import "WCHToastView.h"
#import "WCHNicknameVC.h"

@interface WCHPersonalCenterViewController () <UIAlertViewDelegate>

@end

@implementation WCHPersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [WCHColorManager commonBackground];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIParts];
    [self createItemsUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 构建UI
- (void)createUIParts
{
    /* 标题栏 */
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [WCHColorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"个人中心";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    
    /* back button pic */
    UIImage *oneImage = [UIImage imageNamed:@"back_black.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(11, 13.2, 22, 17.6); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
}


/** 创建各个选项的UI */
- (void)createItemsUI
{
    // 获取登录信息
    NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
    
    /* 修改昵称 */
    UIView *nicknameBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+64, _screenWidth, 44)];
    nicknameBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    nicknameBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNickname)]; // 设置手势
    [nicknameBackground addGestureRecognizer:singleTapNickName]; // 给图片添加手势
    [self.view addSubview:nicknameBackground];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    oneLabel.text = @"修改昵称";
    oneLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    oneLabel.textColor = [WCHColorManager mainTextColor];
    [nicknameBackground addSubview: oneLabel];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth-120-26, 12, 120, 20)];
    _nicknameLabel.textAlignment = NSTextAlignmentRight;
    _nicknameLabel.text = loginInfo[@"nickname"];
    _nicknameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _nicknameLabel.textColor = [WCHColorManager lightTextColor];
    [nicknameBackground addSubview:_nicknameLabel];
    
    // 箭头图片
    UIImage *oneImage = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-38, 0, 44, 44)];
    [backView addSubview:oneImageView];
    [nicknameBackground addSubview:backView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, _screenWidth-15, 0.5)];
    line2.backgroundColor = [WCHColorManager lightline];
    [nicknameBackground addSubview:line2];
    
    
    /* 退出登录 */
    UIView *loginoutBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+64+15+44, _screenWidth, 44)];
    loginoutBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    loginoutBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLogout)]; // 设置手势
    [loginoutBackground addGestureRecognizer:singleTapLogout]; // 给图片添加手势
    [self.view addSubview:loginoutBackground];
    
    UILabel *loginoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, _screenWidth-60, 22)];
    loginoutLabel.text = @"退出登录";
    loginoutLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    loginoutLabel.textColor = [UIColor redColor];
    loginoutLabel.textAlignment = NSTextAlignmentCenter;
    [loginoutBackground addSubview: loginoutLabel];
}



#pragma mark - IBAction
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickNickname
{
    WCHNicknameVC *nicknamePage = [[WCHNicknameVC alloc] init];
    // block回调
    nicknamePage.sendSuccess = ^(NSString *text, NSString *newNickname){
        // 显示toast
        [WCHToastView showToastWith:text isErr:YES duration:3.0 superView:self.view];
        // 修改本地loginInfo
        [WCHUserDefault changeNickname: newNickname];
        // 更改UI
        _nicknameLabel.text = newNickname;
    };
    [self.navigationController pushViewController:nicknamePage animated:YES];
}

- (void)clickLogout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出登录后将收不到朋友的消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出登录", nil];
    alert.tag = 11;
    [alert show];
}




#pragma mark - Alertview 代理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            NSLog(@"退出登录");
            NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
            [self connectForLogout: loginInfo[@"uid"]];  // 发起退登请求
        }
    }
}




#pragma mark - 网络请求
- (void)connectForLogout:(NSString *)uid
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/user/logout"];
    
    NSDictionary *parameters = @{@"uid": uid};
    
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        // 返回值报错s
        if (errcode == 1001 || errcode == 1002) {
            NSString *txt;
            if (errcode == 1001) {
                txt = @"数据库君这会儿有点晕，请稍后再试";
            } else {
                txt = @"Logout Failed";
            }
            [WCHToastView showToastWith:txt isErr:NO duration:3.0f superView:self.view];
            return;
        }
        // 返回值正常
        // 清理登录信息
        [WCHUserDefault cleanLoginInfo];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
    }];

}





@end
