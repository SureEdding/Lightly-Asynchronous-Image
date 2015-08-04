//
//  ImageDownloaderManager.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^progressBlock)(NSInteger currentValue, NSInteger expectedValue);

typedef void (^completeBlock)(UIImage * expectedImage);

typedef void (^failBlock)(NSString * message);

@interface ImageDownloaderManager : NSOperation

+ (id)shareInstance;
- (void)downloadImageWithURL:(NSString *)url
               progressBlock:(progressBlock)progressBlock
               completeBlock:(completeBlock)completeBlock
                failureBlock:(failBlock)failureBlock;


@end
