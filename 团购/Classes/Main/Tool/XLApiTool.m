

//
//  XLApiTool.m
//  团购
//
//  Created by 徐理 on 16/7/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLApiTool.h"
#import "DPAPI.h"

@interface XLApiTool ()<DPRequestDelegate>

@property (nonatomic, strong) DPAPI *api;
@end

@implementation XLApiTool

XLSingletonM(apiTool)

- (DPAPI *)api
{
    if (_api == nil){
        self.api = [[DPAPI alloc] init];
    }
    return _api;
}

- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DPRequest *request = [self.api requestWithURL:url params:[NSMutableDictionary dictionaryWithDictionary:params] delegate:self];
    
    request.success = success;
    request.failure = failure;
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success){
        request.success(result);
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request.failure){
        request.failure(error);
    }
}

@end
