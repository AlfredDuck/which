//
//  WCHBasedTabViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHBasedTabViewController.h"
#import "WCHColorManager.h"
#import "WCHPublishViewController.h"
#import "WCHUserDefault.h"
#import "WCHWelcomeVC.h"

@interface WCHBasedTabViewController ()

@end

@implementation WCHBasedTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenH = [UIScreen mainScreen].bounds.size.height;
    _screenW = [UIScreen mainScreen].bounds.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 创建底部 tabBar
- (void)createTabBarWith:(int)index
{
    /* tabbar 背景 */
    _tabBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _screenH-49, _screenW, 49)];
    _tabBarBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBarBackgroundView];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenW, 0.5)];
    line.backgroundColor = [WCHColorManager lightGrayLineColor];
    [_tabBarBackgroundView addSubview:line];
    
    // NSArray *tabText = @[@"home",@"mine"];
    
    /* 循环创建2个底部tab（置灰状态） */
    for (int i=0; i<2; i++) {
        UIView *tabView = [[UIView alloc] init];
        tabView.backgroundColor  = [UIColor whiteColor];
        tabView.tag = 1+i;
        if (i==0){
            tabView.frame = CGRectMake(0, 0.5, ceil((_screenW-44)/2.0), 44);  // 这里要取整
        } else {
            tabView.frame = CGRectMake(ceil((_screenW-44)/2.0+44), 0.5, ceil((_screenW-44)/2.0), 44);
        }
        
        
        // 添加icon图
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(tabView.frame.size.width/2.0-22, 1.5, 44, 44)];
        [tabView addSubview:iconView];
        UIImageView *icon = [[UIImageView alloc] init];
        // 每个tab的icon图尺寸不一样，需要单独写尺寸
        if (i==0) {
            icon.image = [UIImage imageNamed:@"home.png"];
            icon.frame = CGRectMake(9, 9.5, 26, 25);
        } else if (i == 1) {
            icon.image = [UIImage imageNamed:@"mine.png"];
            icon.frame = CGRectMake(10, 9, 24, 26);
        }
        
        [iconView addSubview: icon];
        
        // 设置手势
        tabView.userInteractionEnabled = YES; // 设置view可以交互
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTab:)];   // 设置手势
        [tabView addGestureRecognizer:singleTap]; // 给view添加手势
        
        [_tabBarBackgroundView addSubview:tabView];
    }
    
    
    /* 循环创建三个底部tab（选中状态） */
    for (int i=0; i<2; i++) {
        UIView *tabView = [[UIView alloc] init];
        tabView.backgroundColor  = [UIColor whiteColor];
        tabView.tag = i+4;  // 添加tag
        tabView.hidden = YES;
        if (i==0){
            tabView.frame = CGRectMake(0, 0.5, ceil((_screenW-44)/2.0), 44);  // 这里要取整
        } else {
            tabView.frame = CGRectMake(ceil((_screenW-44)/2.0+44), 0.5, ceil((_screenW-44)/2.0), 44);
        }
        
        // 初始状态第一个tab是焦点状态
        if (i == index) {
            tabView.hidden = NO;
        }
        
        // 添加icon图
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(tabView.frame.size.width/2.0-22, 1.5, 44, 44)];
        [tabView addSubview:iconView];
        UIImageView *icon = [[UIImageView alloc] init];
        // 每个tab的icon图尺寸不一样，需要单独写尺寸
        if (i==0) {
            icon.image = [UIImage imageNamed:@"home_focus.png"];
            icon.frame = CGRectMake(9, 9.5, 26, 25);
        } else if (i == 1) {
            icon.image = [UIImage imageNamed:@"mine_focus.png"];
            icon.frame = CGRectMake(10, 9, 24, 26);
        }
        
        [iconView addSubview: icon];
        [_tabBarBackgroundView addSubview:tabView];
    }
    
    
    /** 中间发布按钮 */
    UIView *publishView = [[UIImageView alloc] initWithFrame:CGRectMake(_screenW/2.0-22, 1.5, 44, 44)];
    UIImageView *publishImageView = [[UIImageView alloc] init];
    publishImageView.image = [UIImage imageNamed:@"publish.png"];
    publishImageView.frame = CGRectMake(9.5, 9.5, 25, 25);
    [publishView addSubview:publishImageView];
    
    // 设置手势
    publishView.userInteractionEnabled = YES; // 设置view可以交互
    UITapGestureRecognizer *publishSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPublishTab)];   // 设置手势
    [publishView addGestureRecognizer:publishSingleTap]; // 给view添加手势
    
    [_tabBarBackgroundView addSubview:publishView];
}



#pragma mark - IBAction
- (void)clickTab:(UIGestureRecognizer *)sender
{
    // NSLog(@"%ld", sender.view.tag);
    /* 移动tab焦点 */
    self.tabBarController.selectedIndex = sender.view.tag - 1;
}

- (void)clickPublishTab
{
    NSLog(@"点击‘发布+’按钮");
    // 检查是否登录
    if ([WCHUserDefault isLogin]) {
        WCHPublishViewController *publishPage = [[WCHPublishViewController alloc] init];
        publishPage.previousPage = self;
        [self.navigationController presentViewController:publishPage animated:YES completion:nil];
    } else {
        // 吊起登录
        WCHWelcomeVC *welcome = [[WCHWelcomeVC alloc] init];
        [self.navigationController presentViewController:welcome animated:YES completion:^{
            // code
        }];
    }
}


@end
