//
//  WCHVoteListViewController.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHVoteListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *voteData;
@end
