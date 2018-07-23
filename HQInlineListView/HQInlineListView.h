//
//  HQInlineListView.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQInlineListViewConfig.h"
#import "HQInlineListViewMacro.h"
#import "HQInlinePageView.h"

@class HQInlineListView;
@class HQInlinePageView;
@protocol HQInlineListViewDataSource<NSObject>
@required

- (NSInteger)listView:(HQInlineListView *)listView numberOfRowsInSection:(NSInteger)section;
- (__kindof UITableViewCell *)listView:(HQInlineListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfItemsInSegementViewWithListView:(HQInlineListView *)HQInlineListView;
- (NSString *)listView:(HQInlineListView *)listView titleInSegementViewAtIndex:(NSInteger)index;
- (HQInlinePageView *)listView:(HQInlineListView *)listView pageViewInSegementViewAtIndex:(NSInteger)index;

@optional
- (NSInteger)numberOfSectionsInListView:(HQInlineListView *)HQInlineListView;
@end


@protocol HQInlineListViewDelegate<NSObject>
@required
- (CGFloat)listView:(HQInlineListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (HQInlineListViewConfig *)configOfListView:(HQInlineListView *)HQInlineListView;
@end



@interface HQInlineListView : UIView
@property (nonatomic, weak) id<HQInlineListViewDataSource> dataSource;
@property (nonatomic, weak) id<HQInlineListViewDelegate> delegate;
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;
- (void)reloadSegmentTitles;
@end
