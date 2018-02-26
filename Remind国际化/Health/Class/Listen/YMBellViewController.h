//
//  YMBellViewController.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//铃声

#import "BaseTableViewController.h"

@protocol  YMBellViewControllerDelegate<NSObject>

- (void)didSelectBellName:(NSString *)bellName;

@end

@interface YMBellViewController : BaseTableViewController

@property (nonatomic, weak)id<YMBellViewControllerDelegate> delegate;
@property (nonatomic, copy)NSString *bellStr;

@end
