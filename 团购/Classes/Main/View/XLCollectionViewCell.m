
 //
//  XLCollectionViewCell.m
//  团购
//
//  Created by 徐理 on 16/8/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLDeal.h"

@interface XLCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

//自适应宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPriceLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listPriceLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *purchaseCountLabelWidth;

@property (weak, nonatomic) IBOutlet UIImageView *myNewOrderView;

- (IBAction)coverClick;


@property (weak, nonatomic) IBOutlet UIButton *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *checkView;

@end

@implementation XLCollectionViewCell

- (void)setDeal:(XLDeal *)deal
{
    _deal = deal;
    
//加载图片
    [self.imageView setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
//    标题
    self.titleLabel.text = deal.title;
//    描述
    self.descLabel.text = deal.desc;
//    现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"💰%0.2f",[deal.current_price floatValue]];
//    原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"💰%0.2f",[deal.list_price floatValue]];
//    购买数量
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售出%ld",deal.purchase_count];
    
    self.currentPriceLabelWidth.constant = [self.currentPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.currentPriceLabel.font}].width + 1;
    
    self.listPriceLabelWidth.constant = [self.listPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.listPriceLabel.font}].width + 1;
    
    self.purchaseCountLabelWidth.constant = [self.purchaseCountLabel.text sizeWithAttributes:@{NSFontAttributeName : self.purchaseCountLabel.font}].width + 1;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy - MM - dd";
    NSString *dateStr = [formatter stringFromDate:date];
    
//    如果今天日期大于发布日期隐藏
    self.myNewOrderView.hidden = [dateStr compare:deal.publish_date] == NSOrderedDescending;

    if (deal.isEditing){
        self.coverView.hidden = NO;
        self.coverView.alpha = 0.3;
    }else{
        self.coverView.hidden = YES;
        self.checkView.hidden = YES;
    }
    
    self.checkView.hidden = !self.deal.isChecking;
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

- (IBAction)coverClick {
    
    self.deal.checking = !self.deal.isChecking;
    
    self.checkView.hidden = !self.checkView.hidden;
    
    if ([self.delegate respondsToSelector:@selector(cellDidClickCover:checkVie:)]){
        
        [self.delegate cellDidClickCover:self checkVie:self.checkView];
    }
}
@end
