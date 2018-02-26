//
//  RemindOptionView.h
//  Health
//
//  Created by 魔曦 on 2017/8/16.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  RemindOptionViewDelegate<NSObject>

- (void)didSelectecRemindType:(NSInteger)remindType;

@end

@interface RemindOptionView : UIView

@property (nonatomic, weak)id<RemindOptionViewDelegate> delegate;

- (void)showWithAnimate:(BOOL)animate;
- (void)hideWithAnimate:(BOOL)animate;

@end
