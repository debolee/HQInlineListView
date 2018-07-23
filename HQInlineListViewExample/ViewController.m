//
//  ViewController.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/10.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "ViewController.h"
#import "HQInlineListView.h"
#import "ListViewHeadCell.h"

@interface ViewController ()<HQInlineListViewDelegate, HQInlineListViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet HQInlineListView *listView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    HQInlineListView *listView = [[HQInlineListView alloc] initWithFrame:self.view.bounds];
    [self.listView registerNib:[UINib nibWithNibName:@"ListViewHeadCell" bundle:nil] forCellReuseIdentifier:@"ListViewHeadCell"];
    self.listView.delegate = self;
    self.listView.dataSource = self;
//    self.listView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:listView];
    
}

#pragma mark -- HQInlineListViewDataSource
- (NSInteger)numberOfSectionsInListView:(HQInlineListView *)HQInlineListView {
    return 1;
}

- (NSInteger)listView:(HQInlineListView *)listView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)listView:(HQInlineListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewHeadCell *cell = [listView dequeueReusableCellWithIdentifier:@"ListViewHeadCell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"Header View Cell %ld", indexPath.row];
    cell.contentView.backgroundColor = [UIColor grayColor];
    return cell;
}

- (NSInteger)numberOfItemsInSegementViewWithListView:(HQInlineListView *)HQInlineListView {
    return 3;
}

- (NSString *)listView:(HQInlineListView *)listView titleInSegementViewAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"TableView";
    } else if (index == 1) {
        return @"CollectionView";
    } else {
        return @"ScrollView";
    }
}

- (HQInlinePageView *)listView:(HQInlineListView *)listView pageViewInSegementViewAtIndex:(NSInteger)index {
    if (index == 0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor redColor];
        HQInlinePageView *view = [[HQInlinePageView alloc] initWithScrollView:tableView];
        view.frame = self.view.frame;
        return view;
    } else if (index == 1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        HQInlinePageView *view = [[HQInlinePageView alloc] initWithScrollView:collectionView];
        return view;
    } else {
        UIScrollView *tableView = [[UIScrollView alloc] init];
        tableView.backgroundColor = [UIColor redColor];
        HQInlinePageView *view = [[HQInlinePageView alloc] initWithScrollView:tableView];
        view.frame = self.view.frame;
        return view;
    }
    
}

#pragma mark -- HQInlineListViewDelegate
- (CGFloat)listView:(HQInlineListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (HQInlineListViewConfig *)configOfListView:(HQInlineListView *)HQInlineListView {
    HQInlineListViewConfig *config = [[HQInlineListViewConfig alloc] init];
    config.normalTitleColor = [UIColor blueColor];
    config.selectedTitleColor = [UIColor redColor];
    config.titleFont = [UIFont systemFontOfSize:17.0];
    config.scrollLineColor = [UIColor blueColor];
    config.segmentViewHeight = 50.0;
    config.segmentViewTopSpace = 120;
    config.separatorStyle = UITableViewCellSeparatorStyleNone;
    config.bounces = YES;
    return config;
}





#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"当前行：%@", @(indexPath.row)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UICollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
