//
//  TableViewDataSource.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

typedef void (^CustomCell)(CustomTableViewCell *cell, NSIndexPath *indexPath);
@interface TableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) CustomCell block;

- (instancetype)initWithCustomBlock:(CustomCell)block;

@end
