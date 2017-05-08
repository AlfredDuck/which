//
//  WCHVoteListCell.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHVoteListCell.h"
#import "WCHColorManager.h"
#import "YYWebImage.h"

@implementation WCHVoteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - custom cells

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // 一些初始化的值
        _txt = @"阿尔弗雷德鸭 投给了A";
        _portraitURL = @"https://img3.doubanio.com/icon/ul36544164-12.jpg";
        self.tag = 999999;
        
        /* 头像 */
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 24, 24)];
        _portraitImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds  = YES;
        // 圆角
        _portraitImageView.layer.cornerRadius = 12;
        [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
        [_portraitImageView.layer setBorderColor:[WCHColorManager lightPortraitline].CGColor];
        // 普通加载网络图片 yy库
        _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
        [self.contentView addSubview:_portraitImageView];
        
        
        /* 文本 */
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, _screenWidth-65, 24)];
        _txtLabel.text = _txt;
        _txtLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        _txtLabel.textColor = [WCHColorManager mainTextColor];
        [self.contentView addSubview:_txtLabel];
    
        
        // 背景、分割线
        _partLine = [[UIView alloc] initWithFrame:CGRectMake(50, 48-0.5, _screenWidth, 0.5)];
        _partLine.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
        [self.contentView addSubview:_partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


/** 重写头像 */
- (void)rewritePortrait:(NSString *)newPortraitURL
{
    _portraitURL = newPortraitURL;
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
}

/** 重写昵称 */
- (void)rewriteNickname:(NSString *)newNickname andVoteWhich:(NSString *)which
{
    NSString *ab = [which isEqualToString:@"0"] ? @" 投给了A": @" 投给了B";
    _txt = [newNickname stringByAppendingString: ab];
    _txtLabel.text =_txt;
}


@end
