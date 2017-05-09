//
//  WCHCommentViewController.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHCommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
// 文章id
@property (nonatomic, strong) NSString *publishID;

// tableview
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *commentDataSource;

// 储存cell高度
@property (nonatomic, strong) NSMutableArray *cellHeightArray; // 专门用来存储cell高度

// 内容区域的基础父view
@property (nonatomic, strong) UIView *contentFatherView;
// 小菊花
@property (nonatomic, strong) UIActivityIndicatorView *loadingFlower;
@property (nonatomic, strong) UILabel *loadingTextLabel;
// 重新加载按钮
@property (nonatomic, strong) UIButton *reloadButton;

//
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
@end
