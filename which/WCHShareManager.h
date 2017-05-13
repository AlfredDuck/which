//
//  WCHShareManager.h
//  which
//
//  Created by alfred on 2017/5/13.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCHShareManager : NSObject
// share info （进入页面预先拉取，在内存中缓存）
@property (nonatomic, strong) NSDictionary *shareInfo;
@property (nonatomic, strong) UIImage *shareImageForWeibo;
@property (nonatomic, strong) UIImage *shareImageForWeixin;

/** 分享到微信/朋友圈 */
- (void)shareToWeixinWithTimeLine:(BOOL)isTimeLine;
/** 分享到新浪微博 */
- (void)shareToWeibo;
@end
