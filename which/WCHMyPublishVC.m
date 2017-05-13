//
//  WCHMyPublishVC.m
//  which
//
//  Created by alfred on 2017/5/13.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHMyPublishVC.h"
#import "WCHColorManager.h"
#import "WCHUserDefault.h"
#import "WCHUrlManager.h"
#import "AFNetworking.h"
#import "WCHToastView.h"
#import "MJRefresh.h"
#import "WCHVoteCell.h"
#import "WCHVoteListViewController.h"
#import "WCHCommentViewController.h"

@interface WCHMyPublishVC ()

@end

@implementation WCHMyPublishVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [WCHColorManager lightGrayBackground];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    /* 构建页面元素 */
    [self createUIParts];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self connectForPublishList];
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
    titleLabel.text = @"我发起的投票";
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



/** 创建 uitableview */
- (void)createTableView
{
    /* 创建 tableview */
    static NSString *CellWithIdentifier = @"voteCell";
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64)];
    _oneTableView.backgroundColor = [UIColor brownColor];
    [_oneTableView setDelegate:self];
    [_oneTableView setDataSource:self];
    
    [_oneTableView registerClass:[WCHVoteCell class] forCellReuseIdentifier:CellWithIdentifier];
    _oneTableView.backgroundColor = [WCHColorManager commonBackground];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
    
    
    // 下拉刷新 MJRefresh
//    MJRefreshNormalHeader *hh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self connectForPublishList];
//    }];
//    [hh setTitle:@"下拉刷新页面" forState:MJRefreshStateIdle];
//    [hh.stateLabel setTextColor:[WCHColorManager lightTextColor]];
//    [hh.stateLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
//    [hh.lastUpdatedTimeLabel setTextColor:[WCHColorManager lightTextColor]];
//    [hh.lastUpdatedTimeLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
//    _oneTableView.mj_header = hh;
    
    
    // 上拉加载更多
    MJRefreshAutoNormalFooter *ff = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self connectForMorePublish];
    }];
    [ff setTitle:@"· end ·" forState: MJRefreshStateNoMoreData];
    [ff setTitle:@"滑动加载更多" forState: MJRefreshStateIdle];
    [ff setTitle:@"加载中···" forState: MJRefreshStateRefreshing];
    [ff.stateLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
    [ff.stateLabel setTextColor:[WCHColorManager lightTextColor]];
    _oneTableView.mj_footer = ff;
    
    
    // 这个碉堡了，要珍藏！！
    // _oneTableView.mj_header.ignoredScrollViewContentInsetTop = 15.0;
}



#pragma mark - UITableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_voteData count];
}


// 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"voteCell";
    WCHVoteCell *voteCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if ( voteCell == nil) {  // 这里if的条件如果用yes，代表不使用复用池
        voteCell = [[WCHVoteCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
    voteCell.delegate = self;
    [voteCell setCellIndex:(unsigned long)row];
    [voteCell rewriteTitle:_voteData[row][@"text"]];
    [voteCell rewritePics:_voteData[row][@"pics"]];
    [voteCell rewritePortrait:_voteData[row][@"user"][@"portrait"]];
    
    NSInteger commentNum = [_voteData[row][@"commentNum"] intValue];
    NSInteger avote = [_voteData[row][@"voteNum"][0] intValue];
    NSInteger bvote = [_voteData[row][@"voteNum"][1] intValue];
    [voteCell rewriteNumWithVote:(avote+bvote) withComment:commentNum];
    [voteCell rewriteIfVoted:_voteData[row][@"votedStatus"] voteWhich:_voteData[row][@"which"] ifOwner:@"yes"];
    [voteCell rewriteVoteA:avote voteB:bvote];
    
    voteCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
    return voteCell;
}


// 改变 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCHVoteCell *cell = (WCHVoteCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


// tableView 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




#pragma mark - voteCell 代理
- (void)clickVoteButtonWithIndex:(unsigned long)index
{
    WCHVoteListViewController *voteList = [[WCHVoteListViewController alloc] init];
    voteList.publishID = _voteData[index][@"_id"];
    [self.navigationController pushViewController:voteList animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)clickCommentButtonWithIndex:(unsigned long)index
{
    WCHCommentViewController *commentPage = [[WCHCommentViewController alloc] init];
    commentPage.publishID = _voteData[index][@"_id"];
    [self.navigationController pushViewController:commentPage animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)clickPicWithIndex:(unsigned long)index withWhichPic:(unsigned long)which
{
    
}




#pragma mark - IBAction
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 网络请求

/** 请求 publish list 第一页数据 */
- (void)connectForPublishList
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/my_publish_list"];
    
    NSDictionary *parameters;
    if ([WCHUserDefault isLogin]) {
        // 获取登录信息
        NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
        NSLog(@"%@", loginInfo);
        parameters = @{@"uid": loginInfo[@"uid"],
                       @"type": @"refresh"};
    } else {
        parameters = @{@"type": @"refresh"};
    }
    
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSArray *data = responseObject[@"data"];
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
        // 返回值正常
        _voteData = [data mutableCopy];
        [_oneTableView reloadData];
        [_oneTableView.mj_header endRefreshing];
        if ([_voteData count] < 10) {
            [_oneTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
        [_oneTableView.mj_header endRefreshing];
    }];
}



/** 请求 publish list 更多数据 */
- (void)connectForMorePublish
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/my_publish_list"];
    
    NSDictionary *parameters;
    if ([WCHUserDefault isLogin]) {
        // 获取登录信息
        NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
        NSLog(@"%@", loginInfo);
        parameters = @{@"uid": loginInfo[@"uid"],
                       @"type": @"more",
                       @"last_id": [_voteData lastObject][@"_id"]};
    } else {
        parameters = @{@"type": @"more",
                       @"last_id": [_voteData lastObject][@"_id"]};
    }
    
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSArray *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        // 返回值报错
        if (errcode == 1001){
            [WCHToastView showToastWith:@"数据库君这会儿有点晕，请稍后再试" isErr:NO duration:3.0f superView:self.view];
            return;
        } else if (errcode == 1003){ // 没有更多数据
            [_oneTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        // 返回值正常
        [_voteData addObjectsFromArray:data];
        [_oneTableView reloadData];
        [_oneTableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
        [_oneTableView.mj_footer endRefreshing];
    }];
}



@end
