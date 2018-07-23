//
//  HQInlinePageView.m
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/11.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import "HQInlinePageView.h"

@interface HQInlinePageView()
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) __kindof UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HQInlinePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        scrollView.frame = self.frame;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:scrollView];
        self.canScroll = YES;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HQListViewGoTopNotificationName object:nil];
        //其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HQListViewLeaveTopNotificationName object:nil];
    }
    return self;
}

- (instancetype)initWithWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        webView = webView;
        webView.frame = self.frame;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:webView];
        self.canScroll = YES;
        [webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HQListViewGoTopNotificationName object:nil];
        //其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HQListViewLeaveTopNotificationName object:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.webView) {
            if (!self.canScroll && self.webView.scrollView.contentOffset.y != 0) {
                [self.webView.scrollView setContentOffset:CGPointZero];
            }
            CGFloat offsetY = self.webView.scrollView.contentOffset.y;
            if (offsetY<0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HQListViewLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@(YES)}];
            }
            
        } else if (self.scrollView) {
            if (!self.canScroll && self.scrollView.contentOffset.y != 0) {
                [self.scrollView setContentOffset:CGPointZero];
            }
            CGFloat offsetY = self.scrollView.contentOffset.y;
            if (offsetY<0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HQListViewLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@(YES)}];
            }
        }
        
    }
}

- (void)handleNotification:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:HQListViewGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *canScroll = userInfo[@"canScroll"];
        if (canScroll.boolValue) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
            self.webView.scrollView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:HQListViewLeaveTopNotificationName]){
        self.scrollView.contentOffset = CGPointZero;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
