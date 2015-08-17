//
//  Image.h
//  AsyncImageloader
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSManagedObject

+ (void)importImageDataWithKey:(NSString *)key imageData:(NSData *)data intoContext:(NSManagedObjectContext *)context;
+ (instancetype)findObjectWithKey:(NSString *)key inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Image+CoreDataProperties.h"
