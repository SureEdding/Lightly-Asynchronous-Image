//
//  ImageDownloaderManager.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 图片下载策略
 */
typedef enum DownloadPolicy : NSUInteger {
    //默认下载方式，调用普通task
    dNormalDownload,
    //大文件下载方式，调用downloadTask
    dBigImageDownload
} DownloadPolicy;

typedef enum ImageCachePolicy : NSUInteger {
    //默认缓存方式，如果缓存中有相应图片，直接予以显示，否则读取网络图片
    cTempCache,
    //持续化缓存方式，优先从持久化存储中读取图片，若无，则从网络获取图片
    cPersistentCache,
    //忽略缓存，直接从网络中读取图片
    cNoCache
} ImageCachePolicy;

typedef void (^progressBlock)(int64_t currentValue, int64_t expectedValue);

typedef void (^completeBlock)(UIImage * expectedImage);

typedef void (^failBlock)(NSString * message);

typedef void (^cacheBlock)(NSData *cacheData);

typedef void (^cacheQueryBlock)(NSData *data , BOOL success, NSString *errorMessage);

@interface ImageDownloaderManager : NSOperation

/**
 *    @author Sure Edding, 15-08-05 16:08:23
 *
 *    @brief  Singleton
 *
 *    @return Singleton
 *
 *    @since 1.0
 */
+ (id)shareInstance;

/**
 *    @author Sure Edding, 15-08-05 14:08:25
 *
 *    @brief  异步下载图片，实时传回进度条信息
 *
 *    @param url           图片链接
 *    @param progressBlock 进度条闭包
 *    @param completeBlock 完成闭包
 *    @param failureBlock  失败比包
 *
 *    @since 1.0
 */
- (void)downloadImageWithURL:(NSString *)url
                downloadType:(DownloadPolicy)policy
                   cacheType:(ImageCachePolicy)cachePolicy
               progressBlock:(progressBlock)progressBlock
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock;

/**
 *    @author Sure Edding, 15-08-05 14:08:33
 *
 *    @brief  异步下载图片
 *
 *    @param url           图片链接
 *    @param completeBlock 完成闭包
 *    @param failureBlock  失败闭包
 *
 *    @since 1.0
 */
- (void)downloadImageWithURL:(NSString *)url
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock;


@end

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
