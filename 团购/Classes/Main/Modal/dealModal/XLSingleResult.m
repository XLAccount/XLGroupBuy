//
//  XLSingleResult.m
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLSingleResult.h"
#import "XLDeal.h"

@implementation XLSingleResult
MJCodingImplementation
- (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [XLDeal class]};
}

@end
