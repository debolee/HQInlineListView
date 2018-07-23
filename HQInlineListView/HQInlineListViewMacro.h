//
//  HQInlineListViewMacro.h
//  HQInlineListViewExample
//
//  Created by lidebo on 2018/5/11.
//  Copyright © 2018年 HQInlineListView. All rights reserved.
//

#ifndef HQInlineListViewMacro_h
#define HQInlineListViewMacro_h

static NSString *const HQListViewGoTopNotificationName = @"GoTopNotificationName";//进入置顶命令
static NSString *const HQListViewLeaveTopNotificationName = @"LeaveTopNotificationName ";//离开置顶命令

//弱引用/强引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


#endif /* HQInlineListViewMacro_h */
