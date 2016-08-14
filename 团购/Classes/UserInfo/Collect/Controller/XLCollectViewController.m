
//
//  XLCollectViewController.m
//  团购
//
//  Created by 徐理 on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCollectViewController.h"
#import "XLCRTool.h"

@interface XLCollectViewController ()

@end

@implementation XLCollectViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.deals removeAllObjects];
    
    NSArray *collectDeals = [XLCRTool shareXLCRTool].collectDeal;
    [self.deals addObjectsFromArray:collectDeals];
    [self.collectionView reloadData];
}

- (NSString *)emptyName
{
    return @"icon_collects_empty";
}


@end
