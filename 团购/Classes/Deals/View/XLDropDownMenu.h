//
//  XLDropDownMenu.h
//  团购
//
//  Created by 徐理 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLDropDownMenu;

@protocol XLDropDownMenuDelegete <NSObject>

/** 标题 */
- (NSString *)title;
/** 子标题数据 */
- (NSArray *)subtitles;
@optional
/** 图标 */
- (NSString *)image;
/** 选中的图标 */
- (NSString *)highlightedImage;
@end

@protocol XLDropDownSubMenuDelegete <NSObject>

- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectMain:(NSInteger)row;
- (void)dropDownMenu:(XLDropDownMenu *)dropDownMwnu didSelectSub:(NSInteger)row ofMain:(NSInteger)mainRow;

@end

@interface XLDropDownMenu : UIView

@property (nonatomic, weak)id<XLDropDownSubMenuDelegete> delegate;

+ (instancetype)dropDownMwnu;

//显示数据模型
@property (nonatomic, strong) NSArray *items;

- (void)indexRowOfMainMenu:(NSInteger)row;
- (void)indexRowOfSubMenu:(NSInteger)row;
@end
