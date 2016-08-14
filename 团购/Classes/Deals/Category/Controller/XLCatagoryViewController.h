//
//  XLCatagoryViewController.h
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLCategoryModal;

@interface XLCatagoryViewController : UIViewController

@property (nonatomic, strong) XLCategoryModal *category;
@property (nonatomic, copy) NSString *subCategoryName;

@end
