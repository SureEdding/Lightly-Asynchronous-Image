//
//  ViewController.h
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionViewDataSource;
@interface ViewController : UIViewController

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;

@end

