//
//  HQInlineListViewSegmentTitleCell.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQInlineListViewSegmentTitleCell : UICollectionViewCell
@property (nonatomic, copy) void(^titleButtonActionBlock)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end
