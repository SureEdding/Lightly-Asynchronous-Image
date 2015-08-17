//
//  ImageDownloaderOperation.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloaderManager.h"

@interface ImageDownloaderOperation : NSOperation

/**
 *    @author Sure Edding, 15-08-05 14:08:38
 *
 *    @brief  初始化一个普通的网络数据获取Operation
 *
 *    @param operationId operationid
 *    @param request     请求NSURLRequest
 *    @param complete    完成回调
 *    @param cache       缓存回调，用户本地缓存
 *    @param failure     失败回调
 *
 *    @return 返回本身
 *
 *    @since 1.0
 */
- (nonnull instancetype)initWithOperationId:(nonnull    NSString *)operationId
                                    request:(nonnull    NSURLRequest *)request
                             downloadPolicy:(           DownloadPolicy)policy
                              progressBlock:(nullable   progressBlock)progress
                              completeBlock:(nonnull    completeBlock)complete
                                 cacheBlock:(nonnull    cacheBlock)cache
                               failureBlock:(nullable   failBlock)failure;

@end
