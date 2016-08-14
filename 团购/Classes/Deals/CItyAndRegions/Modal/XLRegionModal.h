//
//  XLRegionModal.h
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLDropDownMenu.h"

@interface XLRegionModal : NSObject<XLDropDownMenuDelegete>

/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域 */
@property (strong, nonatomic) NSArray *subregions;


@end
