//
//  WCHWriteCommentViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHWriteCommentViewController.h"
#import "WCHUrlManager.h"
#import "WCHColorManager.h"
#import "AFNetworking.h"
#import "WCHToastView.h"
#import "WCHUserDefault.h"

@interface WCHWriteCommentViewController ()

@end

@implementation WCHWriteCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"title";
        self.view.backgroundColor = [WCHColorManager commonBackground];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"写评论页面articleID: %@", _publishID);
    // 创建 UI
    [self basedTitleBar];
    [self basedWriteText];
    
    // 临时用...
    NSUserDefaults *sf = [NSUserDefaults standardUserDefaults];
    NSDictionary *dd = [sf objectForKey:@"loginInfo"];
    NSLog(@"当前登录账户信息：%@",dd);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建 UI
// 创建顶部导航栏
- (void)basedTitleBar
{
    // title bar background
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [WCHColorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = _pageTitle;
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    // 返回按钮
    UIImage *oneImage = [UIImage imageNamed:@"close.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(14.5, 14.5, 15, 15); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
    
    // “发送” 按钮
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 48, 20, 48, 43)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIColor *buttonColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.backgroundColor = [UIColor whiteColor];
    _sendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [titleBarBackground addSubview:_sendButton];
}


// 创建输入文本区域
- (void)basedWriteText
{
    //    // 昵称输入框
    //    UIView *nickNameBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 64+10, _screenWidth, 44)];
    //    nickNameBackground.backgroundColor = [UIColor whiteColor];
    //    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 0.5)];
    //    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _screenWidth, 0.5)];
    //    line1.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    //    line2.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    //    [nickNameBackground addSubview:line1];
    //    [nickNameBackground addSubview:line2];
    //
    //    [self.view addSubview:nickNameBackground];
    //
    //    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(13, 2, _screenWidth-30, 40)];
    //    [_nickNameTextField setBorderStyle:UITextBorderStyleNone]; // 外框类型
    //    _nickNameTextField.placeholder = @"壮士，留下名号吧"; // 默认显示的字
    //    // _nickNameTextField.backgroundColor = [UIColor yellowColor];
    //    _nickNameTextField.textColor = [colorManager mainTextColor];
    //    _nickNameTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    //    [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    //    [nickNameBackground addSubview:_nickNameTextField];
    
    // 评论输入框
    UIView *commentBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 64+15, _screenWidth, 118)];
    commentBackground.backgroundColor = [UIColor whiteColor];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 0.5)];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 118-0.5, _screenWidth, 0.5)];
    line3.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    line4.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [commentBackground addSubview:line3];
    [commentBackground addSubview:line4];
    
    [self.view addSubview:commentBackground];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(7, 5, _screenWidth-7, 118-10)];
    // _contentTextView.backgroundColor = [UIColor yellowColor];
    // _contentTextView.text = @"在那個蒸氣時代裡，一切都以蒸氣為動力。煙霧瀰漫的帝都，怪盜、怪人橫行肆虐";
    _contentTextView.textColor = [WCHColorManager mainTextColor];
    _contentTextView.font = [UIFont fontWithName:@"Helvetica" size:14];
    _contentTextView.delegate = self;
    [commentBackground addSubview:_contentTextView];
    
    // 自定义 UITextView 的 placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(13,1,100,40)];
    _placeholder.text = @"输入评论";
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.font = [UIFont fontWithName:@"Helvetica" size: 14];
    [commentBackground addSubview:_placeholder];
    
}

/* 发送按钮的两种状态 */
- (void)readyToSend
{
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    UIColor *buttonColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 48, 20, 48, 43);
}

- (void)sending
{
    [_sendButton setTitle:@"发送中..." forState:UIControlStateNormal];
    UIColor *buttonColor = [WCHColorManager lightTextColor];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 60, 20, 60, 43);
    
}





#pragma mark - UITextView 代理方法
// 内容发生改变
- (void)textViewDidChange:(UITextView *)textView
{
    _placeholder.hidden = YES;
}

// 隐藏键盘(点击空白处)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"隐藏键盘");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}








#pragma mark - IBAction

- (void)clickBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendButton
{
    NSLog(@"点击发送按钮");
    
    // 关闭键盘
    [_contentTextView resignFirstResponder];
    
    // 检查是否“发送中...”状态
    if ([_sendButton.titleLabel.text isEqualToString:@"发送中..."]) {
        NSLog(@"正在发送，请勿重复点击");
        return;
    }
    
    // 检查输入是否为空
    if ([_contentTextView.text isEqualToString:@""]) {
        NSLog(@"请输入评论内容");
        return;
    }
    
    // 显示“发送中...”状态
    [_sendButton setTitle:@"发送中..." forState:UIControlStateNormal];
    UIColor *buttonColor = [WCHColorManager lightTextColor];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 60, 20, 60, 43);
    
    // 发起网络请求
    [self connectForWriteComment:_contentTextView.text];
}






#pragma mark - 网络请求
- (void)connectForWriteComment:(NSString *)comment
{
    NSLog(@"start write comment request !");
    //
    //    {
    //    article_id: XXXX
    //    nickname: XXXX
    //    text: XXXX
    //    uuid: XXXX
    //    }
    // 准备请求参数
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/write_comment"];
    
    NSDictionary *parameters;
    if ([WCHUserDefault isLogin]) {
        NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
        parameters = @{@"text": comment,
                       @"publish_id": _publishID,
                       @"uid": loginInfo[@"uid"],
                       @"portrait": loginInfo[@"portrait"],
                       @"nickname": loginInfo[@"nickname"]};
    }
    
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
                txt = @"操作出错，请火速联系管理员";
            }
            [WCHToastView showToastWith:txt isErr:NO duration:3.0f superView:self.view];
            return;
        }
        // 返回上一页,并调用block
        self.writeCommentSuccess(@"");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [self readyToSend];
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
    }];

}


@end
