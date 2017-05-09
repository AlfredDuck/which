//
//  WCHWriteCommentViewController.h
//  which
//
//  Created by alfred on 2017/4/29.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHWriteCommentViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) NSString *pageTitle;  // 页面标题
@property (nonatomic, strong) NSString *publishID;  // 要评论的文章id
@property (nonatomic, strong) UIButton *sendButton;  // 发送按钮

@property (nonatomic, strong) UITextView *contentTextView;  // 评论输入框
@property (nonatomic, strong) UILabel *placeholder;  // 自定义 UITextView 的 placeholder

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

// block用法, 必须有参数(多个)，参数只能是id类型
typedef void(^callbackDoSomething)(id);
@property (nonatomic, copy) callbackDoSomething writeCommentSuccess;

@end
