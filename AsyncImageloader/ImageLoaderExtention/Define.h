//
//  Define.h
//  AsyncImageloader
//
//  Created by mac on 8/5/15.
//  Copyright © 2015 mac. All rights reserved.
//

#ifndef __Define_h__
#define __Define_h__

#import "ImageDownloaderManager.h"
#import "ImageDownloaderOperation.h"
#import "UIImageView+AsyncImage.h"


#pragma mark : Method Define

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#endif /* Define_h */


#pragma mark : TypeDef