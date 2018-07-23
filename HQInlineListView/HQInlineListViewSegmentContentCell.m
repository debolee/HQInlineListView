//
//  HQInlineListViewSegmentContentCell.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "HQInlineListViewSegmentContentCell.h"
#import "HQInlineListViewSegmentTitleCell.h"
#import "HQInlineListViewPageCell.h"
#import "HQInlinePageView.h"
@interface HQInlineListViewSegmentContentCell()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UICollectionView *segmentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *pageCollectionView;
@property (assign, nonatomic) NSInteger numberOfItems;
@property (weak, nonatomic) IBOutlet UIView *scrollIndicateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollIndicateViewLeadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollIndicateViewWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewHeightLayout;

@end

@implementation HQInlineListViewSegmentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.segmentCollectionView registerNib:[UINib nibWithNibName:@"HQInlineListViewSegmentTitleCell" bundle:nil] forCellWithReuseIdentifier:@"HQInlineListViewSegmentTitleCell"];
    self.segmentCollectionView.delegate = self;
    self.segmentCollectionView.dataSource = self;
    self.segmentCollectionView.bounces = NO;
    
    [self.pageCollectionView registerNib:[UINib nibWithNibName:@"HQInlineListViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"HQInlineListViewPageCell"];
    self.pageCollectionView.delegate = self;
    self.pageCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
    
    CGFloat titleWith = MAX(CGRectGetWidth(self.bounds) / self.numberOfItems, 40.0);
    CGFloat scrollIndicateViewWith = 70;
    if (titleWith <= scrollIndicateViewWith) {
        scrollIndicateViewWith = titleWith - 20;
    }
    self.scrollIndicateViewWidthLayout.constant = scrollIndicateViewWith;
    self.scrollIndicateViewLeadingLayout.constant = titleWith / 2 - scrollIndicateViewWith / 2 +
    self.pageCollectionView.contentOffset.x * (titleWith / self.pageCollectionView.bounds.size.width);
}

- (void)reloadData {
    self.scrollIndicateView.backgroundColor = self.config.scrollLineColor;
    self.segmentViewHeightLayout.constant = self.config.segmentViewHeight;
    [self.segmentCollectionView reloadData];
    [self.pageCollectionView reloadData];
}

- (void)reloadTitles {
    [self.segmentCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.segmentCollectionView) {
        HQInlineListViewSegmentTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQInlineListViewSegmentTitleCell" forIndexPath:indexPath];
        NSString *title = self.titleAtIndexBlock(indexPath.row);
        [cell.titleButton setTitle:title forState:UIControlStateNormal];
        [cell.titleButton setTitleColor:self.config.normalTitleColor forState:UIControlStateNormal];
        [cell.titleButton setTitleColor:self.config.selectedTitleColor forState:UIControlStateSelected];
        cell.titleButton.titleLabel.font = self.config.titleFont;
        kWeakSelf(self);
        cell.titleButtonActionBlock = ^(UIButton *sender) {
            [weakself.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        };
        return cell;
    } else {
        HQInlineListViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQInlineListViewPageCell" forIndexPath:indexPath];
        HQInlinePageView *view = self.pageViewAtIndexBlock(indexPath.row);
        cell.pageView = view;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.segmentCollectionView) {
        CGFloat width = MAX(CGRectGetWidth(self.bounds) / self.numberOfItems, 40.0);
        return CGSizeMake(width, CGRectGetHeight(self.segmentView.bounds));
    } else {
        return collectionView.bounds.size;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat titleWith = MAX(CGRectGetWidth(self.bounds) / self.numberOfItems, 40.0);
    CGFloat scrollIndicateViewWith = self.scrollIndicateView.frame.size.width;
    if (scrollView == self.pageCollectionView) {
        self.scrollIndicateViewLeadingLayout.constant = titleWith / 2 - scrollIndicateViewWith / 2 + contentOffset.x * titleWith / self.pageCollectionView.bounds.size.width;
    } else if (scrollView == self.segmentCollectionView) {
//        self.scrollIndicateViewLeadingLayout.constant = titleWith / 2 - scrollIndicateViewWith / 2 + contentOffset.x;
    }
}

- (NSInteger)numberOfItems {
    if (!_numberOfItems) {
        _numberOfItems = self.numberOfItemsBlock();
    }
    return _numberOfItems;
}

@end
