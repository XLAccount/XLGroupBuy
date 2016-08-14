

//
//  NSArray+Ectension.m
//  团购
//
//  Created by 徐理 on 16/8/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
@end

@implementation NSDictionary (Extension)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
            id value= self[key];
            [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
        }
    [str appendString:@"}"];
    return str;
}
@end