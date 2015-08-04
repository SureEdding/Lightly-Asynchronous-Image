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
    
    if (url)
    {
        __block UIImage *expectedImage;
        __weak __typeof(self)weakSelf = self;
        if (placeHolder)
        {
            dispatch_main_sync_safe(^{self.image = placeHolder;});
        }
        [[ImageDownloaderManager shareInstance] downloadImageWithURL:url
                                                       progressBlock:^(NSInteger currentValue, NSInteger expectedValue){
                                                           NSLog(@"progressBlock");}
         
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
    
    
  
}
@end
