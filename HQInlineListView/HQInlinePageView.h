//
//  HQInlinePageView.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/11.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HQInlineListViewMacro.h"

@interface HQInlinePageView : UIView
- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView;
- (instancetype)initWithWebView:(WKWebView *)webView;
@end
