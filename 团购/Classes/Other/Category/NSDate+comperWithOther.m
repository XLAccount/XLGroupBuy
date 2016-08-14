



//
//  NSDate+comperWithOther.m
//  团购
//
//  Created by 徐理 on 16/8/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSDate+comperWithOther.h"

@implementation NSDate (comperWithOther)

+ (NSString *)dateWithFirstTime:(NSDate *)firstTime andOtherTime:(NSString *)otherTitme
{

    // 过期时间 2014-08-28 00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadTime = [[fmt dateFromString:otherTitme] dateByAddingTimeInterval:24 * 3600];
    // 比较2个时间的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:firstTime toDate:deadTime options:0];
    if (cmps.day > 365) {
       
        return @"一年之内不过期";
    } else {
        
        return [NSString stringWithFormat:@"%ld天%ld小时%ld分", cmps.day, cmps.hour, cmps.minute];
    }

}

@end
