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
                completeBlock:nil];
}

- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
       progressBlock:(nullable progressBlock)progress
       completeBlock:(nullable void (^)(void))completeBlock
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
