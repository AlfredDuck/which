//
//  WCHVoteCell.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol voteCellDelegate <NSObject>

@required
- (void)clickVoteButtonWithIndex:(unsigned long)index;
- (void)clickCommentButtonWithIndex:(unsigned long)index;
- (void)clickPicWithIndex:(unsigned long)index withWhichPic:(unsigned long)which;

@end


@interface WCHVoteCell : UITableViewCell
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

/** 头像 */
@property (nonatomic, copy) NSString *portraitURL;
@property (nonatomic, copy) UIImageView *portraitImageView;
/** 标题 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UILabel *titleLabel;
/** 投票数 */
@property (nonatomic, copy) NSString *voteNum;
@property (nonatomic, copy) UIButton *voteNumButton;
/** 留言数 */
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) UIButton *commentNumButton;
/** 图片A */
@property (nonatomic, copy) NSString *picURLA;
@property (nonatomic, copy) UIImageView *picAImageView;
@property (nonatomic, copy) UILabel *voteLabelA;
/** 图片B */
@property (nonatomic, copy) NSString *picURLB;
@property (nonatomic, copy) UIImageView *picBImageView;
@property (nonatomic, copy) UILabel *voteLabelB;

/** 分割线 */
@property (nonatomic, copy) UIView *partLine;
/** cell高度 */
@property (nonatomic) unsigned long cellHeight;
/** cell的序号（tableview赋予的） */
@property (nonatomic) unsigned long cellIndex;

/** 代理 */
@property (nonatomic, assign) id <voteCellDelegate> delegate;


/** 重写各种参数 */
- (void)rewriteTitle:(NSString *)newTitle;
- (void)rewritePics:(NSArray *)newPics;
- (void)rewritePortrait:(NSString *)newPortraitURL;
- (void)rewriteNumWithVote:(NSInteger)newVoteNum withComment:(NSInteger)newCommentNum;
- (void)rewriteIfVoted:(NSString *)votedStatus;
- (void)rewriteVoteA:(NSInteger)voteA voteB:(NSInteger)voteB;
@end
