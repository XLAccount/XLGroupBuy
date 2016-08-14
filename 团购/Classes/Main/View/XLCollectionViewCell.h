//
//  XLCollectionViewCell.h
//  团购
//
//  Created by 徐理 on 16/8/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLDeal,XLCollectionViewCell;

@protocol XLCollectionViewCellDelegate <NSObject>

@optional
- (void)cellDidClickCover:(XLCollectionViewCell *)dealCell checkVie:(UIView *)view;

@end

@interface XLCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XLDeal *deal;
@property (nonatomic, weak) id<XLCollectionViewCellDelegate> delegate;

@end
