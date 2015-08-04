//
//  ViewController.m
//  AsyncImageloader
//
//  Created by mac on 8/3/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ViewController.h"
#import "TableViewDataSource.h"
#import "UIImageView+AsyncImage.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TableViewDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[TableViewDataSource alloc] init];
    _dataSource.block = ^(CustomTableViewCell *cell, NSIndexPath *indexPath){
        [cell.imageView imageWithURL:[NSString stringWithFormat:@"http://7xj983.com1.z0.glb.clouddn.com/sureeddingapps_%2ld.png", (long)indexPath.row] placeHolderImage:[UIImage imageNamed:@"rin"]];
    };
    _tableView.delegate = _dataSource;
    _tableView.dataSource = _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
