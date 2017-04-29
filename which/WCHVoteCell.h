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
@property (nonnull, copy) NSString *portraitURL;
@property (nonnull, copy) UIImageView *portraitImageView;
/** 标题 */
@property (nonnull, copy) NSString *title;
@property (nonnull, copy) UILabel *titleLabel;
/** 投票数 */
@property (nonnull, copy) NSString *voteNum;
@property (nonnull, copy) UIButton *voteNumButton;
/** 留言数 */
@property (nonnull, copy) NSString *commentNum;
@property (nonnull, copy) UIButton *commentNumButton;
/** 图片 */

@end
