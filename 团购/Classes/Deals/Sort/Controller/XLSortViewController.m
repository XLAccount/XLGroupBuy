//
//  XLSortViewController.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLSortViewController.h"
#import "XLSortModal.h"
#import "UIView+Extension.h"
#import "XLDataTool.h"

@interface XLBtn : UIButton

@property (nonatomic, strong) XLSortModal *sort;

@end

@implementation XLBtn


@end

@interface XLSortViewController ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, weak) XLBtn *btn;
@end

@implementation XLSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = self.view.size;
    
    self.array = [XLDataTool shareXLDataTool].sorts;
    [self setupMenuBtn];
}

- (void)setupMenuBtn
{

    
    NSInteger count = self.array.count;
    
    for (int i = 0; i < count; i++ ){

        XLBtn *btn = [[XLBtn alloc] init];
        
        btn.sort = self.array[i];
        
        [btn setTitle:btn.sort.label forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateSelected];
        
        btn.sort.value = i + 1;
        
        btn.width = self.view.width - 40;
        btn.height = 30;
        btn.x = 20;
        btn.y = i * (btn.height + 15) + 20;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
 
        
        [self.view addSubview:btn];
        
        
    }
}

- (void)btnClick:(XLBtn *)btn
{
    self.btn.selected = NO;
    btn.selected = YES;
    self.btn = btn;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XLSort object:nil userInfo:@{XLSortTitle : btn.sort}];


    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
