//
//  TableViewDataSource.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "CustomCollectionViewCell.h"
@interface CollectionViewDataSource()

@end

@implementation CollectionViewDataSource
- (instancetype)initWithCustomBlock:(CustomCell)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    _block(cell, indexPath);
    return cell;
}

@end
