//
//  XLApiTool.h
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareSingle.h"

@interface XLApiTool : NSObject<NSCopying>

- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

XLSingletonH(apiTool)
@end
