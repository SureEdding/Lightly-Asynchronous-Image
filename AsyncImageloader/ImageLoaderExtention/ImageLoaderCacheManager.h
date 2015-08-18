//
//  ImageLoaderCacheManager.h
//  AsyncImageloader
//
//  Created by mac on 8/18/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoaderPersistentStoreStack.h"
#import "Image+CoreDataProperties.h"

typedef enum ImageCachePolicy : NSUInteger {
    //默认缓存方式，如果缓存中有相应图片，直接予以显示，否则读取网络图片
    cCachePolicyTempCache,
    //持续化缓存方式，优先从持久化存储中读取图片，若无，则从网络获取图片
    cCachePolicyPersistentCache,
    //忽略缓存，直接从网络中读取图片
    cCachePolicyNetwork
} ImageCachePolicy;

@interface ImageLoaderCacheManager : NSObject

+ (ImageLoaderCacheManager *)shareInstance;


- (NSData *)objectForKeyFromCacheWithKey:(NSString *)key withPolicy:(ImageCachePolicy)policy;
- (void)setObjectForCacheWithKey:(NSString *)key data:(NSData *)data cachePolicy:(ImageCachePolicy)policy;
- (void)removeObjectFromCacheWithKey:(NSString *)key cachePolicy:(ImageCachePolicy)policy;
- (void)removeAllObjectsFromCache;

@end
