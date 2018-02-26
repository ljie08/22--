//
//  YMTimerRemindCell.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/24.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMTimerRemindCell;
@protocol  YMTimerRemindCellDelegate<NSObject>

- (void)didDeleteCell:(YMTimerRemindCell *)cell;

@end

@interface YMTimerRemindCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *tLabel;//标题
@property (nonatomic, strong) UILabel *durationLabel;//距离提醒的时间
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<YMTimerRemindCellDelegate> delegate;

@end
