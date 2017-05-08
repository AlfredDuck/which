//
//  WCHNicknameVC.h
//  which
//
//  Created by alfred on 2017/5/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHNicknameVC : UIViewController <UITextFieldDelegate>
/* 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/* 昵称输入框 */
@property (nonatomic, strong) UITextField *nickNameTextField;
/* 昵称和uid */
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *uid;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

// block用法
/**
 *  定义了一个changeColor的Block。这个changeColor必须带一个参数，这个参数的类型必须为id类型的
 *  无返回值
 *  @param id
 */
typedef void(^callbackDoSomething)(id,id);
/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) callbackDoSomething sendSuccess;
// 参考文档：http://www.jianshu.com/p/17872da184fb


@end
