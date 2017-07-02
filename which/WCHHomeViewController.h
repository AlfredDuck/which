//
//  WCHHomeViewController.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCHBasedTabViewController.h"
#import "WCHVoteCell.h"

@interface WCHHomeViewController : WCHBasedTabViewController <UITableViewDelegate, UITableViewDataSource, voteCellDelegate, UIActionSheetDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽

/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *voteData;
@end
