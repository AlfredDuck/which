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
        _voteNum = @"0人投票";
        _commentNum = @"0人留言";
        
        
        /* 头像 */
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_screenWidth/2.0-19, 20, 38, 38)];
        _portraitImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds  = YES;
        _portraitImageView.layer.cornerRadius = 20;  // 圆角
        [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
        [_portraitImageView.layer setBorderColor:[WCHColorManager lightPortraitline].CGColor];
        // 普通加载网络图片 yy库
        _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
        [self.contentView addSubview:_portraitImageView];
        
        
        /* 更多按钮 */
        UIImage *moreImage = [UIImage imageNamed:@"more.png"]; // 使用ImageView通过name找到图片
        UIImageView *moreImageView = [[UIImageView alloc] initWithImage:moreImage]; // 把oneImage添加到oneImageView上
        moreImageView.frame = CGRectMake(11, 20, 22, 4); // 设置图片位置和大小
        UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-47, 0, 44, 44)];
        [moreView addSubview:moreImageView];
        // 为UIView添加点击事件
        moreView.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *singleTapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreButton)]; // 设置手势
        [moreView addGestureRecognizer:singleTapMore]; // 给图片添加手势
        [self.contentView addSubview:moreView];
        
        
        /* 标题 */
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 78, _screenWidth-60, 25)];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size: 20];
        _titleLabel.textColor = [WCHColorManager mainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        
        
        /******************************* 图片组 ************************************/
        
        unsigned long ww = ceil(_screenWidth/2.0 - 1);
        unsigned long hh = ceil(ww/3.0*4.0);
        
        // A
        _picAImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        _picAImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _picAImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picAImageView.clipsToBounds  = YES;
        // 普通加载网络图片 yy库
        _picAImageView.yy_imageURL = [NSURL URLWithString:@""];
        _picAImageView.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *singleTapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicWithWhich:)]; // 设置手势
        [_picAImageView addGestureRecognizer:singleTapA]; // 给图片添加手势
        _picAImageView.tag = 1;
        [self.contentView addSubview:_picAImageView];
        
        // A 的遮黑
        _blackA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        _blackA.backgroundColor = [UIColor blackColor];
        _blackA.alpha = 0.28f;
        [_picAImageView addSubview:_blackA];
        
        // A 的myvote
        _myVoteA = [[UIImageView alloc] initWithFrame:CGRectMake((ww-31)/2.0, hh-31-15, 31, 31)];
        _myVoteA.image = [UIImage imageNamed:@"my_vote.png"];
        [_picAImageView addSubview:_myVoteA];
        
        // A 的投票人数
        _voteLabelA = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        _voteLabelA.text = @"49";
        _voteLabelA.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:48.0];
        _voteLabelA.textColor = [UIColor whiteColor];
        _voteLabelA.textAlignment = NSTextAlignmentCenter;
        [_picAImageView addSubview:_voteLabelA];
        
        
        // B
        _picBImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ww+2, 0, _screenWidth-ww-2, hh)];
        _picBImageView.backgroundColor = [WCHColorManager lightGrayBackground];
        // uiimageview居中裁剪
        _picBImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picBImageView.clipsToBounds  = YES;
        // 普通加载网络图片 yy库
        _picBImageView.yy_imageURL = [NSURL URLWithString:@""];
        _picBImageView.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *singleTapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicWithWhich:)]; // 设置手势
        [_picBImageView addGestureRecognizer:singleTapB]; // 给图片添加手势
        _picBImageView.tag = 2;
        [self.contentView addSubview:_picBImageView];
        
        // B 的遮黑
        _blackB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww+1, hh)];
        _blackB.backgroundColor = [UIColor blackColor];
        _blackB.alpha = 0.28f;
        [_picBImageView addSubview:_blackB];
        
        // B 的myvote
        _myVoteB = [[UIImageView alloc] initWithFrame:CGRectMake((ww-31)/2.0, hh-31-15, 31, 31)];
        _myVoteB.image = [UIImage imageNamed:@"my_vote.png"];
        [_picBImageView addSubview:_myVoteB];
        
        // B 的投票人数
        _voteLabelB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        _voteLabelB.text = @"278";
        _voteLabelB.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:48.0];
        _voteLabelB.textColor = [UIColor whiteColor];
        _voteLabelB.textAlignment = NSTextAlignmentCenter;
        [_picBImageView addSubview:_voteLabelB];
        
        
        
        
        
        
        /* 投票人数 */
        // 创建一个自适应宽度的button
        _voteNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voteNumButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 12];
        //对按钮的外形做了设定，不喜可删~
        _voteNumButton.layer.masksToBounds = YES;
        _voteNumButton.layer.cornerRadius = 12;
        
        [_voteNumButton setTitleColor:[WCHColorManager commonPink] forState:UIControlStateNormal];
        [_voteNumButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:228/255.0 blue:234/255.0 alpha:1.0]];
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
        _commentNumButton.layer.cornerRadius = 12;
        
        [_commentNumButton setTitleColor:[WCHColorManager commonPink] forState:UIControlStateNormal];
        [_commentNumButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:228/255.0 blue:234/255.0 alpha:1.0]];
        [_commentNumButton setTitle:_commentNum forState:UIControlStateNormal];
        [_commentNumButton addTarget:self action:@selector(clickCommentNumButton) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
        CGSize titleSize2 = [_commentNum sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_commentNumButton.titleLabel.font.fontName size:_commentNumButton.titleLabel.font.pointSize]}];
        titleSize2.height = 24;
        titleSize2.width += 18;
        
        _commentNumButton.frame = CGRectMake(_screenWidth/2.0+5, 0, titleSize2.width, titleSize2.height);
        [self.contentView addSubview:_commentNumButton];
        
        
        /* 背景、分割线 */
        _partLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 15)];
        _partLine.backgroundColor = [WCHColorManager commonBackground];
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
    style.alignment = NSTextAlignmentCenter;  //居中
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _titleLabel.attributedText = text;
    
    // =================== 设置UIlabel文本折行 ====================
    NSString *str = _title;
    CGSize maxSize = {_screenWidth-60, 5000};  // 设置文本区域最大宽高
    CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"PingFangSC-Thin" size:20]
                       constrainedToSize:maxSize
                           lineBreakMode:_titleLabel.lineBreakMode];   // str是要显示的字符串
    unsigned long height = labelSize.height/20.0*20.0;  // 因为行距增加了，所以要用参数修正height
    _titleLabel.frame = CGRectMake(30, 78, _screenWidth-60, height);
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
    _picBImageView.frame = CGRectMake(ww+2, _cellHeight, _screenWidth-ww-2, hh);
    // 修改partline位置
    _partLine.frame = CGRectMake(0, _cellHeight+hh, _screenWidth, 15);
    
    _cellHeight += (hh+15);
    
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


/** 重写头像 */
- (void)rewritePortrait:(NSString *)newPortraitURL
{
    _portraitURL = newPortraitURL;
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
}


/** 重写投票&留言数量 */
- (void)rewriteNumWithVote:(NSInteger)newVoteNum withComment:(NSInteger)newCommentNum
{
    _voteNum = [NSString stringWithFormat:@"%ld人投票", (long)newVoteNum];
    [_voteNumButton setTitle:_voteNum forState:UIControlStateNormal];
    
    _commentNum = [NSString stringWithFormat:@"%ld人留言", (long)newCommentNum];
    [_commentNumButton setTitle:_commentNum forState:UIControlStateNormal];
}


/** 重写是否已投票，投了哪一项；是否是自己发布的 */
- (void)rewriteIfVoted:(NSString *)votedStatus voteWhich:(NSString *)which ifOwner:(NSString *)isOwner
{
    // 是否是自己发布的
    if ([isOwner isEqualToString:@"yes"]) {
        _voteLabelA.hidden = NO;
        _voteLabelB.hidden = NO;
        _blackA.hidden = NO;
        _blackB.hidden = NO;
        _myVoteA.hidden = YES;
        _myVoteB.hidden = YES;
        return;
    }
    
    // 是否已投票
    if ([votedStatus isEqualToString:@"yes"]) {
        _voteLabelA.hidden = NO;
        _voteLabelB.hidden = NO;
        _blackA.hidden = NO;
        _blackB.hidden = NO;
        // 投了哪一项
        if ([which isEqualToString:@"1"]) {
            _myVoteA.hidden = YES;
            _myVoteB.hidden = NO;
        } else {  // "0"
            _myVoteA.hidden = NO;
            _myVoteB.hidden = YES;
        }
    } else {
        _voteLabelA.hidden = YES;
        _voteLabelB.hidden = YES;
        _blackA.hidden = YES;
        _blackB.hidden = YES;
        _myVoteA.hidden = YES;
        _myVoteB.hidden = YES;
    }
}


/** 重写图片上的投票数字 */
- (void)rewriteVoteA:(NSInteger)voteA voteB:(NSInteger)voteB
{
    _voteLabelA.text = [NSString stringWithFormat:@"%ld", (long)voteA];
    _voteLabelB.text = [NSString stringWithFormat:@"%ld", (long)voteB];
}



#pragma mark - IBAction
- (void)clickVoteNumButton
{
    NSLog(@"clickVoteNumButton:%lu", _cellIndex);
    [self.delegate clickVoteButtonWithIndex:_cellIndex];
}

- (void)clickCommentNumButton
{
    NSLog(@"clickCommentNumButton:%lu", _cellIndex);
    [self.delegate clickCommentButtonWithIndex:_cellIndex];
}

- (void)clickPicWithWhich:(UIGestureRecognizer *)sender
{
    NSLog(@"clickCommentNumButton:%lu,%lu", _cellIndex, sender.view.tag-1);
    [self.delegate clickPicWithIndex:_cellIndex withWhichPic:sender.view.tag - 1];
}

- (void)clickMoreButton
{
    NSLog(@"clickMoreButton:%lu", _cellIndex);
    [self.delegate clickMoreButtonWithIndex:_cellIndex];
}





@end
