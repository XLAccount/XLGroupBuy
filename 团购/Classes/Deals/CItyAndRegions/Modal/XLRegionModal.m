
//
//  XLRegionModal.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLRegionModal.h"

@implementation XLRegionModal

- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subregions;
}
@end
