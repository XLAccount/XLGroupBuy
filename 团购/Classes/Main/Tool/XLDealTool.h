//
//  XLDealTool.h
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFindDealsParam.h"
#import "XLFindDealsResult.h"
#import "XLSingleParam.h"
#import "XLSingleResult.h"

@interface XLDealTool : NSObject

+ (void)findDeals:(XLFindDealsParam *)params success:(void (^)(XLFindDealsResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)singDeal:(XLSingleParam *)params success:(void (^)(XLSingleResult *result))success failure:(void (^)(NSError *error))failure;

@end
