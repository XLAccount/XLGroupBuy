//
//  XLAnnotationModal.h
//  团购
//
//  Created by 徐理 on 16/8/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "XLDeal.h"

@interface XLAnnotationModal : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) XLDeal *deal;
@end
