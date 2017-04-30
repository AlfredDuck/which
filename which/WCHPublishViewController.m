//
//  WCHPublishViewController.m
//  which
//
//  Created by alfred on 2017/4/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHPublishViewController.h"
#import "WCHColorManager.h"

@interface WCHPublishViewController ()
@property (nonatomic, strong) NSString *textMax;
@end

@implementation WCHPublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIParts];
    [self createTextView];
    [self createPicHolder];
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
    titleLabel.text = @"发起投票";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    
    /* 关闭按钮 */
    UIImage *oneImage = [UIImage imageNamed:@"close.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(14.5, 14.5, 15, 15); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
    
    
    // “发送” 按钮
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 49-8, 28.5, 49, 27)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.backgroundColor = [WCHColorManager commonPink];
    _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _sendButton.layer.cornerRadius = 3;
    [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [titleBarBackground addSubview:_sendButton];
    
}



#pragma mark - 构建输入框
/** 构建输入框 */
- (void)createTextView
{
    // 评论输入框
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 64, _screenWidth-60, 200)];
    // _contentTextView.backgroundColor = [UIColor yellowColor];
    _contentTextView.textColor = [WCHColorManager mainTextColor];
    _contentTextView.textAlignment = NSTextAlignmentCenter;
    _contentTextView.font = [UIFont fontWithName:@"PingFangSC-Thin" size:20];
    _contentTextView.delegate = self;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_contentTextView];
    // 一开始就让光标居中的小技巧:)
    _contentTextView.text = @" ";
    [self keepCenter:_contentTextView];
    _contentTextView.text = @"";
    
    
    // 自定义 UITextView 的 placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth/2.0-100, 80+64, 200, 40)];
    _placeholder.text = @"点击输入标题";
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.font = [UIFont fontWithName:@"PingFangSC-Thin" size: 20];
    _placeholder.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_placeholder];
}



#pragma mark - UITextView 代理方法
// 内容发生改变
- (void)textViewDidChange:(UITextView *)textView
{
    _placeholder.hidden = YES;
    if ([textView.text isEqualToString:@""]) {
        _placeholder.hidden = NO;
    }
    
    // 超过一定高度就不能输入了
    if ([textView bounds].size.height <= [textView contentSize].height + 20){
        textView.text = _textMax;
    } else {
        _textMax = textView.text;
    }
    
    // 通过偏移来设置垂直居中
    [self keepCenter:textView];
}


- (void)keepCenter:(UITextView *)textView
{
    //    NSLog(@"%f", [textView bounds].size.height);
    //    NSLog(@"%f", [textView contentSize].height);
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height * [textView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}


// 用回车完成编辑
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//// 隐藏键盘(点击空白处)
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"隐藏键盘");
//    [self.view endEditing:YES];
//}




#pragma mark - 裁切图片(all here)

/** 两张图片容器 */
- (void)createPicHolder
{
    unsigned long ww = _screenWidth/2.0 - 1;
    unsigned long hh = ww/3.0*4.0;
    UIView *picAView = [[UIView alloc] initWithFrame:CGRectMake(0, 200+64, ww, hh)];
    UIView *picBView = [[UIView alloc] initWithFrame:CGRectMake(ww+2, 200+64, ww, hh)];
    picAView.backgroundColor = [WCHColorManager lightGrayBackground];
    picBView.backgroundColor = [WCHColorManager lightGrayBackground];
    [self.view addSubview: picAView];
    [self.view addSubview: picBView];
    
    UIImageView *iconA = [[UIImageView alloc] initWithFrame:CGRectMake((ww-61)/2.0, (hh-61)/2.0, 61, 61)];
    iconA.image = [UIImage imageNamed:@"a_icon.png"];
    [picAView addSubview: iconA];
    UIImageView *iconB = [[UIImageView alloc] initWithFrame:CGRectMake((ww-61)/2.0, (hh-61)/2.0, 61, 61)];
    iconB.image = [UIImage imageNamed:@"b_icon.png"];
    [picBView addSubview: iconB];
    
    // 为UIView添加点击事件
    UITapGestureRecognizer *singleTapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicHolder:)]; // 设置手势
    UITapGestureRecognizer *singleTapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicHolder:)]; // 设置手势
    picAView.userInteractionEnabled = YES; // 设置图片可以交互
    picBView.userInteractionEnabled = YES; // 设置图片可以交互
    [picAView addGestureRecognizer:singleTapA]; // 给图片添加手势
    [picBView addGestureRecognizer:singleTapB]; // 给图片添加手势
    
}





#pragma mark - IBAction
- (void)clickCloseButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendButton
{
    
}

- (void)clickPicHolder:(UIGestureRecognizer *)sender
{
    NSLog(@"clickPicHolder");
}


@end
