//
//  AsyncImageloaderTests.m
//  AsyncImageloaderTests
//
//  Created by mac on 8/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Define.h"
#import "ViewController.h"

@interface AsyncImageloaderTests : XCTestCase

@property (strong, nonatomic) ViewController *viewController;

@end

@implementation AsyncImageloaderTests

- (void)setUp {
    [super setUp];
    _viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testDataSourceNotNil
{
    __unused id view = _viewController.view;
    
    XCTAssertNotNil(_viewController.dataSource);
}



- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end



