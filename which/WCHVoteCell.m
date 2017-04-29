//
//  WCHVoteCell.m
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHVoteCell.h"
#import "WCHColorManager.h"
#import "YYWebImage.h"

@implementation WCHVoteCell

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
        _title = @"新程序员还没有弄懂分解问题和将解决方法变成代码之前，就给他们介绍面向对象是大错特错";
        _portraitURL = @"https://img5.doubanio.com/view/photo/albumicon/public/p2411938386.jpg";
        _voteNum = @"23人投票";
        _commentNum = @"123456789人留言";
        
        
        /* 头像 */
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_screenWidth/2.0-19, 20, 38, 38)];
        _portraitImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds  = YES;
        // 圆角
        _portraitImageView.layer.cornerRadius = 20;
        [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
        [_portraitImageView.layer setBorderColor:[WCHColorManager lightPortraitline].CGColor];
        // 普通加载网络图片 yy库
        _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
        [self.contentView addSubview:_portraitImageView];
        
        
        /* 标题 */
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 78, _screenWidth-60, 25)];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size: 20];
        _titleLabel.textColor = [WCHColorManager mainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        /* 图片组 */
        unsigned long ww = _screenWidth/2.0 - 1;
        unsigned long hh = ceil(ww/3.0*4.0);
        
        _picAImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        _picAImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _picAImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picAImageView.clipsToBounds  = YES;
        // 普通加载网络图片 yy库
        _picAImageView.yy_imageURL = [NSURL URLWithString:@""];
        [self.contentView addSubview:_picAImageView];
        
        _picBImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ww+2, 0, ww, hh)];
        _picBImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _picBImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picBImageView.clipsToBounds  = YES;
        // 普通加载网络图片 yy库
        _picBImageView.yy_imageURL = [NSURL URLWithString:@""];
        [self.contentView addSubview:_picBImageView];
        
        
        /* 投票人数 */
        // 创建一个自适应宽度的button
        _voteNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voteNumButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 12];
        //对按钮的外形做了设定，不喜可删~
        _voteNumButton.layer.masksToBounds = YES;
        _voteNumButton.layer.borderWidth = 0.5;
        _voteNumButton.layer.borderColor = [[WCHColorManager commonPink] CGColor];
        _voteNumButton.layer.cornerRadius = 12;
        
        [_voteNumButton setTitleColor:[WCHColorManager commonPink] forState:UIControlStateNormal];
        [_voteNumButton setBackgroundColor:[UIColor whiteColor]];
        [_voteNumButton setTitle:_voteNum forState:UIControlStateNormal];
        [_voteNumButton addTarget:self action:@selector(clickVoteNumButton) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
        CGSize titleSize = [_voteNum sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_voteNumButton.titleLabel.font.fontName size:_voteNumButton.titleLabel.font.pointSize]}];
        titleSize.height = 24;
        titleSize.width += 18;
        
        _voteNumButton.frame = CGRectMake(_screenWidth/2.0-5-titleSize.width, 0, titleSize.width, titleSize.height);
        [self.contentView addSubview:_voteNumButton];
        
        
        /* 留言人数 */
        // 创建一个自适应宽度的button
        _commentNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentNumButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 12];
        //对按钮的外形做了设定，不喜可删~
        _commentNumButton.layer.masksToBounds = YES;
        _commentNumButton.layer.borderWidth = 0.5;
        _commentNumButton.layer.borderColor = [[WCHColorManager commonPink] CGColor];
        _commentNumButton.layer.cornerRadius = 12;
        
        [_commentNumButton setTitleColor:[WCHColorManager commonPink] forState:UIControlStateNormal];
        [_commentNumButton setBackgroundColor:[UIColor whiteColor]];
        [_commentNumButton setTitle:_commentNum forState:UIControlStateNormal];
        [_commentNumButton addTarget:self action:@selector(clickCommentNumButton) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
        CGSize titleSize2 = [_commentNum sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_commentNumButton.titleLabel.font.fontName size:_commentNumButton.titleLabel.font.pointSize]}];
        titleSize2.height = 24;
        titleSize2.width += 18;
        
        _commentNumButton.frame = CGRectMake(_screenWidth/2.0+5, 0, titleSize2.width, titleSize2.height);
        [self.contentView addSubview:_commentNumButton];
        
        
        /* 背景、分割线 */
        _partLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 20)];
        _partLine.backgroundColor = [WCHColorManager lightGrayBackground];
        [self.contentView addSubview:_partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}




/** 重写标题 **/
- (void)rewriteTitle:(NSString *)newTitle
{
    _title = newTitle;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_title];
    //设置行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;  //行距
    style.alignment = NSTextAlignmentCenter;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _titleLabel.attributedText = text;
    
    // =================== 设置UIlabel文本折行 ====================
    NSString *str = _title;
    CGSize maxSize = {_screenWidth-60, 5000};  // 设置文本区域最大宽高
    CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"PingFangSC-Thin" size:20]
                       constrainedToSize:maxSize
                           lineBreakMode:_titleLabel.lineBreakMode];   // str是要显示的字符串
    unsigned long height = labelSize.height/20.0*20.0;
    _titleLabel.frame = CGRectMake(30, 78, labelSize.width, height);  // 因为行距增加了，所以要用参数修正height
    _titleLabel.numberOfLines = 0;  // 不可少Label属性之一
    //_postTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;  // 不可少Label属性之二
    
    // 记录cell高度
    _cellHeight = _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 20.0;
    
    /** 修改下方各项的位置 **/
    // 修改按钮位置
    _voteNumButton.frame = CGRectMake(_voteNumButton.frame.origin.x, _cellHeight, _voteNumButton.frame.size.width, _voteNumButton.frame.size.height);
    _commentNumButton.frame = CGRectMake(_commentNumButton.frame.origin.x, _cellHeight, _commentNumButton.frame.size.width, _commentNumButton.frame.size.height);
    _cellHeight += (20.0+_voteNumButton.frame.size.height);
    // 修改图片位置
    unsigned long ww = _screenWidth/2.0 - 1;
    unsigned long hh = ceil(ww/3.0*4.0);
    _picAImageView.frame = CGRectMake(0, _cellHeight, ww, hh);
    _picBImageView.frame = CGRectMake(ww+2, _cellHeight, ww, hh);
    // 修改partline位置
    _partLine.frame = CGRectMake(0, _cellHeight+hh, _screenWidth, 20);
    
    _cellHeight += (hh+20);
    
}


/** 重写图片 */
- (void)rewritePics:(NSArray *)newPics
{
    if ([newPics count] > 1) {
        _picURLA = newPics[0];
        _picURLB = newPics[1];
        _picAImageView.yy_imageURL = [NSURL URLWithString:_picURLA];
        _picBImageView.yy_imageURL = [NSURL URLWithString:_picURLB];
    }
}


#pragma mark - IBAction
- (void)clickVoteNumButton
{
    NSLog(@"clickVoteNumButton");
}

- (void)clickCommentNumButton
{
    NSLog(@"clickCommentNumButton");
}






@end
