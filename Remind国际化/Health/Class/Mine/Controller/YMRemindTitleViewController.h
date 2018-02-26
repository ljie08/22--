//
//  YMRemindTitleViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/27.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//  提醒类型的标题

#import "BaseViewController.h"

@protocol  YMRemindTitleViewControllerDeleagate <NSObject>

- (void)remindTitleDidEdited:(NSString *)title;

@end

@interface YMRemindTitleViewController : BaseViewController

@property (nonatomic, weak) id<YMRemindTitleViewControllerDeleagate> delegate;
@property (nonatomic, assign) BOOL showButtons;
@property (nonatomic, copy) NSString *remindTitle;

@end
