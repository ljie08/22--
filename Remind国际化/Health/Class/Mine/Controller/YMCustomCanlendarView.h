//
//  YMCustomCanlendarView.h
//  YMCalendarView
//
//  Created by perfectbao on 17/4/2.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YMCustomCanlendarViewDelegate<NSObject>

- (void)refreshCellHeight;

@end

@interface YMCustomCanlendarView : UIView

@property (nonatomic, weak)id<YMCustomCanlendarViewDelegate> delegate;
@property (nonatomic, copy) NSString *selectDayStr;
@property (nonatomic, assign) CGFloat  viewHeight;
@property (nonatomic, copy) NSString *remindDayStr;

@end
