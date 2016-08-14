

//
//  XLCatagoryViewController.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCatagoryViewController.h"
#import "XLDropDownMenu.h"
#import "XLCategoryModal.h"

@interface XLCatagoryViewController ()<XLDropDownSubMenuDelegete>

@property (nonatomic, strong) XLDropDownMenu *menu;

@end

@implementation XLCatagoryViewController

- (XLDropDownMenu *)menu
{
    if (_menu == nil){
        _menu = [XLDropDownMenu dropDownMwnu];
    }
    return _menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredContentSize = CGSizeMake(400, 480);
    
    self.menu.delegate = self;
    self.menu.items = [XLDataTool shareXLDataTool].categories;
    self.view = self.menu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 代理方法
- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectMain:(NSInteger)row
{
    XLCategoryModal *modal = dropDownMwnu.items[row];
    
    if (modal.subcategories.count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:XLCategory object:nil userInfo:@{XLSelectCategory : modal}];
        
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectSub:(NSInteger)row ofMain:(NSInteger)mainRow
{
    XLCategoryModal *modal = dropDownMwnu.items[mainRow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XLCategory object:nil userInfo:@{XLSelectCategory : modal, XLCategorySubTitle : modal.subcategories[row]}];
 
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCategory:(XLCategoryModal *)category
{
    _category = category;
    
    NSInteger mainRow = [self.menu.items indexOfObject:category];

    
    [self.menu indexRowOfMainMenu:mainRow];
}

- (void)setSubCategoryName:(NSString *)subCategoryName
{
    _subCategoryName = [subCategoryName copy];
    
    NSInteger subRow = [self.category.subcategories indexOfObject:subCategoryName];
    
    [self.menu indexRowOfSubMenu:subRow];
}

@end
