//
//  uploadManager.h
//  which
//
//  Created by alfred on 2017/5/2.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol uploadManagerDelegate <NSObject>
@required
- (void)uploadDoneWithIndex:(int)index withPicURL:(NSString *)picURL;
@end

@interface uploadManager : NSObject
@property (nonatomic, assign) id <uploadManagerDelegate> delegate;
- (void)requestQiniuTokenFromServerWithImage:(UIImage *)img withIndex:(int)index;
@end
