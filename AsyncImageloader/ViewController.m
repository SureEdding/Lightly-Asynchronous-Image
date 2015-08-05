//
//  ViewController.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewDataSource.h"
#import "UIImageView+AsyncImage.h"
#import "CustomCollectionViewCell.h"

@interface ViewController ()

#define IMAGE_URL @"http://7xj983.com1.z0.glb.clouddn.com/sureeddingapps_"

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(192, 192)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
    
    _dataSource = [[CollectionViewDataSource alloc] init];
    _dataSource.block = ^(CustomCollectionViewCell *cell, NSIndexPath *indexPath){
        [cell.bigImageView imageWithURL:[NSString stringWithFormat:@"%@%ld.png", IMAGE_URL, (long)indexPath.row] placeHolderImage:[UIImage imageNamed:@"rin"] progressBlock:^(int64_t currentValue, int64_t expectedValue) {
            NSLog(@"%lld / %lld", currentValue, expectedValue);
        }];
    };
    _collectionView.delegate = _dataSource;
    _collectionView.dataSource = _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
