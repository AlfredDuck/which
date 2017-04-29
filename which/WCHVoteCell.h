//
//  WCHVoteCell.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

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
/** 图片B */
@property (nonatomic, copy) NSString *picURLB;
@property (nonatomic, copy) UIImageView *picBImageView;
/** 分割线 */
@property (nonatomic, copy) UIView *partLine;
/** cell高度 */
@property (nonatomic) unsigned long cellHeight;


/** 重写各种参数 */
- (void)rewriteTitle:(NSString *)newTitle;
- (void)rewritePics:(NSArray *)newPics;

@end
