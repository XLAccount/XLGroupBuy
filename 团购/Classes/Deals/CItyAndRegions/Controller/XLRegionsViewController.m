//
//  XLRegionsViewController.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLRegionsViewController.h"
#import "XLDropDownMenu.h"
#import "XLCityModal.h"
#import "XLCityMenuViewContriller.h"
#import "XLNavController.h"
#import "XLRegionModal.h"
#import "XLSearchCityController.h"

@interface XLButton : UIButton

@end

@implementation XLButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.width * 0.2, 0, self.width, self.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20, 0, self.width * 0.2, self.height);
}
@end

@interface XLRegionsViewController () <XLDropDownSubMenuDelegete>

@property (nonatomic, weak) UIView *myView;
@property (nonatomic, weak) XLButton *myBtn;
@property (nonatomic, weak) UIImageView *myImage;
@property (nonatomic, weak) XLDropDownMenu *menu;
@end

@implementation XLRegionsViewController

- (XLDropDownMenu *)menu
{
    if (_menu == nil){
        
        XLDropDownMenu *menu = [XLDropDownMenu dropDownMwnu];
        
        menu.delegate = self;
        
        [self.view addSubview:menu];
        
        
        [menu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [menu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myView withOffset:0];
        

        _menu = menu;

    }
    return _menu;
}

- (UIView *)myView
{
    if (_myView == nil){
        
        UIView *myView = [[UIView alloc] init];
        _myView = myView;
        
        [self.view addSubview:myView];
        
        [self.myView autoSetDimension:ALDimensionHeight toSize:44];
        [self.myView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
 
        [self myBtn];
        [self myImage];
        
    }
    return _myView;
}

- (XLButton *)myBtn
{
    if (_myBtn == nil){
    
        XLButton *myBtn = [[XLButton alloc] init];
        [myBtn setTitle:@"切换城市" forState:UIControlStateNormal];
        [myBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [myBtn setImage:[UIImage imageNamed:@"btn_changeCity"] forState:UIControlStateNormal];
        [myBtn setImage:[UIImage imageNamed:@"btn_changeCity_selected"] forState:UIControlStateHighlighted];
        
        [myBtn addTarget:self action:@selector(myBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        myBtn.imageView.contentMode = UIViewContentModeLeft;
        
        _myBtn = myBtn;
        
        [self.myView addSubview:self.myBtn];
        
        [self.myBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _myBtn;
}

- (UIImageView *)myImage
{
    if (_myImage == nil){
    
        UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        _myImage = myImage;
        
        myImage.contentMode = UIViewContentModeCenter;
        
        [self.myView addSubview:_myImage];
        
        [_myImage autoSetDimension:ALDimensionWidth toSize:44];
        [_myImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
    }
    return _myImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.preferredContentSize = CGSizeMake(400, 480);

    self.menu.delegate = self;
    [self myView];
   }

- (void)myBtnClick
{
//    取消模态
    [self dismissViewControllerAnimated:YES completion:nil] ;

//    调用block弹出城市列表
    if (self.changeCityBlock){
        self.changeCityBlock();
    }

}

- (void)setRegions:(NSArray *)regions
{
    _regions = regions;
    
    self.menu.items = regions;

}

- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectMain:(NSInteger)row
{
    XLRegionModal *region = dropDownMwnu.items[row];
   
    
    if (region.subregions.count == 0){
        
    [[NSNotificationCenter defaultCenter] postNotificationName:XLSelectRegions object:nil userInfo:@{XLSelectRegions : region}];
     [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectSub:(NSInteger)row ofMain:(NSInteger)mainRow
{
    XLRegionModal *region = dropDownMwnu.items[mainRow];

    NSString *subTitle = region.subregions[row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XLSelectRegions object:nil userInfo:@{XLSelectRegions : region, XLSelectRegionsSubTitle : subTitle}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setRegion:(XLRegionModal *)region
{
    _region = region;
    
    NSInteger mainRow = [self.menu.items indexOfObject:region];

    [self.menu indexRowOfMainMenu:mainRow];
}

- (void)setSubRegionName:(NSString *)subRegionName
{
    _subRegionName = [subRegionName copy];
    
    NSInteger subRow = [self.region.subregions indexOfObject:subRegionName];
    
    [self.menu indexRowOfSubMenu:subRow];
}

@end
