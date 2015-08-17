//
//  ImageDownloaderManager.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageDownloaderManager.h"
#import "ImageDownloaderOperation.h"
#import "ImageLoaderPersistentStoreStack.h"
#import "Image+CoreDataProperties.h"

@interface ImageDownloaderManager()

@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSMutableDictionary *runningOperations;
@property (strong, nonatomic) NSOperationQueue *runningQueue;

@end

@implementation ImageDownloaderManager
@synthesize imageCache = _imageCache;
@synthesize runningOperations = _runningOperations;
+ (id)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _runningQueue = [NSOperationQueue new];
        _imageCache = [NSCache new];
        _runningOperations = [NSMutableDictionary new];
    }
    return self;
}

- (void)downloadImageWithURL:(NSString *)url
                downloadType:(DownloadPolicy)policy
                   cacheType:(ImageCachePolicy)cachePolicy
               progressBlock:(progressBlock)progressBlock
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock
{
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: requestURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:10.f];
    
    cacheBlock cacheblock = nil;
    if (cTempCache == cachePolicy) {
        
        [self queryDiskCacheForKey:url completeBlock:^(NSData *data, BOOL success, NSString *errorMessage) {
            if (success) {
                NSLog(@"CacheHit");
                completeBlock([UIImage imageWithData:data]);
            }
            return;
        }];
        
        cacheblock =  ^(NSData *cacheData){
            @synchronized(_imageCache) {
                [_imageCache setObject:cacheData forKey:url];
            }
        };
        
    } else if (cNoCache == cachePolicy) {
        [self deleteDiskCacheForKey:url];
    } else {
        NSManagedObjectContext *moc = [[ImageLoaderPersistentStoreStack shareInstance] managedObjectContextForKey:url queue:_runningQueue];
        
        Image *imageObject = [Image findObjectWithKey:url inContext:moc];
        
        if (imageObject) {
            UIImage *image = [UIImage imageWithData:imageObject.data];
            completeBlock(image);
            return;
        } else {
            cacheblock = ^(NSData *cacheData){
                [Image importImageDataWithKey:url imageData:cacheData intoContext:moc];
                [moc save:nil];
                [[ImageLoaderPersistentStoreStack shareInstance] clearManagedObjectContextWithKey:url];
            };
        }
    }
    
    
    
    ImageDownloaderOperation *operation = [[ImageDownloaderOperation alloc] initWithOperationId:url
                                                                                        request:request
                                                                                 downloadPolicy:policy
                                                                                  progressBlock:progressBlock
                                                                                  completeBlock:completeBlock
                                                                                     cacheBlock:cacheblock
                                                                                   failureBlock:failureBlock];
    [_runningQueue addOperation:operation];
}


- (void)downloadImageWithURL:(NSString *)url
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock
{
    return [self downloadImageWithURL:url
                         downloadType:dNormalDownload
                            cacheType:cTempCache
                        progressBlock:nil
                        completeBlock:completeBlock
                         failureBlock:failureBlock];
}

- (void)queryDiskCacheForKey:(NSString *)key completeBlock:(cacheQueryBlock)block
{
    NSData *data = [_imageCache objectForKey:key];
    if (data) {
        block(data, YES, nil);
    }
}

- (void)deleteDiskCacheForKey:(NSString *)key
{
    [_imageCache removeObjectForKey:key];
}
@end
