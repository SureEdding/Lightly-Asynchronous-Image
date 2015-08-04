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

- (nonnull instancetype)initWithOperationId:(nonnull    NSString *)operationId
                                    request:(nonnull    NSURLRequest *)request
                              progressBlock:(nullable   progressBlock)progress
                              completeBlock:(nonnull    completeBlock)complete
                               failureBlock:(nullable   failBlock)failure;

@end
