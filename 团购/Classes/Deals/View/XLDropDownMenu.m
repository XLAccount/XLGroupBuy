

//
//  XLDropDownMenu.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLDropDownMenu.h"
#import "XLMainCell.h"
#import "XLSubViewCell.h"

@interface XLDropDownMenu ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainMenu;
@property (weak, nonatomic) IBOutlet UITableView *subMenu;

@end

@implementation XLDropDownMenu

+ (instancetype)dropDownMwnu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XLDropDownMenu" owner:nil options:nil] lastObject];
}

- (void)indexRowOfMainMenu:(NSInteger)row
{
    if (row == 9223372036854775807){
        row = 0;
    }
    
    [self.mainMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [self.subMenu reloadData];
}

- (void)indexRowOfSubMenu:(NSInteger)row
{
    [self.subMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

//控件即将被添加到窗口的时候调用
//- (void)willMoveToWindow:(UIWindow *)newWindow
//{
//    
//}

//重写set
- (void)setItem:(NSArray *)items
{
    _items = items;
    
//    刷新表格
    [self.mainMenu reloadData];
    [self.subMenu reloadData];
}

#pragma mark 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainMenu){
        
        return self.items.count;
    }else{
        
//        选中的哪一行
       NSInteger index = [self.mainMenu indexPathForSelectedRow].row;
        
//        设置代理对象为你选中的cell
        id<XLDropDownMenuDelegete> item = self.items[index];
        
//        返回代理方法，从中得带子标题
        return [item subtitles].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.mainMenu){
        
        XLMainCell *cell = [XLMainCell cellWithTableView:tableView];
        
        cell.item = self.items[indexPath.row];
        
        return cell;
    }else{
        XLSubViewCell *cell = [XLSubViewCell cellWithTableView:tableView];
        
        NSInteger index = [self.mainMenu indexPathForSelectedRow].row;
        
        id<XLDropDownMenuDelegete> item = self.items[index];
        
        cell.textLabel.text = [item subtitles][indexPath.row];
 
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainMenu){
        [self.subMenu reloadData];
        
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectMain:)]){
        
            [self.delegate dropDownMenu:self didSelectMain:indexPath.row];
        }
    }else {
        
        
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectSub:ofMain:)]){
            
//            选中的哪一行
            NSInteger mainRow = [self.mainMenu indexPathForSelectedRow].row;
            
            [self.delegate dropDownMenu:self didSelectSub:indexPath.row ofMain:mainRow];
        }
        
    }
}
@end