//
//  XLBasicCollectionViewController.h
//  团购
//
//  Created by 徐理 on 16/8/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBasicCollectionViewController : UICollectionViewController

/** 记录团购信息 */
@property (nonatomic, strong) NSMutableArray *deals;

//@property (nonatomic, copy) NSString *emptyName;

- (NSString *)emptyName;

@end
