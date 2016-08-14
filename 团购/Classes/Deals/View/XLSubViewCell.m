 //
//  XLSubViewCell.m
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLSubViewCell.h"

@implementation XLSubViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    XLSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell){
        cell = [[XLSubViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
    self.backgroundView = bg;
    
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
    self.selectedBackgroundView = selectedBg;
    
    return self;
}
@end
