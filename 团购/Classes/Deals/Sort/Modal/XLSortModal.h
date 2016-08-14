//
//  XLSortModal.h
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XLSortModal : NSObject

/** 1.默认排序 2.价格最低 3.价格最高 4.人气最高 5.最新发布 6.即将结束 7.离我最近 */
@property (assign, nonatomic) NSInteger value;
@property (copy, nonatomic) NSString *label;

@end
