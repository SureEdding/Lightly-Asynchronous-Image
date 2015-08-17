//
//  ImageDownloaderOperation.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageDownloaderOperation.h"


@interface ImageDownloaderOperation()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSString*         url;
@property (strong, nonatomic) NSData*           imageData;
@property (strong, nonatomic) NSString*         operationId;
@property (strong, nonatomic) progressBlock     progressblock;
@property (strong, nonatomic) completeBlock     completeblock;
@property (strong, nonatomic) failBlock         failblock;
@property (strong, nonatomic) cacheBlock        cacheblock;
@property (strong, nonatomic) NSURLRequest*     request;
@property (strong, nonatomic) NSURLConnection*  connection;
@property (strong, nonatomic) NSURLSession*     session;
@property (assign, nonatomic) DownloadPolicy    downloadPolicy;
@end

@implementation ImageDownloaderOperation


- (instancetype)initWithOperationId:(nonnull    NSString *)operationId
                            request:(nonnull    NSURLRequest *)request
                     downloadPolicy:(           DownloadPolicy)policy
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
        _downloadPolicy = policy;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];

    }
    return self;
}

- (void)start
{
    if (dNormalDownload == _downloadPolicy)
    {
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:_request completionHandler:
                                      ^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
                                          if (!error) {
                                              if (data.length > 100)
                                              {
                                                  if (_cacheblock) {
                                                      _cacheblock(data);
                                                  }
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
    else if (dBigImageDownload == _downloadPolicy)
    {
    
        NSURLSessionDownloadTask *task = [_session downloadTaskWithRequest:_request];
        [task resume];
    }
}

- (void)       URLSession:(NSURLSession *)session
             downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"didFinishDownloadingToURL, %@", location);
    NSData *finishedData = [NSData dataWithContentsOfURL:location];
    if (finishedData) {
        if (_cacheblock) {
        _cacheblock(finishedData);
    }
        _completeblock([UIImage imageWithData:finishedData]);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (_progressblock) {
        _progressblock(bytesWritten, totalBytesExpectedToWrite);        
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData:%lu", (unsigned long)data.length);
}

@end
