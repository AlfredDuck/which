//
//  WCHCommentCell.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHCommentCell : UITableViewCell
// 头像
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) UIImageView *picImageView;
// 昵称
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) UILabel *nicknameLabel;
// 评论内容
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) UILabel *commentLabel;
// 发布时间
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) UILabel *createTimeLabel;

// 整体cell高度
@property (nonatomic) float cellHeight;
// 分割线
@property (nonatomic, copy) UIView *partLine;
//
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

//
- (void)rewritePortrait:(NSString *)newPortrait;
- (void)rewriteNickname:(NSString *)newNickname;
- (void)rewriteComment:(NSString *)newComment;
- (void)rewriteCreateTime:(NSString *)newCreateTime;
@end
