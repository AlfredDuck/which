//
//  WCHMineViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHMineViewController.h"
#import "WCHColorManager.h"
#import "YYWebImage.h"
#import "WCHUserDefault.h"
#import "WCHPersonalCenterViewController.h"
#import "WCHWelcomeVC.h"
#import "WCHMyPublishVC.h"
#import "WCHShareManager.h"

@interface WCHMineViewController ()
@property (nonatomic, strong) UIScrollView *basedScrollView;
@end

@implementation WCHMineViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _portraitURL = @"";
    
    /* 构建页面元素 */
    [self createUIParts];
    [super createTabBarWith:1];  // 调用父类方法，构建tabbar
    
    [self waitForNotification];
}


- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!_basedScrollView) {
        [self createScrollView];  // 创建scrollview容器(内容ui都在容器内)
        [self createFuncList];
        [self createLoginInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 构建 UI 零件
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
    titleLabel.text = @"我的";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
}




#pragma mark - 创建scrollview
- (void)createScrollView
{
    // 基础scrollview
    _basedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64-49)];
    _basedScrollView.backgroundColor = [WCHColorManager commonBackground];
    [self.view addSubview:_basedScrollView];
    
    //这个属性很重要，它可以决定是横向还是纵向滚动，一般来说也是其中的 View 的总宽度，和总的高度
    _basedScrollView.contentSize = CGSizeMake(_screenWidth, _basedScrollView.frame.size.height+1);
    
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    _basedScrollView.contentOffset = CGPointMake(0, 0);
    
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    //scrollView.pagingEnabled = YES;
    
    //隐藏滚动条
    _basedScrollView.showsVerticalScrollIndicator = TRUE;
    _basedScrollView.showsHorizontalScrollIndicator = FALSE;
    
    // 是否边缘反弹
    _basedScrollView.bounces = YES;
    // 是否响应点击状态栏的事件
    _basedScrollView.scrollsToTop = YES;
}


/** 创建个人信息（头像、账号等） */
- (void)createLoginInfo
{
    UIView *portraitBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _screenWidth, 168)];
    portraitBackground.backgroundColor = [UIColor whiteColor];
    [_basedScrollView addSubview: portraitBackground];
    
    // =======================================================
    
    NSString *url;
    if ([WCHUserDefault isLogin]) {
        url = [[WCHUserDefault readLoginInfo] objectForKey:@"portrait"];
    } else {
        url = @"https://img3.doubanio.com/mpic/o493916.jpg";
    }
    
    /* 头像 */
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_screenWidth-88)/2.0, 22, 88, 88)]; // 原来36
    _portraitImageView.backgroundColor = [WCHColorManager lightGrayBackground];
    // uiimageview居中裁剪
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    _portraitImageView.clipsToBounds  = YES;
    _portraitImageView.layer.cornerRadius = 44;
    [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
    [_portraitImageView.layer setBorderColor:[WCHColorManager lightPortraitline].CGColor];
    
    // 普通加载网络图片 yy库
    _portraitImageView.yy_imageURL = [NSURL URLWithString: url];
    // 为UIView添加点击事件
    _portraitImageView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapPortrait = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPortrait)]; // 设置手势
    [_portraitImageView addGestureRecognizer:singleTapPortrait]; // 给图片添加手势
    [portraitBackground addSubview:_portraitImageView];
    
    
    
    /* 微博id or 邮箱账号 */
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, _screenWidth-60, 17)];
    NSString *oneID = @"";
    if ([WCHUserDefault isLogin]) {
        NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
        if ([loginInfo[@"user_type"] isEqualToString:@"weibo"]) {
            oneID = [@"微博id：" stringByAppendingString:loginInfo[@"uid"]];
        } else {
            oneID = loginInfo[@"uid"];
        }
    } else {
        oneID = @"点击登录/注册";
    }
    idLabel.text = oneID;
    idLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.textColor = [WCHColorManager lightTextColor];
    [portraitBackground addSubview: idLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 167.5, _screenWidth-15, 0.5)];
    line1.backgroundColor = [WCHColorManager lightline];
    [portraitBackground addSubview:line1];
    
    
    // ======================================================================
}

/** 创建功能入口 */
- (void)createFuncList
{
    /* 我发起的投票 */
    UIView *myPublishedVoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168, _screenWidth, 44)];
    myPublishedVoteView.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    myPublishedVoteView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMyPublishedVote)]; // 设置手势
    [myPublishedVoteView addGestureRecognizer:singleTapNickName]; // 给图片添加手势
    [_basedScrollView addSubview:myPublishedVoteView];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    oneLabel.text = @"我发起的投票";
    oneLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    oneLabel.textColor = [WCHColorManager mainTextColor];
    [myPublishedVoteView addSubview: oneLabel];
    
    // 箭头图片
    UIImage *oneImage = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-38, 0, 44, 44)];
    [backView addSubview:oneImageView];
    [myPublishedVoteView addSubview:backView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, _screenWidth-15, 0.5)];
    line2.backgroundColor = [WCHColorManager lightline];
    [myPublishedVoteView addSubview:line2];
    
    
    /* 求好评 */
    UIView *appStoreBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168+44, _screenWidth, 44)];
    appStoreBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    appStoreBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapAppStore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAppStore)]; // 设置手势
    [appStoreBackground addGestureRecognizer:singleTapAppStore]; // 给图片添加手势
    [_basedScrollView addSubview:appStoreBackground];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    noteLabel.text = @"去AppStore给好评";
    noteLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    noteLabel.textColor = [WCHColorManager mainTextColor];
    [appStoreBackground addSubview: noteLabel];
    // 箭头图片
    UIImage *oneImage1 = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView1 = [[UIImageView alloc] initWithImage:oneImage1]; // 把oneImage添加到oneImageView上
    oneImageView1.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-38, 0, 44, 44)];
    [backView1 addSubview:oneImageView1];
    [appStoreBackground addSubview:backView1];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, _screenWidth-15, 0.5)];
    line3.backgroundColor = [WCHColorManager lightline];
    [appStoreBackground addSubview:line3];
    
    
    /* 邀请好友加入（分享） */
    UIView *shareBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168+44+44, _screenWidth, 44)];
    shareBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    shareBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShare)]; // 设置手势
    [shareBackground addGestureRecognizer:singleTapShare]; // 给图片添加手势
    [_basedScrollView addSubview:shareBackground];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    shareLabel.text = @"邀请好友加入";
    shareLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    shareLabel.textColor = [WCHColorManager mainTextColor];
    [shareBackground addSubview: shareLabel];
    // 箭头图片
    UIImage *oneImage2 = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView2 = [[UIImageView alloc] initWithImage:oneImage2]; // 把oneImage添加到oneImageView上
    oneImageView2.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-38, 0, 44, 44)];
    [backView2 addSubview:oneImageView2];
    [shareBackground addSubview:backView2];

}



#pragma mark - IBAction
/** 点击myPublishedVote */
- (void)clickMyPublishedVote
{
    if (![WCHUserDefault isLogin]) {
        WCHWelcomeVC *welcome = [[WCHWelcomeVC alloc] init];
        [self.navigationController presentViewController:welcome animated:YES completion:^{

        }];
        return;
    }
    
    WCHMyPublishVC *myPublish = [[WCHMyPublishVC alloc] init];
    [self.navigationController pushViewController:myPublish animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/** 点击AppStore */
- (void)clickAppStore
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/id1236414057";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}


/** 点击share */
- (void)clickShare
{
    NSLog(@"click share");
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"选择邀请朋友的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"微信好友", @"微信朋友圈", nil];
    [shareSheet showInView:self.view];
}


/** 点击头像 */
- (void)clickPortrait
{
    if (![WCHUserDefault isLogin]) {
        WCHWelcomeVC *welcome = [[WCHWelcomeVC alloc] init];
        [self.navigationController presentViewController:welcome animated:YES completion:^{

        }];
        return;
    }
    
    WCHPersonalCenterViewController *pcenter = [[WCHPersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:pcenter animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}



#pragma mark - UIActionSheet 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WCHShareManager *shareManager = [[WCHShareManager alloc] init];
    if (buttonIndex == 0) {
        NSLog(@"weibo");
        [shareManager shareToWeibo];
    } else if (buttonIndex == 1) {
        NSLog(@"weixin");
        [shareManager shareToWeixinWithTimeLine:NO];
    } else if (buttonIndex == 2) {
        NSLog(@"timeline");
        [shareManager shareToWeixinWithTimeLine:YES];
    }
}



#pragma mark - 接收广播
/** 注册广播观察者 **/
- (void)waitForNotification
{
    // 广播内容：登录状态变化
    [[NSNotificationCenter defaultCenter] addObserverForName:@"loginInfoChange" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        
        [_basedScrollView removeFromSuperview];
        _basedScrollView = nil;
    }];
    
    // 其他广播...
}


@end
