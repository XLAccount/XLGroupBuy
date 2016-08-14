//
//  XLCRTool.h
//  团购
//
//  Created by 徐理 on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareSingle.h"
@class XLDeal;

@interface XLCRTool : NSObject
XLSingletonH(XLCRTool)
/** 返回最近浏览的团购 */
@property (nonatomic, strong) NSMutableArray *recentDeal;
/**
 *  返回收藏的团购
 */
@property (nonatomic, strong) NSMutableArray *collectDeal;


/**
 *  保存收藏的团购
 */
- (void)saveCollectDeal:(XLDeal *)deal;
/**
 *  取消收藏的团购
 */
- (void)unsaveCollectDeal:(XLDeal *)deal;
- (void)unsaveCollectDeals:(NSArray *)deals;

/** 保存最近浏览的团购 */
- (void)saveRecentDeal:(XLDeal *)deal;
- (void)unsaveRecentDeal:(XLDeal *)deal;
- (void)unsaveRecentDeals:(NSArray *)deals;


@end
