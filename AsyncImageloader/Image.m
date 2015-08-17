//
//  Image.m
//  AsyncImageloader
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "Image.h"

@implementation Image

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}
+ (instancetype)findObjectWithKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"key = %@", key];
    request.fetchLimit = 1;
    
    id object = [[context executeFetchRequest:request error:nil] lastObject];
    return object;
}
+ (instancetype)findOrCreateWithKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    id object = [self findObjectWithKey:key inContext:context];
    if (nil == object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    }
    return object;
}

+ (void)importImageDataWithKey:(NSString *)key imageData:(NSData *)data intoContext:(NSManagedObjectContext *)context
{
    Image *image = [self findOrCreateWithKey:key inContext:context];
    image.key = key;
    image.data = data;
}
@end
