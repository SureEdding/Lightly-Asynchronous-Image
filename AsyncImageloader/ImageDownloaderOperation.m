//
//  ImageDownloaderOperation.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageDownloaderOperation.h"
@interface ImageDownloaderOperation()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *task = 
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
/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    NSLog(@"didBecomeInvalidWithError");
}

/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    NSLog(@"didReceiveChallenge");
}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}


@end
