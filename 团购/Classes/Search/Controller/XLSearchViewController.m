
//
//  XLSearchViewController.m
//  团购
//
//  Created by 徐理 on 16/8/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "XLFindDealsParam.h"
#import "XLDealTool.h"
#import "MJRefresh.h"

@interface XLSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) XLFindDealsParam *param;

@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation XLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    
    [self pullToRefresh];
}

- (void)pullToRefresh
{
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadMoreData
{
    XLFindDealsParam *param = [[XLFindDealsParam alloc] init];
    
    param.keyword = self.searchBar.text;
    param.city = self.selectCityName;
    param.page = @(self.param.page.intValue + 1);
    
    [XLDealTool findDeals:param success:^(XLFindDealsResult *result) {

        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        [self.deals addObjectsFromArray:result.deals];
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];

    self.param = param;
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
    UIView *view = [[UIView alloc] init];
    view.width = 400;
    view.height = 40;
    
    UISearchBar *search = [[UISearchBar alloc] init];
    
    search.searchBarStyle = UISearchBarStyleMinimal;
    
    [view addSubview:search];
    self.navigationItem.titleView = view;
    
    [search autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    search.placeholder = @"请输入搜索内容";
    search.delegate = self;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController.view endEditing:YES];
    
    [MBProgressHUD showMessage:@"正在搜索请稍后。。。" toView:self.navigationController.view];
    
    XLFindDealsParam *param = [[XLFindDealsParam alloc] init];
    param.keyword = searchBar.text;
    param.city = self.selectCityName;
    param.page = @(1);
    
    [XLDealTool findDeals:param success:^(XLFindDealsResult *result) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        self.totalCount = result.total_count;
        
        self.deals = [NSMutableArray arrayWithArray:result.deals];

//        返回顶部
        self.collectionView.contentOffset = CGPointMake(0, 0);

        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];

    self.param = param;
}


#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.deals.count == self.totalCount;
    return [super collectionView:collectionView numberOfItemsInSection:section];
}


#pragma mark - 实现父类方法
- (NSString *)emptyName
{
    return @"icon_deals_empty";
}

@end
