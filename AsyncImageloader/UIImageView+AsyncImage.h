//
//  UIImageView+AsyncImage.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncImage)

- (void)imageWithURL:(nullable NSString *)url
    placeHolderImage:(nullable UIImage *)placeHolder;

@end

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}