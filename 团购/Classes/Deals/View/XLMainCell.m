
//
//  XLMainCell.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLMainCell.h"

@interface XLMainCell ()

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation XLMainCell

- (UIImageView *)rightArrow
{
    if (_rightArrow == nil){
        
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    }
    return _rightArrow;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    XLMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell){
    
        cell = [[XLMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = selectedBg;
    }
    return self;
}

- (void)setItem:(id<XLDropDownMenuDelegete>)item
{
    _item = item;
    
//    设置主标题
    self.textLabel.text = [item title];
    
//    是否有图片
    if ([item respondsToSelector:@selector(image)]){
        
//        设置图片
        self.imageView.image = [UIImage imageNamed:[item image]];
        self.imageView.highlightedImage = [UIImage imageNamed:[item highlightedImage]];
    }
    
    if ([item subtitles].count > 0){
    self.accessoryView = self.rightArrow;
    }else{
        self.accessoryView = nil;
    }
}

@end
