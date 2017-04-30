//
//  WCHVoteListCell.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHVoteListCell : UITableViewCell
// 头像
@property (nonatomic, copy) NSString *portraitURL;
@property (nonatomic, copy) UIImageView *portraitImageView;
// 文本
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) UILabel *txtLabel;
// 整体cell高度
@property (nonatomic) float cellHeight;
// 分割线
@property (nonatomic, copy) UIView *partLine;
//
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

@end
