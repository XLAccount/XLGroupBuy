
//
//  XLAnnotationModal.m
//  团购
//
//  Created by 徐理 on 16/8/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLAnnotationModal.h"

@implementation XLAnnotationModal

- (BOOL)isEqual:(XLAnnotationModal *)other
{
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
}

@end
