//
//  ImageLoaderCacheManager.m
//  AsyncImageloader
//
//  Created by mac on 8/18/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageLoaderCacheManager.h"

@interface ImageLoaderCacheManager()

@property (strong, nonatomic) NSCache *tempCache;

@end

@implementation ImageLoaderCacheManager

- (instancetype)init
{
    if (self = [super init]) {
        _tempCache = [[NSCache alloc] init];
    }
    return self;
}

+ (ImageLoaderCacheManager *)shareInstance
{
    static dispatch_once_t once;
    static ImageLoaderCacheManager *shareInstace;
    dispatch_once(&once, ^{
        shareInstace = [[[self class] alloc] init];
    });
    return shareInstace;
}
- (NSData *)objectForKeyFromCacheWithKey:(NSString *)key withPolicy:(ImageCachePolicy)policy
{
    if (cCachePolicyTempCache == policy || cCachePolicyNetwork == policy) {

        return [_tempCache objectForKey:key];
    } else {
        NSManagedObjectContext *moc = [[ImageLoaderPersistentStoreStack shareInstance] managedObjectContextForKey:key queue:[NSOperationQueue currentQueue]];
        Image *imageObject = [Image findObjectWithKey:key inContext:moc];
        if (imageObject) {
            return imageObject.data;
        }
        return nil;
    }
}
- (void)setObjectForCacheWithKey:(NSString *)key data:(NSData *)data cachePolicy:(ImageCachePolicy)policy
{
    if (cCachePolicyTempCache == policy || cCachePolicyNetwork == policy) {
        [_tempCache setObject:data forKey:key];
    } else {
        NSManagedObjectContext *moc = [[ImageLoaderPersistentStoreStack shareInstance] managedObjectContextForKey:key queue:[NSOperationQueue currentQueue]];
        
        [Image importImageDataWithKey:key imageData:data intoContext:moc];
        [moc performBlock:^{
            [moc save:nil];
        }];
        
    }
    NSString *string = @"123";
    NSLog(@"%@",string);
}

- (void)removeObjectFromCacheWithKey:(NSString *)key cachePolicy:(ImageCachePolicy)policy
{
    if (cCachePolicyTempCache == policy || cCachePolicyNetwork == policy) {
        [_tempCache removeObjectForKey:key];
    } else {
        NSManagedObjectContext *moc = [[ImageLoaderPersistentStoreStack shareInstance] managedObjectContextForKey:key queue:[NSOperationQueue currentQueue]];
        
        Image *imageObject = [Image findObjectWithKey:key inContext:moc];
        if (imageObject) {
            [moc deleteObject:imageObject];
            [[ImageLoaderPersistentStoreStack shareInstance] removeManagedObjectContextWithKey:key];
        }
    }
}
- (void)removeAllObjectsFromCache
{
    [_tempCache removeAllObjects];
    
}

@end
