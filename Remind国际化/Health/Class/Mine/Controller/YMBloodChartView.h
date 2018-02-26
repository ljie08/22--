//
//  YMBloodChartView.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/30.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YMBloodChartViewDelegate<NSObject>
//滑动tableview
- (void)refreshCellWithTimeDidChange;

@end

@interface YMBloodChartView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<YMBloodChartViewDelegate> delegate;

@end
