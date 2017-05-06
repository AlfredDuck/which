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
#import "WCHWelcomeVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "WCHUrlManager.h"
#import "WCHUserDefault.h"
#import "WCHToastView.h"

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_oneTableView.mj_header beginRefreshing];  // 触发下拉刷新
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
    titleLabel.text = @"· which ·";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size: 22.0];
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
    _oneTableView.backgroundColor = [WCHColorManager lightGrayBackground];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    // _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
    
    // 下拉刷新 MJRefresh
    _oneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新动作
        //            [_oneTableView.mj_header endRefreshing];
        //            NSLog(@"下拉刷新成功，结束刷新");
        //        });
        [self connectForPublishList];
    }];
    
    // 上拉刷新 MJRefresh (等到页面有数据后再使用)
    //    _oneTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self connectForMoreFollowedArticles:_oneTableView];
    //    }];
    
    // 这个碉堡了，要珍藏！！
    // _oneTableView.mj_header.ignoredScrollViewContentInsetTop = 100.0;
    
    // 禁用 mjRefresh
    // contentTableView.mj_footer = nil;
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
    [voteCell rewriteIfVoted:_voteData[row][@"votedStatus"]];
    
    NSInteger commentNum = [_voteData[row][@"commentNum"] intValue];
    NSInteger avote = [_voteData[row][@"voteNum"][0] intValue];
    NSInteger bvote = [_voteData[row][@"voteNum"][1] intValue];
    [voteCell rewriteNumWithVote:(avote+bvote) withComment:commentNum];
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
    NSUInteger row = [indexPath row];
    if (row == 0){
        WCHWelcomeVC *welcome = [[WCHWelcomeVC alloc] init];
        [self.navigationController presentViewController:welcome animated:YES completion:^{
            // code
        }];
    }
}





#pragma mark - voteCell 代理
- (void)clickVoteButtonWithIndex:(unsigned long)index
{
    WCHVoteListViewController *voteList = [[WCHVoteListViewController alloc] init];
    [self.navigationController pushViewController:voteList animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)clickCommentButtonWithIndex:(unsigned long)index
{
    
}

- (void)clickPicWithIndex:(unsigned long)index withWhichPic:(unsigned long)which
{
    NSLog(@"?????");
    // 获取登录信息
    NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
    NSLog(@"%@", loginInfo);
    
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
        // 返回值正常
        
//        NSLog(@"%@", [[_followedArticlesData objectAtIndex:index] objectForKey:@"title"]);
//        NSMutableDictionary *cellData = [[_followedArticlesData objectAtIndex:index] mutableCopy];
//        [cellData setValue:[data objectForKey:@"status"] forKey:@"likeStatus"];
//        [cellData setValue:[data objectForKey:@"likeNum"] forKey:@"likeNum"];
//        [_followedArticlesData replaceObjectAtIndex:index withObject:cellData];
//
        // 1.修改内存中的数据
        NSMutableDictionary *cellData = [[_voteData objectAtIndex:index] mutableCopy];
        [cellData setValue:@"yes" forKey:@"votedStatus"];
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
    // 获取登录信息
    NSDictionary *loginInfo = [WCHUserDefault readLoginInfo];
    NSLog(@"%@", loginInfo);
    
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/publish_list"];
    
    NSDictionary *parameters = @{@"uid": loginInfo[@"uid"]};
    
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
        // 返回值正常
        _voteData = [data mutableCopy];
        [_oneTableView reloadData];
        [_oneTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
        [_oneTableView.mj_header endRefreshing];
    }];
}



@end
