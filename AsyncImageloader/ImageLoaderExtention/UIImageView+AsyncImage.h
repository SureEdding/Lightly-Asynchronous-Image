//
//  UIImageView+AsyncImage.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloaderManager.h"

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

/**
 *    @author Sure Edding, 15-08-05 14:08:25
 *
 *    @brief  通过URL获取网络图片，带进度条回调
 *
 *    @param url         图片链接
 *    @param placeHolder 占位图
 *    @param progress    进度条回调
 *
 *    @since 1.0
 */
- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
       progressBlock:(nullable progressBlock)progress;


/**
 *    @author Sure Edding, 15-08-05 14:08:25
 *
 *    @brief  通过URL获取网络图片，带进度条回调,带完成回调
 *
 *    @param url            图片链接
 *    @param placeHolder    占位图
 *    @param progress       进度条回调
 *    @param completeBlock  完成回调
 *
 *    @since 1.0
 */
- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder
       progressBlock:(nullable progressBlock)progress
       completeBlock:(nullable void (^)(void))completeBlock;
@end
