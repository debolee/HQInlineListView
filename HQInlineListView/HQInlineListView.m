//
//  HQInlineListView.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "HQInlineListView.h"
#import "HQInlineMainTableView.h"
#import "HQInlineListViewSegmentContentCell.h"

@interface HQInlineListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HQInlineMainTableView *mainTableView;
@property (nonatomic, assign) NSInteger sections;
@property (nonatomic, strong) NSArray <NSString *> *segmentTitles;
@property (nonatomic, strong) NSArray <UIScrollView *> *pageViews;
@property (nonatomic, strong) HQInlineListViewConfig *config;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@end

@implementation HQInlineListView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMainTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMainTableView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMainTableView];
    }
    return self;
}

- (void)initMainTableView {
    HQInlineMainTableView *tableView = [[HQInlineMainTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"HQInlineListViewSegmentContentCell" bundle:nil] forCellReuseIdentifier:@"HQInlineListViewSegmentContentCell"];
    self.mainTableView = tableView;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HQListViewLeaveTopNotificationName object:nil];
}

- (void)setDelegate:(id<HQInlineListViewDelegate>)delegate {
    _delegate = delegate;
    self.mainTableView.bounces = self.config.bounces;
    self.mainTableView.separatorStyle = self.config.separatorStyle;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    [self.mainTableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.mainTableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [self.mainTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    [self.mainTableView reloadData];
}

- (void)reloadSegmentTitles {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sections - 1];
    HQInlineListViewSegmentContentCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    [cell reloadTitles];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.sections - 1) {
        return [self.dataSource listView:self numberOfRowsInSection:section];
    } else if (section == self.sections - 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections - 1) {
        return [self.dataSource listView:self cellForRowAtIndexPath:indexPath];
    } else {
        HQInlineListViewSegmentContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HQInlineListViewSegmentContentCell" forIndexPath:indexPath];
        cell.config = self.config;
        kWeakSelf(self);
        cell.numberOfItemsBlock = ^NSInteger{
            return [weakself.dataSource numberOfItemsInSegementViewWithListView:self];
        };
        cell.titleAtIndexBlock = ^NSString *(NSInteger index) {
            return [weakself.dataSource listView:self titleInSegementViewAtIndex:index];
        };
        cell.pageViewAtIndexBlock = ^HQInlinePageView *(NSInteger index) {
            return [weakself.dataSource listView:self pageViewInSegementViewAtIndex:index];
        };
        [cell reloadData];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections - 1) {
        return [self.delegate listView:self heightForRowAtIndexPath:indexPath];
    } else {
        return CGRectGetHeight(self.frame) - self.config.segmentViewTopSpace;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat tabOffsetY = [_mainTableView rectForSection:self.sections - 1].origin.y - self.config.segmentViewTopSpace;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:HQListViewGoTopNotificationName object:nil userInfo:@{@"canScroll":@(1)}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

- (void)handleNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if (canScroll.boolValue) {
        _canScroll = YES;
    }
}

- (HQInlineListViewConfig *)config {
    if (!_config) {
        if ([self.delegate respondsToSelector:@selector(configOfListView:)]) {
            _config = [self.delegate configOfListView:self];
        } else {
            _config = [[HQInlineListViewConfig alloc] init];
            _config.normalTitleColor = [UIColor blackColor];
            _config.selectedTitleColor = [UIColor redColor];
            _config.titleFont = [UIFont systemFontOfSize:15.0];
            _config.scrollLineColor = [UIColor blackColor];
            _config.segmentViewHeight = 50.0;
            _config.segmentViewTopSpace = 64.0;
            _config.separatorStyle = UITableViewCellSeparatorStyleNone;
            _config.bounces = YES;
        }
    }
    return _config;
}

- (NSInteger)sections {
    if (!_sections) {
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInListView:)]) {
            _sections = [self.dataSource numberOfSectionsInListView:self] + 1;
        } else {
            _sections = 2;
        };
    }
    return _sections;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
