//
//  XLCRTool.m
//  团购
//
//  Created by 徐理 on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCRTool.h"
#import "XLDeal.h"

#define XLRecentDealFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentdeal.plist"]
#define XLCollectDealFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collectdeal.plist"]



@interface XLCRTool (){
    
    NSMutableArray *_recentDeal;
    NSMutableArray *_collectDeal;
}


@end

@implementation XLCRTool
XLSingletonM(XLCRTool)

- (NSMutableArray *)recentDeal
{
    if (_recentDeal == nil){
    
        
        _recentDeal = [NSKeyedUnarchiver unarchiveObjectWithFile:XLRecentDealFile];
        
        
        if (_recentDeal == nil){
            
            _recentDeal = [NSMutableArray array];
            
        }
    }
    return _recentDeal;
}

- (NSMutableArray *)collectDeal
{
    if (_collectDeal == nil){
    
        _collectDeal = [NSKeyedUnarchiver unarchiveObjectWithFile:XLCollectDealFile];
        
        
        if (_collectDeal == nil){
            _collectDeal = [NSMutableArray array];
        }
    }
    return _collectDeal;
}

- (void)saveRecentDeal:(XLDeal *)deal
{
//    移除相同的团购信息

    NSMutableArray *mutableArray = [NSMutableArray array];
    for (XLDeal *allDeal in self.recentDeal) {
        
        if ([deal.deal_id isEqualToString:allDeal.deal_id]){
            
            [mutableArray addObject:allDeal];
        }
    }
    [self.recentDeal removeObjectsInArray:mutableArray];
    
    [self.recentDeal insertObject:deal atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.recentDeal toFile:XLRecentDealFile];
}

- (void)unsaveRecentDeals:(NSArray *)deals
{
    [self.recentDeal removeObjectsInArray:deals];

    [NSKeyedArchiver archiveRootObject:self.recentDeal toFile:XLRecentDealFile];
}

- (void)unsaveRecentDeal:(XLDeal *)deal
{
    [self.recentDeal removeObject:deal];
    
    [NSKeyedArchiver archiveRootObject:self.recentDeal toFile:XLRecentDealFile];
}

- (void)saveCollectDeal:(XLDeal *)deal
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (XLDeal *allDeal in self.collectDeal) {
        
        if ([allDeal.deal_id isEqualToString:deal.deal_id]){
            
            [array addObject:allDeal];
        }
    }
    
    [self.collectDeal removeObjectsInArray:array];
    

    
    [self.collectDeal insertObject:deal atIndex:0];
    
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeal toFile:XLCollectDealFile];
}

- (void)unsaveCollectDeal:(XLDeal *)deal
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (XLDeal *allDeal in self.collectDeal) {
        
        if ([allDeal.deal_id isEqualToString:deal.deal_id]){
            
            [array addObject:allDeal];
            
        }
    }
    [self.collectDeal removeObjectsInArray:array];
    
    
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeal toFile:XLCollectDealFile];

}


- (void)unsaveCollectDeals:(NSArray *)deals
{
    [self.collectDeal removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeal toFile:XLCollectDealFile];
}

@end
