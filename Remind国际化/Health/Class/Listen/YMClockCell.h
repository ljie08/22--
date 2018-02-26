//
//  YMClockCell.h
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMClockCell : UITableViewCell

@property (nonatomic, strong) UILabel *tlabel;//标题
@property (nonatomic, strong) UILabel *cLabel;//内容
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, copy)   NSString *rightImgName;


@end
