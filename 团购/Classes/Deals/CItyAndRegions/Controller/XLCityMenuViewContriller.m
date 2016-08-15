
//
//  XLCityMenuViewContriller.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCityMenuViewContriller.h"
#import "XLCityGroupModal.h"
#import "XLSearchCityController.h"
#import "XLCityModal.h"
#import <MapKit/MapKit.h>

@interface XLCityMenuViewContriller ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XLCityGroupModal *modal;

@property (nonatomic, strong) XLSearchCityController *searchCity;

@property (nonatomic, copy) NSString *userTrackingCity;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation XLCityMenuViewContriller

- (XLSearchCityController *)searchCity
{
    if (_searchCity == nil){
    
        _searchCity = [[XLSearchCityController alloc] init];
        
        [self addChildViewController:_searchCity];
    }
    return _searchCity;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mySearchBar.placeholder = @"请输入城市名称或拼音";
    self.coverView.alpha = 0;
}


//开始编辑的时候调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];

//    显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.viewTopConstraint.constant = -62;
        
        self.coverView.alpha = 0.7;
    }];

    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     [self.searchCity.view removeFromSuperview];
        if (searchText.length > 0){
    
//            输入的信息
            self.searchCity.searchStr = searchText;
            
            [self.view addSubview:self.searchCity.view];
            
            [self.searchCity.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.searchCity.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.coverView];
        }
    
}


//结束编辑的时候调用
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    如果正在Modal直接返回
    if ([self isBeingDismissed]) return;
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    searchBar.text = nil;
    [self.searchCity.view removeFromSuperview];
    
    // 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    

    [UIView animateWithDuration:0.25 animations:^{
        
          self.viewTopConstraint.constant = 0;
        
        self.coverView.alpha = 0;
//        执行约束动画
//        [self.view layoutIfNeeded];
    }];

    
}

//点击取消按钮的时候调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.viewTopConstraint.constant = 0;
        //        执行约束动画
        //        [self.view layoutIfNeeded];
    }];
    
    [searchBar resignFirstResponder];
    
    // 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    

}

- (IBAction)cancleBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//是否禁止键盘自动退出
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

#pragma mark UITableViewController 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [XLDataTool shareXLDataTool].cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.modal = [XLDataTool shareXLDataTool].cityGroups[section];

    return self.modal.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
        
         self.modal = [XLDataTool shareXLDataTool].cityGroups[indexPath.section];
    
        cell.textLabel.text = self.modal.cities[indexPath.row];
    
    
    if ([cell.textLabel.text isEqualToString:@"正在获取当前位置..."]){
        
        cell.userInteractionEnabled = NO;
        
    }else{
        cell.userInteractionEnabled = YES;
    }
    
        return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    self.modal = [XLDataTool shareXLDataTool].cityGroups[section];
    return self.modal.title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[XLDataTool shareXLDataTool].cityGroups valueForKeyPath:@"title"];
//
//    NSArray *array = [XLDataTool shareXLDataTool].cityGroups;
//    
//    NSMutableArray *mutable = [NSMutableArray array];
//    
//    for (XLCityGroupModal *modal in array) {
//        
//        [mutable addObject:modal.title];
//    }
//    
//    return mutable;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.modal = [XLDataTool shareXLDataTool].cityGroups[indexPath.section];
    
    NSString *str = self.modal.cities[indexPath.row];
    
    if ([str isEqualToString:@"获取当前位置"] || [str isEqualToString:@"获取位置失败,请重试"]){
        
        
        
        [XLDataTool shareXLDataTool].userTrackingCity = @"正在获取当前位置...";
        [self.tableView reloadData];
        
        [self userLocation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.userTrackingCity.length == 0){
                
                    [MBProgressHUD showError:@"获取位置失败"];
                [XLDataTool shareXLDataTool].userTrackingCity = @"获取位置失败,请重试";
                [self.tableView reloadData];
            }
                
            });
            
        });

        
        return;
    }
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
    XLCityModal *city = [[XLDataTool shareXLDataTool] cityWithName:str];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XLCity object:nil userInfo:@{XLSelectCity : city}];

}

- (void)userLocation
{
    
    
    if([[UIDevice currentDevice].systemVersion floatValue] > 8)
        
    {
        
        self.locationManager =[ [CLLocationManager alloc] init];
        
        [self.locationManager requestAlwaysAuthorization];
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    // 判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
    } else {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前无法定位" message:@"请检查设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:action];
     
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.userTrackingCity = placeMark.locality;
            
            self.userTrackingCity = [self.userTrackingCity substringToIndex:self.userTrackingCity.length - 1];
            
            
            [XLDataTool shareXLDataTool].userTrackingCity = self.userTrackingCity;
            
            [self.tableView reloadData];
            
            [MBProgressHUD showSuccess:@"定位成功"];
            
        } else if (error == nil && placemarks.count == 0) {
        
        
    } else if (error) {
        
    }
     }];
    
    [manager stopUpdatingLocation];
}


@end
