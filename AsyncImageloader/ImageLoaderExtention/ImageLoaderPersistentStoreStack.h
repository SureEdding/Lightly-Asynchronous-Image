//
//  ImageLoaderPersistentStoreStack.h
//  AsyncImageloader
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ImageLoaderPersistentStoreStack : NSObject


+ (instancetype)shareInstance;

- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key queue:(NSOperationQueue *)queue;

- (void)removeManagedObjectContextWithKey:(NSString *)key;

@end
