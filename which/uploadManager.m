//
//  uploadManager.m
//  which
//
//  Created by alfred on 2017/5/2.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "uploadManager.h"
#import "WCHUrlManager.h"
#import "AFNetworking.h"
#import <QiniuSDK.h>

@implementation uploadManager

/** 获取qiniu上传token */
- (void)requestQiniuTokenFromServerWithImage:(UIImage *)img withIndex:(int)index
{
    // prepare request parameters
    NSString *host = [WCHUrlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/upload"];

    NSDictionary *parameters = @{@"filename": @"..."};
    // 创建 GET 请求（AF 3.0）
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 20.0;  // 设置超时时间
    [session GET:urlString parameters: parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        // 上传图片
        [self uploadImageWithQiniuSDKWithKey:data[@"key"] withToken:data[@"token"] withURL:data[@"picURL"] withImage:img withIndex:index];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

/** 使用 qiniuSDK 上传 */
- (void)uploadImageWithQiniuSDKWithKey:(NSString *)key withToken:(NSString *)token withURL:(NSString *)url withImage:(UIImage *)img withIndex:(int)index
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data;
    if (UIImagePNGRepresentation(img) == nil){
        data = UIImageJPEGRepresentation(img, 1);
    } else {
        data = UIImagePNGRepresentation(img);
    }
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
                  if ([resp[@"key"] isEqualToString:key]) {
                      // 上传成功
                      [self.delegate uploadDoneWithIndex:index withPicURL:url];
                  }
              } option:nil];
}



@end
