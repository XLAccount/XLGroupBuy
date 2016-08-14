//
//  XLFindDealsResult.h
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSingleResult.h"

@interface XLFindDealsResult : XLSingleResult

/** 所有页面团购总数 */
@property (assign, nonatomic) int total_count;

@end
