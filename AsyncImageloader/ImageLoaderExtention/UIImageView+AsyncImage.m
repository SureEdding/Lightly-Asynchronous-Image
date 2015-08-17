//
//  UIImageView+AsyncImage.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "UIImageView+AsyncImage.h"
#import "ImageDownloaderManager.h"

@implementation UIImageView (AsyncImage)
- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder;
{
    return [self imageWithURL:url
             placeHolderImage:placeHolder
                progressBlock:nil];
}

- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
       progressBlock:(nullable progressBlock)progress
{
    return [self imageWithURL:url
             placeHolderImage:placeHolder
                progressBlock:progress
                completeBlock:nil
               ImageCacheType:cTempCache];
}
- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
      ImageCacheType:(ImageCachePolicy)cachePolicy
{
    return [self imageWithURL:url
             placeHolderImage:placeHolder
                progressBlock:nil
                completeBlock:nil
               ImageCacheType:cachePolicy];
}

- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
       progressBlock:(nullable progressBlock)progress
       completeBlock:(nullable void (^)(void))completeBlock
      ImageCacheType:(ImageCachePolicy)cachePolicy

{
    if (url)
    {
        __block UIImage *expectedImage;
        __weak __typeof(self)weakSelf = self;
        if (placeHolder)
        {
            dispatch_main_sync_safe(^{self.image = placeHolder;});
        }
        [[ImageDownloaderManager shareInstance] downloadImageWithURL:url
                                                        downloadType:(progress ? dBigImageDownload : dNormalDownload)
                                                           cacheType:cachePolicy
                                                       progressBlock:progress
                                                       completeBlock:^(UIImage *image) {
                                                           NSLog(@"CompleteBlock");
                                                           expectedImage = [image copy];
                                                           dispatch_main_sync_safe(^{
                                                               weakSelf.image = image;
                                                           });
                                                           [weakSelf setNeedsLayout];}
                                                        failureBlock:^(NSString *message) {
                                                            NSLog(@"faulure: %@", message);
                                                        }];}
    
    if (completeBlock) {
        completeBlock();
    }
}
@end
