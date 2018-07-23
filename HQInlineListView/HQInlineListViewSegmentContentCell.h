//
//  HQInlineListViewSegmentContentCell.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQInlineListViewConfig.h"
#import "HQInlineListViewMacro.h"

@class HQInlinePageView;
@interface HQInlineListViewSegmentContentCell : UITableViewCell
@property (nonatomic, copy) NSInteger (^numberOfItemsBlock)(void);
@property (nonatomic, copy) NSString *(^titleAtIndexBlock)(NSInteger index);
@property (nonatomic, copy) HQInlinePageView *(^pageViewAtIndexBlock)(NSInteger index);
//@property (nonatomic, readonly) NSArray <NSString *> *segmentTitles;
//@property (nonatomic, readonly) NSArray <UIScrollView *> *pageViews;
@property (nonatomic, weak) HQInlineListViewConfig *config;
- (void)reloadData;
- (void)reloadTitles;
@end
