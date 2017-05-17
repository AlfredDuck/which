//
//  WCHHomeViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHHomeViewController.h"
#import "WCHColorManager.h"
#import "WCHVoteCell.h"
#import "WCHVoteListViewController.h"
#import "WCHCommentViewController.h"
#import "WCHWelcomeVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "WCHUrlManager.h"
#import "WCHUserDefault.h"
#import "WCHToastView.h"
#import "WCHTokenManager.h"

@interface WCHHomeViewController ()

@end

@implementation WCHHomeViewController

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
    [super createTabBarWith:0];  // 调用父类方法，构建tabbar
    [self createUIParts];
    [self createTableView];
    
    [self waitForNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!_voteData) {
        [_oneTableView.mj_header beginRefreshing];  // 触发下拉刷新
        
        // 启动时默认推送权限是关闭的
        [WCHUserDefault pushAuthorityIsClose];
        // 获取token（时机要在登录后，这样体验好些）
        if ([WCHUserDefault isLogin]) {
            [WCHTokenManager requestDeviceToken];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // uiviewcontroller 释放前会调用
    [[NSNotificationCenter defaultCenter] removeObserver:self];  // 注销观察者
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
    titleLabel.text = @"· 阿伯点点 ·";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
}


/** 创建 uitableview */
- (void)createTableView
{
    /* 创建 tableview */
    static NSString *CellWithIdentifier = @"voteCell";
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64-49)];
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
    MJRefreshNormalHeader *hh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self connectForPublishList];
    }];
    [hh setTitle:@"下拉刷新页面" forState:MJRefreshStateIdle];
    [hh.stateLabel setTextColor:[WCHColorManager lightTextColor]];
    [hh.stateLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
    [hh.lastUpdatedTimeLabel setTextColor:[WCHColorManager lightTextColor]];
    [hh.lastUpdatedTimeLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
    _oneTableView.mj_header = hh;
    
    
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
    _oneTableView.mj_header.ignoredScrollViewContentInsetTop = 15.0;
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
    [voteCell rewriteIfVoted:_voteData[row][@"votedStatus"] voteWhich:_voteData[row][@"which"] ifOwner:_voteData[row][@"isOwner"]];
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
    // 引导登录
    if (![WCHUserDefault isLogin]){
        WCHWelcomeVC *welcome = [[WCHWelcomeVC alloc] init];
        [self.navigationController presentViewController:welcome animated:YES completion:^{
            //
        }];
        return;
    }
    
    // 获取登录信息
    NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
    NSLog(@"%@", loginInfo);
    
    // 检查是否是投给自己
    if ([loginInfo[@"uid"] isEqualToString:_voteData[index][@"uid"]]){
        NSLog(@"不要给自己投票");
        [WCHToastView showToastWith:@"不要给自己投票啦😝" isErr:NO duration:1.8 superView:self.view];
        return;
    }
    
    // 检查是否已投过
    if ([_voteData[index][@"votedStatus"] isEqualToString:@"yes"]){
        NSLog(@"已投过");
        return;
    }

    NSNumber *whichPic = [NSNumber numberWithInt:(int)which];
    
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/do_vote"];
    
    NSDictionary *parameters = @{@"uid": loginInfo[@"uid"],
                                 @"publish_id": _voteData[index][@"_id"],
                                 @"which": whichPic};
    
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
        if (errcode == 1003){
            NSLog(@"已投票，不哟啊重复投");
            return;
        } else if (errcode == 1004){
            NSLog(@"发布者不能投票");
            return;
        }
        // 返回值正常
        // 1.修改内存中的数据
        NSMutableDictionary *cellData = [[_voteData objectAtIndex:index] mutableCopy];
        [cellData setValue:@"yes" forKey:@"votedStatus"];
        [cellData setValue:data[@"which"] forKey:@"which"];
        int aVote = [cellData[@"voteNum"][0] intValue];
        int bVote = [cellData[@"voteNum"][1] intValue];
        if ([data[@"which"] isEqualToString:@"1"]){
            bVote ++;
        } else if ([data[@"which"] isEqualToString:@"0"]){
            aVote ++;
        }
        NSArray *v = @[[NSString stringWithFormat:@"%d",aVote], [NSString stringWithFormat:@"%d",bVote]];
        [cellData setValue:v forKey:@"voteNum"];
        [_voteData replaceObjectAtIndex:index withObject:cellData];
        
        // 2.刷新特定的cell
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [_oneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
        [_oneTableView.mj_header endRefreshing];
    }];
}





#pragma mark - 网络请求

/** 请求 publish list 第一页数据 */
- (void)connectForPublishList
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/publish_list"];
    
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
        [_oneTableView.mj_footer resetNoMoreData];
        
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
    NSString *urlString = [host stringByAppendingString:@"/publish_list"];
    
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




#pragma mark - 接收广播
/** 注册广播观察者 **/
- (void)waitForNotification
{
    // 广播内容：登录状态变化
    [[NSNotificationCenter defaultCenter] addObserverForName:@"loginInfoChange" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        
        [_oneTableView.mj_header beginRefreshing];
    }];
    
    // 广播内容：发布了新投票
    [[NSNotificationCenter defaultCenter] addObserverForName:@"newPublish" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        
        [_oneTableView.mj_header beginRefreshing];
    }];
    
    // 其他广播...
}


@end
