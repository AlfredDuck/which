//
//  WCHPublishViewController.h
//  which
//
//  Created by alfred on 2017/4/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHPublishViewController : UIViewController <UITextViewDelegate>
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
@property (nonatomic, strong) UIButton *sendButton;  // 发送按钮
@property (nonatomic, strong) UITextView *contentTextView;  // 输入框
@property (nonatomic, strong) UILabel *placeholder;  // 自定义 UITextView 的 placeholder

@end
