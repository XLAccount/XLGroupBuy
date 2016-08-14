
//
//  XLRecentViewController.m
//  团购
//
//  Created by 徐理 on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLRecentViewController.h"
#import "XLCRTool.h"

@interface XLRecentViewController ()

@end

@implementation XLRecentViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近浏览";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    移除说有数据
    [self.deals removeAllObjects];
    
//    取出储存团购信息的数组
    NSArray *recentDeals = [XLCRTool shareXLCRTool].recentDeal;
    
    
    [self.deals addObjectsFromArray:recentDeals];
    
    [self.collectionView reloadData];
}

#pragma mark - 实现父类方法
- (NSString *)emptyName
{
    return @"icon_latestBrowse_empty";
}




@end
