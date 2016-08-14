
//
//  XLDeal.m
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLDeal.h"
#import "XLBusinesses.h"

@implementation XLDeal

MJCodingImplementation

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [XLBusinesses class]};
}

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

@end
