//
//  XLRegionsViewController.h
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLRegionModal;

@interface XLRegionsViewController : UIViewController

@property (nonatomic, copy) void (^changeCityBlock)();

@property (nonatomic, strong) NSArray *regions;

@property (nonatomic, strong) XLRegionModal *region;
@property (nonatomic, copy) NSString *subRegionName;
@end
