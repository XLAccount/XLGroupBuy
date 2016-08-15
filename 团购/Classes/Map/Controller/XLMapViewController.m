
//
//  XLMapViewController.m
//  团购
//
//  Created by 徐理 on 16/8/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "XLMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XLFindDealsParam.h"
#import "XLDeal.h"
#import "XLBusinesses.h"
#import "XLAnnotationModal.h"
#import "XLAnnotationRightBtn.h"
#import "XLDealDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "XLNavMenu.h"
#import "XLCatagoryViewController.h"
#import "XLCategoryModal.h"




@interface XLMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)backUserLocation;

@property (nonatomic, weak) XLNavMenu *navMenu;

@property (nonatomic, strong) XLCatagoryViewController *categoryViewController;

@property (nonatomic, strong) CLGeocoder *geocode;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) XLCategoryModal *category;
@property (nonatomic, copy) NSString *subCategoryName;

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) BOOL isdealing;

@end

@implementation XLMapViewController

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil){
    
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (XLCategoryModal *)category
{
    if (_category == nil){
    
        _category = [[XLCategoryModal alloc] init];
    }
    return _category;
}

- (XLCatagoryViewController *)categoryViewController
{
    if (_categoryViewController == nil){
    
        _categoryViewController = [[XLCatagoryViewController alloc] init];
    
    }
    return _categoryViewController;
}

- (CLGeocoder *)geocode
{
    if (_geocode == nil){
    
        _geocode = [[CLGeocoder alloc] init];
    }
    return _geocode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UIDevice currentDevice].systemVersion floatValue] > 8)
        
    {
        
        [self.locationManager requestAlwaysAuthorization];
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    if (self.deals.count == 0){
    
    [self alertVeiw];
        
    }
    
    [self setupNavigationBar];
    
    [self setupMap];
    
    [self setupDeals:self.deals];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNofication:) name:XLCategory object:nil];
    
}

- (void)alertVeiw
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"点击左上角菜单栏选择分类" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNofication:(NSNotification *)noti
{
    self.category = noti.userInfo[XLSelectCategory];
    self.navMenu.title.text = self.category.name;

    self.subCategoryName = noti.userInfo[XLCategorySubTitle];
    self.navMenu.subTitle.text = self.subCategoryName;

    
//    清空大头针
    [self.mapView removeAnnotations:self.mapView.annotations];

    // 加载最新的数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

- (void)setupNavigationBar
{
    self.title = @"地图";
    
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
    XLNavMenu *navMenu = [XLNavMenu navMenu];
    self.navMenu = navMenu;
    
    
    [navMenu addTarget:self action:@selector(setupDownMenu)];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:navMenu];
    
    
    
    self.navigationItem.leftBarButtonItems = @[backItem, menuItem];
}

- (void)setupDownMenu
{
    
    self.deals = nil;
    
    self.categoryViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.categoryViewController.popoverPresentationController.sourceView = self.navMenu;
    self.categoryViewController.popoverPresentationController.sourceRect = self.navMenu.bounds;

    self.categoryViewController.category = self.category;
    self.categoryViewController.subCategoryName = self.subCategoryName;
    
    [self presentViewController:self.categoryViewController animated:YES completion:nil];
}

- (void)setupMap
{
    

//    定位当前位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;


}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法

//获取到用户的位置就会调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if (self.deals.count == 0){
    
        //    创建区域
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        [mapView setRegion:region animated:YES];
    }

    
}

//改变位置的时候调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    
    [self.geocode reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0) return;
        
        CLPlacemark *placemark = [placemarks firstObject];
        
        NSString *str = placemark.addressDictionary[@"City"];
        
        self.cityName = [str substringToIndex:str.length - 1];
        
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];

    
    if (self.cityName == nil || self.isdealing || self.deals.count) return;
    
    self.isdealing = YES;
//    1.请求参数
    XLFindDealsParam *param = [[XLFindDealsParam alloc] init];
    
    CLLocationCoordinate2D center = mapView.region.center;
   
    
    if (self.category && ![self.category.name isEqualToString:@"全部分类"]) {
        if (self.subCategoryName && ![self.subCategoryName isEqualToString:@"全部"]) {
            param.category = self.subCategoryName;
        } else {
            param.category = self.category.name;
        }
    }
    
    
    param.latitude = @(center.latitude);
    param.longitude = @(center.longitude);
    param.radius = @5000;
    param.city = self.cityName;

    NSLog(@"%@",param.keyValues);
    
//    给服务器发送请求
    [XLDealTool findDeals:param success:^(XLFindDealsResult *result) {
        
        
        [self setupDeals:result.deals];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        
        self.isdealing = NO;

    }];
    
}


//处理团购数据
- (void)setupDeals:(NSArray *)deals
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (XLDeal *deal in deals) {

            
            for (XLBusinesses *businesses in deal.businesses) {
                
                XLAnnotationModal *anno = [[XLAnnotationModal alloc] init];
                anno.deal = deal;
                
                anno.coordinate = CLLocationCoordinate2DMake(businesses.latitude, businesses.longitude);
                
                anno.title = deal.title;
                anno.subtitle = businesses.name;
                
                
//                如果有值
                if (self.deals){
                    
                    anno.title = businesses.name;
                    anno.subtitle = businesses.address;
                    NSLog(@"%lf,%lf",businesses.latitude,businesses.longitude);
                
                //如果只有一家店自动定位那家店
                if (deal.businesses.count == 1){
                    
                    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(businesses.latitude, businesses.longitude);
                    
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
                    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
                    
                    [self.mapView setRegion:region animated:YES];

                }
                    
                    if (deal.businesses.count == 0){
                        
                        anno.title = deal.title;
                        anno.subtitle = businesses.name;
                    }

                }
                
                // 说明这个大头针已经存在这个数组中（已经显示过了）
                if ([self.mapView.annotations containsObject:anno]) continue;
                
                
                anno.deal = deal;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:anno];
                });
            }
        }

        
        self.isdealing = NO;
        
    });
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(XLAnnotationModal *)annotation
{
    if (![annotation isKindOfClass:[XLAnnotationModal class]]) return nil;
    
    static NSString *ID = @"deal";
    XLAnnotationRightBtn *rightBtn = nil;
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    
        // 显示标题和标题
        annoView.canShowCallout = YES;
        rightBtn = [[XLAnnotationRightBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [rightBtn setImage:[UIImage imageNamed:@"iconpng.png"] forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        annoView.rightCalloutAccessoryView = rightBtn;
    } else { // annoView是从缓存池取出来
        rightBtn = (XLAnnotationRightBtn *)annoView.rightCalloutAccessoryView;
    }
    
    
    // 覆盖模型数据
    annoView.annotation = annotation;
    // 设置图标
    if ([self.category.name isEqualToString:@"全部分类"]) {
        
        NSString *category = [annotation.deal.categories firstObject];
        NSString *mapIcon = [[XLDataTool shareXLDataTool] categoryWithName:category].map_icon;
        
//        不为空的时候在设置图片
        if (mapIcon.length){
            
            annoView.image = [UIImage imageNamed:mapIcon];
        }
        
        
    } else { // 特定的类别
        
        if (self.category.map_icon){
            
        annoView.image = [UIImage imageNamed:self.category.map_icon];
            
        }
    }
    
    
    if (self.deals) {
        
        annotation.deal = [self.deals lastObject];
        NSString *category = [annotation.deal.categories lastObject];
        NSString *mapIcon = [[XLDataTool shareXLDataTool] categoryWithName:category].map_icon;
        annoView.image = [UIImage imageNamed:mapIcon];
        
    }
    
    
    rightBtn.deal = annotation.deal;
    
    return annoView;
}

- (void)clickBtn:(XLAnnotationRightBtn *)btn
{
    XLDealDetailViewController *detail = [[XLDealDetailViewController alloc] init];
    
    detail.deal = btn.deal;
    
    [self presentViewController:detail animated:YES completion:nil];
}

- (IBAction)backUserLocation {
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView;
    for (annotationView in views)
    {
        if (![annotationView isKindOfClass:[MKPinAnnotationView class]])
        {
            CGRect endFrame = annotationView.frame;
            annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 300.0, endFrame.size.width, endFrame.size.height);
            
            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [annotationView setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}

@end
