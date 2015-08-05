//
//  UIImageView+AsyncImage.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncImage)


/**
 *    @author Sure Edding, 15-08-04 12:08:50
 *
 *    @brief  通过URL获取网络图片，图片未获取完成之前显示Placeholder中的图片，功能类似SDWebImage
 *
 *    @param url         网络获取图片链接
 *    @param placeHolder 获取数据未完成时候的占位图
 *
 *    @since 1.0
 */
- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage  *)placeHolder;

@end

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}