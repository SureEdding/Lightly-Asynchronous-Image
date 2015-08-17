//
//  Image+CoreDataProperties.h
//  AsyncImageloader
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *key;
@property (nullable, nonatomic, retain) NSData *data;

@end

NS_ASSUME_NONNULL_END
