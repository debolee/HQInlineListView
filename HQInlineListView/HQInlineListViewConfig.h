//
//  HQInlineListViewConfig.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQInlineListViewConfig : UIView
/** title默认状态的颜色 */
@property (nonatomic, strong) UIColor *normalTitleColor;
/** title选中状态的颜色 */
@property (nonatomic, strong) UIColor *selectedTitleColor;
/** title选中状态的颜色 */
@property (nonatomic, strong) UIFont *titleFont;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 滚动条的颜色 */
@property (nonatomic, assign) CGFloat segmentViewHeight;
/** 向上滑动停止时titleView距离顶部的高度 */
@property (nonatomic, assign) CGFloat segmentViewTopSpace;
@property (nonatomic) UITableViewCellSeparatorStyle separatorStyle;
@property(nonatomic) BOOL bounces; 
@end
