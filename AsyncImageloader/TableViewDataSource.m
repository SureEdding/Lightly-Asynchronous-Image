//
//  TableViewDataSource.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "TableViewDataSource.h"
#import "CustomTableViewCell.h"
@interface TableViewDataSource()

@end

@implementation TableViewDataSource
- (instancetype)initWithCustomBlock:(CustomCell)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 15;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    _block(cell, indexPath);
    return cell;
}

@end
