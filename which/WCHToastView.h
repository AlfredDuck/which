//
//  WCHToastView.h
//  which
//
//  Created by alfred on 2017/5/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCHToastView : UIView
+ (void)showToastWith:(NSString *)text isErr:(BOOL)isErr duration:(double)duration superView:(UIView *)superView;

@end
