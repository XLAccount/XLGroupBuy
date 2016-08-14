//
//  XLMoreCollectionViewController.m
//  团购
//
//  Created by 徐理 on 16/8/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLMoreCollectionViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface XLMoreCollectionViewController ()

@end

@implementation XLMoreCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多";
    
    [self setupNavigationBar];
    

}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSString *)emptyName
{
    return @"ic_order_empty";
}

@end
