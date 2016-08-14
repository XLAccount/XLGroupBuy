
//
//  XLSearchCityController.m
//  团购
//
//  Created by 徐理 on 16/8/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLSearchCityController.h"
#import "XLCityModal.h"

@interface XLSearchCityController ()

@property (nonatomic, strong) NSArray *searchCities;
@end

@implementation XLSearchCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setSearchStr:(NSString *)searchStr
{
    _searchStr = searchStr;
    
    // 根据搜索条件进行过滤
    NSArray *allCities = [XLDataTool shareXLDataTool].cities;
    
    // 将搜索条件转为小写
    NSString *lowerSearchText = searchStr.lowercaseString;

    
    //    NSPredicate * 预言\过滤器\谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText, lowerSearchText, lowerSearchText];
    self.searchCities = [allCities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    XLCityModal *modal = self.searchCities[indexPath.row];
    
    cell.textLabel.text = modal.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"一共有%ld个搜索结果",self.searchCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    想模态一个控制器的父控制必须让他成为一个控制器的子控制器
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    XLCityModal *city = self.searchCities[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XLSelectCity object:nil userInfo:@{XLSelectCity : city}];
}

@end
