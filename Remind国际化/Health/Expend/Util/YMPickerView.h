//
//  YMPickerView.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMPickerViewDelegate <NSObject>

- (void)selectedComponentInPickerViewWithcontent:(NSString *)content;

@end

@interface YMPickerView : UIView

@property (nonatomic, assign) id<YMPickerViewDelegate>  delegate;
@property (nonatomic, assign) UserDataType   dataType;

- (void)show;
- (void)hide;
- (void)reloadPickerViewWithContent:(NSString *)content;


@end
