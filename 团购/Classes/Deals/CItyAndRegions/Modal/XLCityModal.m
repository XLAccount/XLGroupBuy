//
//  XLCityModal.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCityModal.h"
#import "XLRegionModal.h"

@implementation XLCityModal

- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [XLRegionModal class]};
}

@end
