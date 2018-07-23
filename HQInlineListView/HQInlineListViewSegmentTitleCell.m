//
//  HQInlineListViewSegmentTitleCell.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "HQInlineListViewSegmentTitleCell.h"

@implementation HQInlineListViewSegmentTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)titleButtonAction:(UIButton *)sender {
    if (self.titleButtonActionBlock) {
        self.titleButtonActionBlock(sender);
    }
}

@end
