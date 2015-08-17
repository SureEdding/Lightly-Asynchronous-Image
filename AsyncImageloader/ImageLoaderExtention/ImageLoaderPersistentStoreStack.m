//
//  ImageLoaderPersistentStoreStack.m
//  AsyncImageloader
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ImageLoaderPersistentStoreStack.h"


@interface ImageLoaderPersistentStoreStack()


@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableDictionary *managedObjectContexts;

@end

@implementation ImageLoaderPersistentStoreStack


+ (id)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        instance = [[ImageLoaderPersistentStoreStack alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _managedObjectContexts = [NSMutableDictionary new];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key queue:(NSOperationQueue *)queue
{
    @synchronized(_managedObjectContexts) {
        id moc = [_managedObjectContexts objectForKey:key];
        if (moc) {
            return moc;
        } else {
            NSManagedObjectContext *ManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            ManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
            [self setupSaveNotificationForKey:key queue:queue];
            return ManagedObjectContext;
        }
    }
}
- (void)clearManagedObjectContextWithKey:(NSString *)key
{
    [_managedObjectContexts removeObjectForKey:key];
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ImageDownloaderCache.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"ImageCacheModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (void)setupSaveNotificationForKey:(NSString *)key queue:(NSOperationQueue *)queue
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:queue
                                                  usingBlock:^(NSNotification * __nonnull note) {
                                                      NSManagedObjectContext *managedObjectContext = _managedObjectContexts[key];
                                                      if (note.object != managedObjectContext) {
                                                          [managedObjectContext performBlock:^{
                                                              [managedObjectContext mergeChangesFromContextDidSaveNotification:note];
                                                          }];
                                                      }
                                                  }];
}
//
////- (NSManagedObjectContext *)mainManagedObjectContext
////{
////    if (_mainManagedObjectContext != nil) {
////        return _mainManagedObjectContext;
////    }
////}
@end
