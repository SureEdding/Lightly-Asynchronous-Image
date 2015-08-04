//
//  ImageDownloaderOperation.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageDownloaderOperation.h"
@interface ImageDownloaderOperation()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *operationId;
@property (strong, nonatomic) progressBlock progressblock;
@property (strong, nonatomic) completeBlock completeblock;
@property (strong, nonatomic) failBlock     failblock;
@property (strong, nonatomic) cacheBlock    cacheblock;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSURLConnection *connection;
@end

@implementation ImageDownloaderOperation


- (instancetype)initWithOperationId:(nonnull    NSString *)operationId
                            request:(nonnull    NSURLRequest *)request
                      progressBlock:(nullable   progressBlock)progress
                      completeBlock:(nonnull    completeBlock)complete
                         cacheBlock:(nonnull    cacheBlock)cache
                       failureBlock:(nullable   failBlock)failure;
{
    if (self = [super init]) {
        _request = request;
        _operationId = operationId;
        _progressblock = progress;
        _completeblock = complete;
        _failblock  = failure;
        _cacheblock = cache;
    }
    return self;
}

- (void)start
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:_request completionHandler:
                                  ^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
                                      if (!error) {
                                          if (data.length > 100)
                                          {
                                              _cacheblock(data);
                                              _completeblock([UIImage imageWithData:data]);
                                          }
                                      }
                                      else
                                      {
                                          _failblock(error.localizedDescription);
                                      }
                                  }];
    [task resume];
    
}
- (void)main
{
    NSLog(@"%@", _operationId);
}
@end
