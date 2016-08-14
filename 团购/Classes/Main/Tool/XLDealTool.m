//
//  XLDealTool.m
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLDealTool.h"
#import "XLApiTool.h"
#import "XLDeal.h"

@implementation XLDealTool

+ (void)findDeals:(XLFindDealsParam *)params success:(void (^)(XLFindDealsResult *))success failure:(void (^)(NSError *))failure
{
    [[XLApiTool shareapiTool] request:@"v1/deal/find_deals" params:params.keyValues success:^(id result) {
        
        XLFindDealsResult *obj = [XLFindDealsResult objectWithKeyValues:result];
        
        success(obj);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)singDeal:(XLSingleParam *)params success:(void (^)(XLSingleResult *))success failure:(void (^)(NSError *))failure
{
    [[XLApiTool shareapiTool] request:@"v1/deal/get_single_deal" params:params.keyValues success:^(id result) {
        
        XLSingleResult *dealsResult = [XLSingleResult objectWithKeyValues:result];
        success(dealsResult);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
