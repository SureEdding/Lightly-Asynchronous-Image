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

@property (strong, nonatomic) NSMutableDictionary *runningOperations;
@property (strong, nonatomic) NSOperationQueue *runningQueue;

@end

@implementation ImageDownloaderManager
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
    if (cCachePolicyTempCache == cachePolicy) {
        
        NSData *imageData = [[ImageLoaderCacheManager shareInstance] objectForKeyFromCacheWithKey:url withPolicy:cCachePolicyTempCache];
        if (imageData) {
            NSLog(@"temp Cache hit");
            UIImage *image = [UIImage imageWithData:imageData];
            completeBlock(image);
        } else {
            cacheblock = ^(NSData *cacheData){
                NSLog(@"network temp set cache ");
                [[ImageLoaderCacheManager shareInstance] setObjectForCacheWithKey:url data:cacheData cachePolicy:cCachePolicyTempCache];
            };
        }
    } else if (cCachePolicyNetwork == cachePolicy) {
        
    } else {
        NSData *imageData = [[ImageLoaderCacheManager shareInstance] objectForKeyFromCacheWithKey:url withPolicy:cCachePolicyPersistentCache];
        if (imageData) {
            NSLog(@"Persistent Cache hit");
            UIImage *image = [UIImage imageWithData:imageData];
            completeBlock(image);
            return;
        } else {
            cacheblock = ^(NSData *cacheData){
                NSLog(@"network Persistent set cache ");
                [[ImageLoaderCacheManager shareInstance] setObjectForCacheWithKey:url data:cacheData cachePolicy:cCachePolicyPersistentCache];
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
                            cacheType:cCachePolicyTempCache
                        progressBlock:nil
                        completeBlock:completeBlock
                         failureBlock:failureBlock];
}
@end
