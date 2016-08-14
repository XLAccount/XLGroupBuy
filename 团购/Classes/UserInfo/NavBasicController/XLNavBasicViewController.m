//
//  XLNavBasicViewController.m
//  团购
//
//  Created by 徐理 on 16/8/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLNavBasicViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XLDeal.h"
#import "XLCollectionViewCell.h"
#import "XLCRTool.h"
#import "MBProgressHUD+MJ.h"
#import "XLRecentViewController.h"


@interface XLNavBasicViewController ()<XLCollectionViewCellDelegate>

@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, strong) UIBarButtonItem *editBtn;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@end

@implementation XLNavBasicViewController

- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        
        self.backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (_selectAllItem == nil) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"   全选   " style:UIBarButtonItemStylePlain target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)editBtn
{
    if (_editBtn == nil){
    self.editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    }
    return _editBtn;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (_unselectAllItem == nil) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"   全不选   " style:UIBarButtonItemStylePlain target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)deleteItem
{
    if (_deleteItem == nil) {
        self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"   删除   " style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
        self.deleteItem.enabled = NO;
    }
    return _deleteItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    //设置右上角编辑按钮
    self.navigationItem.rightBarButtonItem = self.editBtn;
    
}


- (void)edit
{
    if ([self.editBtn.title isEqualToString:@"编辑"]){
        self.editBtn.title = @"完成";
        
        for (XLDeal *deal in self.deals) {
            
            deal.editing = YES;
        }
        
        [self cellDidClickCover:nil checkVie:nil];
        
        [self.collectionView reloadData];
        
        // 左边显示4个item
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.deleteItem];
    }else{
        
        for (XLDeal *deal in self.deals) {
            
            if (deal.isChecking){
                
                [MBProgressHUD showError:@"有未完成操作！！！"];
                
                return;
            }
        }
        self.editBtn.title = @"编辑";
        
        for (XLDeal *deal in self.deals) {
            
            deal.editing = NO;
            deal.checking = NO;
        }
        
        [self.collectionView reloadData];
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
    
}

/**
 *  返回
 */
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (XLDeal *deal in self.deals) {
        
        deal.editing = NO;
        deal.checking = NO;
    }
}

/**
 *  全选
 */
- (void)selectAll
{
    for (XLDeal *deal in self.deals) {
        
        deal.checking = YES;
    }
    [self cellDidClickCover:nil checkVie:nil];
    [self.collectionView reloadData];
}

/**
 *  删除
 */
- (void)delete
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (XLDeal *deal in self.deals) {
        
        if (deal.isChecking){
            
            [array addObject:deal];
            
        }
    }
    
    if ([self isKindOfClass:[XLCollectionViewCell class]]){
    
    [[XLCRTool shareXLCRTool] unsaveCollectDeals:array];
    
    }else{
        [[XLCRTool shareXLCRTool] unsaveRecentDeals:array];
    }
    
    
    [self.deals removeObjectsInArray:array];
    
    [self cellDidClickCover:nil checkVie:nil];
    
    [self.collectionView reloadData];
}

/**
 *  全不选
 */
- (void)unselectAll
{
    for (XLDeal *deal in self.deals) {
        
        deal.checking = NO;
    }
    
    [self cellDidClickCover:nil checkVie:nil];
    [self.collectionView reloadData];
}

- (void)cellDidClickCover:(XLCollectionViewCell *)dealCell checkVie:(UIView *)view
{
    
    BOOL deleteEable = NO;
    int checkingCount = 0;
    // 1.删除item的状态
    for (XLDeal *deal in self.deals) {
        if (deal.isChecking) {
            deleteEable = YES;
            checkingCount++;
        }
    }
    self.deleteItem.enabled = deleteEable;
    
    // 2.删除item的文字
    if (checkingCount) {
        self.deleteItem.title = [NSString stringWithFormat:@"   删除(%d)   ", checkingCount];
    } else {
        self.deleteItem.title = @"   删除   ";
    }
}
@end
