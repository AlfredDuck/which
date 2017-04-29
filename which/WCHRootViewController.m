//
//  WCHRootViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHRootViewController.h"
#import "WCHHomeViewController.h"
#import "WCHMineViewController.h"

@interface WCHRootViewController ()

@end

@implementation WCHRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor whiteColor];
        //隐藏系统提供的tabbar
        [self.tabBar setHidden:YES];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self createFirstLevelPages];
    //[self createTabBar];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建 First Level 页面

- (void)createFirstLevelPages
{
    // 创建若干个VC
    WCHHomeViewController *homeVC = [[WCHHomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.navigationBar.hidden = YES;
    
    WCHMineViewController *mineVC = [[WCHMineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.navigationBar.hidden = YES;
    
    // 将这几个Nav放入数组
    NSArray *viewControllers = @[homeNav, mineNav];
    
    //数组添加到tabBarController
    //   UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //tabBarController.viewControllers  = viewControllers;
    [self setViewControllers:viewControllers animated:YES];
    
}

@end
