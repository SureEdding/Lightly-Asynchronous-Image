//
//  TableViewDataSource.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "CustomCollectionViewCell.h"


typedef void (^CustomCell)(CustomCollectionViewCell *cell, NSIndexPath *indexPath);

#pragma mark:datasource interface
@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) CustomCell block;

- (instancetype)initWithCustomBlock:(CustomCell)block;

@end
