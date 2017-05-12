//
//  WCHVoteListViewController.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHVoteListViewController.h"
#import "WCHColorManager.h"
#import "WCHVoteListCell.h"
#import "AFNetworking.h"
#import "WCHUrlManager.h"
#import "WCHToastView.h"
#import "WCHUserDefault.h"
#import "MJRefresh.h"

@interface WCHVoteListViewController ()

@end

@implementation WCHVoteListViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIParts];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self connectForVoteRecordList];
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
    titleLabel.text = @"记票板";
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


/** 创建tableview */
- (void)createTableView
{
    /* 创建 tableview */
    static NSString *CellWithIdentifier = @"voteListCell";
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64)];
    _oneTableView.backgroundColor = [UIColor brownColor];
    [_oneTableView setDelegate:self];
    [_oneTableView setDataSource:self];
    
    [_oneTableView registerClass:[WCHVoteListCell class] forCellReuseIdentifier:CellWithIdentifier];
    _oneTableView.backgroundColor = [UIColor whiteColor];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    // _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
    
    // 下拉刷新 MJRefresh
    //    _oneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    //        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        //            // 结束刷新动作
    //        //            [_oneTableView.mj_header endRefreshing];
    //        //            NSLog(@"下拉刷新成功，结束刷新");
    //        //        });
    //        [self connectForHot:_oneTableView];
    //        [self connectForFollowedArticles:_oneTableView];
    //    }];
    
    // 上拉刷新 MJRefresh (等到页面有数据后再使用)
    //    _oneTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self connectForMoreFollowedArticles:_oneTableView];
    //    }];
    
    // 上拉加载更多
    MJRefreshAutoNormalFooter *ff = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self connectForMoreVoteRecord];
    }];
    [ff setTitle:@"· end ·" forState: MJRefreshStateNoMoreData];
    [ff setTitle:@"滑动加载更多" forState: MJRefreshStateIdle];
    [ff setTitle:@"加载中···" forState: MJRefreshStateRefreshing];
    [ff.stateLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
    [ff.stateLabel setTextColor:[WCHColorManager lightTextColor]];
    _oneTableView.mj_footer = ff;
    
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
    static NSString *cellWithIdentifier = @"voteListCell";
    WCHVoteListCell *voteListCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if ( voteListCell == nil) {
        voteListCell = [[WCHVoteListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
    [voteListCell rewriteNickname: _voteData[row][@"user"][@"nickname"] andVoteWhich:_voteData[row][@"which"]];
    [voteListCell rewritePortrait: _voteData[row][@"user"][@"portrait"]];
    voteListCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
    return voteListCell;
}


// 改变 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}


// tableView 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




#pragma mark - IBAction 
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 网络请求
/** 请求数据：refresh*/
- (void)connectForVoteRecordList
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/vote_record_list"];
    
    NSDictionary *parameters = @{@"publish_id": _publishID,
                                 @"type": @"refresh"};
    
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
        if (errcode == 1001 || errcode == 1002) {
            NSString *txt;
            if (errcode == 1001) {
                txt = @"数据库君这会儿有点晕，请稍后再试";
            } else {
                txt = @"操作出错，请火速联系管理员";
            }
            [WCHToastView showToastWith:txt isErr:NO duration:3.0f superView:self.view];
            return;
        } else if (errcode == 1003) {  // 没有更多数据了
            [_oneTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        // 返回值正常
        _voteData = [data mutableCopy];
        [_oneTableView reloadData];
        
        if ([_voteData count] < 15) {
            [_oneTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
    }];
}



/** 请求数据：more */
- (void)connectForMoreVoteRecord
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/vote_record_list"];
    
//    NSDictionary *parameters = @{@"publish_id": _publishID,
//                                 @"type": @"more",
//                                 @"last_id": [[_voteData lastObject] objectForKey:@"_id"]};
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
        _publishID, @"publish_id",
        @"more", @"type",
        [_voteData lastObject][@"_id"], @"last_id",
        nil];
    
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: dic success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSArray *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        
        // 返回值报错
        if (errcode == 1001 || errcode == 1002) {
            NSString *txt;
            if (errcode == 1001) {
                txt = @"数据库君这会儿有点晕，请稍后再试";
            } else {
                txt = @"操作出错，请火速联系管理员";
            }
            [WCHToastView showToastWith:txt isErr:NO duration:3.0f superView:self.view];
            return;
        } else if (errcode == 1003) {  // 没有更多数据了
            [_oneTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        // 返回值正常
        [_voteData addObjectsFromArray:data];
        [_oneTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [WCHToastView showToastWith:@"请检查网络" isErr:NO duration:3.0f superView:self.view];
    }];
}




@end
