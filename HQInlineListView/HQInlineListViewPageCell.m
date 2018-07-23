//
//  HQInlineListViewPageCell.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "HQInlineListViewPageCell.h"

@implementation HQInlineListViewPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPageView:(UIView *)pageView {
    if (_pageView != pageView) {
        [_pageView removeFromSuperview];
        pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        pageView.frame = self.bounds;
        [self addSubview:pageView];
        _pageView = pageView;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

@end
