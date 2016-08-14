
//
//  XLBasicCollectionViewController.m
//  团购
//
//  Created by 徐理 on 16/8/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLBasicCollectionViewController.h"
#import "XLEmptyView.h"
#import "XLCollectionViewCell.h"
#import "XLDealDetailViewController.h"

@interface XLBasicCollectionViewController () <XLCollectionViewCellDelegate>
@property (nonatomic, weak) XLEmptyView *empty;
@end

@implementation XLBasicCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)deals
{
    if (_deals == nil){
    
        _deals = [NSMutableArray array];
    }
    return _deals;
}


- (XLEmptyView *)empty
{
    if (_empty == nil){
    
        XLEmptyView *empty = [[XLEmptyView alloc] init];
        
        empty.image = [UIImage imageNamed:self.emptyName];
        
        [self.view insertSubview:empty aboveSubview:self.collectionView];
        
        _empty = empty;
    }
    return _empty;
}

#pragma mark 初始化方法
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(305, 305);
    
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setupBasicView];
    
    
  
}

- (void)setupBasicView
{
    self.collectionView.alwaysBounceVertical = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(230)/255.0 green:(230)/255.0 blue:(230)/255.0 alpha:1.0];
    
//    cell用xib创建必须注册nib不能注册类
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}



#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    self.empty.hidden = self.deals.count != 0;
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLDealDetailViewController *dealDetailViewController = [[XLDealDetailViewController alloc] init];
    dealDetailViewController.deal = self.deals[indexPath.item];
    
    [self presentViewController:dealDetailViewController animated:YES completion:nil];
}


#pragma mark - 应该要在：即将显示view的时候，根据屏幕方向调整cell的间距
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
}

#pragma mark - 处理屏幕的旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSInteger columns = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? 4 : 2;
    
    [self setupWithColumn:columns];
}

/**
 *  调整布局
 *
 *  @param totalWidth 总宽度
 *  @param orientation 显示的方向
 */
- (void)setupWithColumn:(NSInteger)columns
{
    //    self.collectionViewLayout == self.collectionView.collectionViewLayout;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    // 每一行的最小间距
    CGFloat lineSpacing = 25;
    // 每一列的最小间距
    CGFloat interitemSpacing = 105.3 / columns;
    
    layout.minimumInteritemSpacing = interitemSpacing;
    layout.minimumLineSpacing = lineSpacing;
    // 设置cell与CollectionView边缘的间距
    layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
}



@end
