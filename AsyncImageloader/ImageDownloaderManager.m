//
//  ImageDownloaderManager.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageDownloaderManager.h"
#import "ImageDownloaderOperation.h"

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
               progressBlock:(progressBlock)progressBlock
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock
{
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    
    [self queryDiskCacheForKey:url completeBlock:^(NSData *data, BOOL success, NSString *errorMessage) {
        if (success) {
            NSLog(@"CacheHit");
            completeBlock([UIImage imageWithData:data]);
        }
        return;
    }];
    
    ImageDownloaderOperation *operation = [[ImageDownloaderOperation alloc] initWithOperationId:url
                                                                                        request:request
                                                                                  progressBlock:progressBlock
                                                                                  completeBlock:completeBlock cacheBlock:^(NSData *cacheData) {
                                                                                      @synchronized(_imageCache) {
                                                                                          [_imageCache setObject:cacheData forKey:url];
                                                                                      }
                                                                                  }
                                                                                   failureBlock:failureBlock];
    

    [_runningQueue addOperation:operation];
}

- (void)queryDiskCacheForKey:(NSString *)key completeBlock:(cacheQueryBlock)block
{
    NSData *data = [_imageCache objectForKey:key];
    if (data) {
        block(data, YES, nil);
    }
}
@end
