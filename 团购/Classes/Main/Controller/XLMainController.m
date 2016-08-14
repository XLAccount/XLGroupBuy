
//
//  XLMainController.m
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLMainController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Extension.h"
#import "XLNavMenu.h"
#import "XLSortModal.h"
#import "XLSortViewController.h"
#import "XLCityModal.h"
#import "XLCityMenuViewContriller.h"
#import "XLCategoryModal.h"
#import "XLCatagoryViewController.h"
#import "XLRegionModal.h"
#import "XLRegionsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "XLRecentViewController.h"
#import "XLCollectViewController.h"
#import "XLNavController.h"
#import "XLSearchViewController.h"
#import "XLMapViewController.h"
#import "XLMineCollectionViewController.h"
#import "XLMoreCollectionViewController.h"

@interface XLMainController ()<AwesomeMenuDelegate>

@property (nonatomic, weak) XLNavMenu *categoryMenu;
@property (nonatomic, weak) XLNavMenu *regionMenu;
@property (nonatomic, weak) XLNavMenu *sortMenu;

@property (nonatomic, strong) XLSortViewController *sortViewController;
@property (nonatomic, strong) XLRegionsViewController *regionsViewContriller;
@property (nonatomic, strong) XLCatagoryViewController *catagoryViewController;


/** 选中的状态 */
@property (nonatomic, strong) XLCityModal *city;
/** 当前选中的区域 */
@property (strong, nonatomic) XLRegionModal *region;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *subRegionName;
/** 当前选中的排序 */
@property (strong, nonatomic) XLSortModal *sort;
/** 当前选中的分类 */
@property (strong, nonatomic) XLCategoryModal *category;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *subCategoryName;

/** 请求参数 */
@property (nonatomic, strong) XLFindDealsParam *lastParam;
/**
 *  存储请求结果的总数
 */
@property (nonatomic, assign) NSInteger totalNumber;


//加载错误后记录
@property (nonatomic, strong) XLRegionModal *regionSuccess;
@property (nonatomic, copy) NSString *subRegionNameSuccess;
@property (nonatomic, strong) XLCategoryModal *categorySuccess;
@property (nonatomic, copy) NSString *subCategoryNameSuccess;
@end

@implementation XLMainController

#pragma 懒加载

- (NSString *)emptyName
{
    return @"icon_deals_empty";
}

- (XLSortViewController *)sortViewController
{
    if (_sortViewController == nil){
    
        _sortViewController = [[XLSortViewController alloc] init];
    }
    return _sortViewController;
}

- (XLRegionsViewController *)regionsViewContriller
{
    if (_regionsViewContriller == nil){
        
        _regionsViewContriller = [[XLRegionsViewController alloc] init];
        
    }
    return _regionsViewContriller;
}

- (XLCatagoryViewController *)catagoryViewController
{
    if (_catagoryViewController == nil){
        
        _catagoryViewController = [[XLCatagoryViewController alloc] init];
    }
    return _catagoryViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sort = [XLDataTool shareXLDataTool].selectedSort;
    self.city = [XLDataTool shareXLDataTool].selectedCity;
    
    // 用户菜单
    [self setupUserMenu];
    // 设置导航栏左边的内容
    [self setupLeftBtn];
    // 设置导航栏右边的内容
    [self setupRightBtn];
    // 监听通知
    [self setupNotifications];
    //  用户刷新
    [self refreshBegin];
}

#pragma mark - 通知处理
/** 监听通知 */
- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidSelect:) name:XLSort object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidSelect:) name:XLSelectCity object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidSelect:) name:XLSelectRegions object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidSelect:) name:XLCategory object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)regionDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.region = note.userInfo[XLSelectRegions];
    self.subRegionName = note.userInfo[XLSelectRegionsSubTitle];
    
    // 加载最新的数据
    [self.collectionView.mj_header beginRefreshing];
}

- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.category = note.userInfo[XLSelectCategory];
    self.subCategoryName = note.userInfo[XLCategorySubTitle];
    
    // 加载最新的数据
    [self.collectionView.mj_header beginRefreshing];
}

- (void)cityDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.city = note.userInfo[XLSelectCity];
    self.region = [self.city.regions firstObject];
    
    // 更换显示的区域数据
    self.regionsViewContriller = [[XLRegionsViewController alloc] init];
    self.regionsViewContriller.regions = self.city.regions;
    
    // 加载最新的数据
    [self.collectionView.mj_header beginRefreshing];
    
    [[XLDataTool shareXLDataTool] saveSelectedCity:self.city.name];
}

- (void)sortDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.sort = note.userInfo[XLSortTitle];
    
    self.sortMenu.subTitle.text = self.sort.label;
    
    // 加载最新的数据
    [self.collectionView.mj_header beginRefreshing];
    
    [[XLDataTool shareXLDataTool] saveSelectedSort:self.sort];
}

#pragma mark - 刷新数据

- (void)refreshBegin
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 *  封装请求参数
 */
- (XLFindDealsParam *)buildParam
{
    XLFindDealsParam *param = [[XLFindDealsParam alloc] init];
    // 城市名称
    param.city = self.city.name;
    // 排序
    if (self.sort) {
        param.sort = @(self.sort.value);

    }
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (self.category && ![self.category.name isEqualToString:@"全部分类"]) {
        if (self.subCategoryName && ![self.subCategoryName isEqualToString:@"全部"]) {
            param.category = self.subCategoryName;
        } else {
            param.category = self.category.name;
        }
    }
    // 区域
    if (self.region && ![self.region.name isEqualToString:@"全部"]) {
        if (self.subRegionName && ![self.subRegionName isEqualToString:@"全部"]) {
            param.region = self.subRegionName;
        } else {
            param.region = self.region.name;
        }
    }
    param.page = @1;
    
    
    //    param.limit = @(3);
    return param;
}

- (void)loadNewDeals
{
    // 1.创建请求参数
    XLFindDealsParam *param = [self buildParam];
    
    
    
    // 2.加载数据
    [XLDealTool findDeals:param success:^(XLFindDealsResult *result) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
//        记录加载成功的数据
        self.categorySuccess = self.category;
        self.subCategoryNameSuccess = self.subCategoryName;
        
        self.regionSuccess = self.region;
        self.subRegionNameSuccess = self.subRegionName;
        
        // 设置菜单数据
        self.regionMenu.title.text = [NSString stringWithFormat:@"%@ - %@", self.city.name, self.region.name];
        self.regionMenu.subTitle.text = self.subRegionName;
        
        if (self.region.name.length == 0){
            
             self.regionMenu.title.text = [NSString stringWithFormat:@"%@ - 全部", self.city.name];
        }

        
              self.categoryMenu.title.text = @"全部分类";
        
        if (self.category.name.length){
            // 设置菜单数据
            [self.categoryMenu.clickBtn setImage:[UIImage imageNamed:self.category.icon] forState:UIControlStateNormal];
            [self.categoryMenu.clickBtn setImage:[UIImage imageNamed:self.category.highlighted_icon] forState:UIControlStateHighlighted];
            
            
            self.categoryMenu.title.text = self.category.name;
            self.categoryMenu.subTitle.text = self.subCategoryName;

        }


        
        // 记录总数
        self.totalNumber = result.total_count;
        
        // 清空之前的所有数据
        [self.deals removeAllObjects];
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        
//        加载失败恢复数据
        self.category = self.categorySuccess;
        self.subCategoryName = self.subCategoryNameSuccess;
        
        self.region = self.regionSuccess;
        self.subRegionName = self.subRegionNameSuccess;
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    }];
    
    // 3.保存请求参数
    self.lastParam = param;
}

- (void)loadMoreDeals
{
    // 1.创建请求参数
    XLFindDealsParam *param = [self buildParam];
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    
    // 2.加载数据
    [XLDealTool findDeals:param success:^(XLFindDealsResult *result) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
    }];
    
    // 3.设置请求参数
    self.lastParam = param;
}

- (void)setupRightBtn
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImageName:@"icon_map" highImageName:@"icon_map_highlighted" target:self action:@selector(mapClick)];
   
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImageName:@"icon_search" highImageName:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    
    mapItem.customView.width = searchItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}


- (void)setupLeftBtn
{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"]];
    
    XLNavMenu *categoryMenu = [XLNavMenu navMenu];
    XLNavMenu *regionMenu = [XLNavMenu navMenu];
    XLNavMenu *sortMenu = [XLNavMenu navMenu];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:image];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:regionMenu];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:sortMenu];
    self.categoryMenu = categoryMenu;
    self.regionMenu = regionMenu;
    self.sortMenu = sortMenu;
    [categoryMenu addTarget:self action:@selector(categoryClick) ];
    [regionMenu addTarget:self action:@selector(regionClick)];
    [sortMenu addTarget:self action:@selector(sortClick)];
    
    [sortMenu.clickBtn setImage:[UIImage imageNamed:@"icon_sort" ] forState:UIControlStateNormal];
    [sortMenu.clickBtn setImage:[UIImage imageNamed:@"icon_sort_highlighted" ] forState:UIControlStateHighlighted];
    
    sortMenu.title.text = @"排序";
    sortMenu.subTitle.text = self.sort.label;
    
    [regionMenu.clickBtn setImage:[UIImage imageNamed:@"icon_district"] forState:UIControlStateNormal];
    [regionMenu.clickBtn setImage:[UIImage imageNamed:@"icon_district_highlighted"] forState:UIControlStateHighlighted];
    
    regionMenu.title.text = [NSString stringWithFormat:@"%@ - 全部", self.city.name];
    regionMenu.subTitle.text = self.subRegionName;
    
    categoryMenu.title.text = @"全部分类";
    
    self.navigationItem.leftBarButtonItems = @[item, item1, item2, item3];
}

- (void)mapClick
{
    XLMapViewController *map = [[XLMapViewController alloc] init];
    XLNavController *nav = [[XLNavController alloc] initWithRootViewController:map];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)searchClick
{

    XLSearchViewController *search = [[XLSearchViewController alloc] init];
    XLNavController *nav = [[XLNavController alloc] initWithRootViewController:search];
    
    search.selectCityName = self.city.name;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)categoryClick
{
    self.catagoryViewController.category = self.category;
    self.catagoryViewController.subCategoryName = self.subCategoryName;
    
    [self presentWithViewController:self.catagoryViewController sourceView:self.categoryMenu sourceRect:self.categoryMenu.bounds];
}

- (void)regionClick
{
    self.regionsViewContriller.region = self.region;
    self.regionsViewContriller.subRegionName = self.subRegionName;
    
//    设置城市列表
    self.regionsViewContriller.regions = self.city.regions;
    
    [self presentWithViewController:self.regionsViewContriller sourceView:self.regionMenu sourceRect:self.regionMenu.bounds];
    
//    __weak typeof(self) weakSelf;
    self.regionsViewContriller.changeCityBlock = ^{
        
        XLCityMenuViewContriller *cityMenuController = [[XLCityMenuViewContriller alloc] init];
        
        cityMenuController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:cityMenuController animated:YES completion:nil];
    };
}


- (void)sortClick
{
    
    [self presentWithViewController:self.sortViewController sourceView:self.sortMenu sourceRect:self.sortMenu.bounds];
}

- (void)presentWithViewController:(UIViewController *)vc sourceView:(UIView *)view sourceRect:(CGRect)rect
{
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = view;
    vc.popoverPresentationController.sourceRect = rect;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (AwesomeMenuItem *)itemWithContent:(NSString *)content highlightedContent:(NSString *)highlightedContent
{
    UIImage *image = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    
    AwesomeMenuItem *item = [[AwesomeMenuItem alloc] initWithImage:image highlightedImage:nil ContentImage:[UIImage imageNamed:content] highlightedContentImage:[UIImage imageNamed:highlightedContent]];
    
    return item;
}

- (void)setupUserMenu
{
    AwesomeMenuItem *mineItem = [self itemWithContent:@"icon_pathMenu_mine_normal" highlightedContent:@"icon_pathMenu_mine_highlighted"];
    AwesomeMenuItem *collectItem = [self itemWithContent:@"icon_pathMenu_collect_normal" highlightedContent:@"icon_pathMenu_collect_highlighted"];
    AwesomeMenuItem *scanItem = [self itemWithContent:@"icon_pathMenu_scan_normal" highlightedContent:@"icon_pathMenu_scan_highlighted"];
    AwesomeMenuItem *moreItem = [self itemWithContent:@"icon_pathMenu_more_normal" highlightedContent:@"icon_pathMenu_more_highlighted"];
    
    NSArray *items = @[mineItem, collectItem, scanItem, moreItem];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    
    [self.view addSubview:menu];
    
    menu.menuWholeAngle = M_PI_2;
    
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background"]];
    [menu insertSubview:image atIndex:0];
    
    [image autoSetDimensionsToSize:image.size];
    [image autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [image autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    //    开始按钮的中心点(必须要设置不然不显示)
    menu.startPoint = CGPointMake(image.image.size.width * 0.5, 200 - image.image.size.height * 0.5);
    
    //    中间按钮不随着旋转
    menu.rotateAddButton = NO;
    
    menu.delegate = self;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{

    
    if (idx == 1){  //收藏
        
        XLCollectViewController *collect = [[XLCollectViewController alloc] init];
        XLNavController *nav = [[XLNavController alloc] initWithRootViewController:collect];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else if (idx == 2){    //最近浏览
        
        XLRecentViewController *recent = [[XLRecentViewController alloc] init];
        XLNavController *nav = [[XLNavController alloc] initWithRootViewController:recent];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else if (idx == 0){
        
        XLMineCollectionViewController *mine = [[XLMineCollectionViewController alloc] init];
        XLNavController *nav = [[XLNavController alloc] initWithRootViewController:mine];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (idx == 3){
        
        XLMoreCollectionViewController *more = [[XLMoreCollectionViewController alloc] init];
        XLNavController *nav = [[XLNavController alloc] initWithRootViewController:more];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    [self awesomeMenuWillAnimateClose:menu];
}

#pragma mark - 代理方法
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // 尾部控件的可见性
    self.collectionView.mj_footer.hidden = self.deals.count == self.totalNumber;

        return [super collectionView:collectionView numberOfItemsInSection:section];
}




@end
