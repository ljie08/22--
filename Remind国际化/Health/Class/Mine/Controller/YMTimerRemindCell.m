//
//  YMTimerRemindCell.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/24.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMTimerRemindCell.h"

#define angle2radion(angle) ((angle) / 180.0 * M_PI)

@interface YMTimerRemindCell ()

@property (nonatomic, strong) UIView  *bgView;

@end

@implementation YMTimerRemindCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
//        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//        self.contentView.layer.cornerRadius = 30;
//        self.contentView.layer.masksToBounds = YES;
//        self.contentView.layer.borderColor = [COLOR_002 colorWithAlphaComponent:0.8].CGColor;
//        self.contentView.layer.borderWidth = 1;
//        [self lineView];
        
        [self bgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews)
    {
        if (subView.left  >= self.width - 40)
        {
            for (UIView *childView in subView.subviews)
            {
                if ([childView isKindOfClass:[UIButton class]])
                {
                    childView.superview.backgroundColor =CLEARCOLOR;
//                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:childView.bounds];
                    UIImageView *imgView = [[UIImageView alloc] initWithImage:IMGNAME(@"common_nav_btn_close_nor1")];
                    imgView.centerY = childView.centerY - 5;
                    imgView.left = 0;
                    imgView.userInteractionEnabled = YES;
                    [childView.superview addSubview:imgView];
                    [childView removeFromSuperview];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDeleteBtn)];
                    [imgView addGestureRecognizer:tap];

//                    UIButton *delBtn = (UIButton *)childView;
//                    [delBtn setBackgroundImage:IMGNAME(@"吃药") forState:UIControlStateNormal];
//                    [delBtn setBackgroundColor:COLOR_002];
//                    [delBtn setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
                    break;
                }
            }
        }
    }
}

- (void)didTapDeleteBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteCell:)]) {
        [self.delegate didDeleteCell:self];
    }
}


- (UIView *)bgView{
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 60)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bgView.layer.cornerRadius = 30;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [COLOR_002 colorWithAlphaComponent:0.8].CGColor;
        _bgView.layer.borderWidth = 1;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}


- (UIImageView *)imgView{

    if (!_imgView) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 80, 25)];
        _imgView.centerX = self.timeLabel.centerX;
        _imgView.backgroundColor =CLEARCOLOR;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;

        [self.bgView addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)timeLabel{

    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.imgView.bottom + 5,45,25)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = FONTSIZE(14);
        [self.bgView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)tLabel{
    
    if (!_tLabel) {
        
        _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.right + 10, 0,200,20)];
        _tLabel.bottom = self.imgView.bottom;
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.textColor = COLOR_002;
        _tLabel.font = FONTSIZE(16);
        [self.bgView addSubview:_tLabel];
    }
    return _tLabel;
}

- (UILabel *)durationLabel{
    
    if (!_durationLabel) {
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.right + 10 , self.timeLabel.top + 5,200,15)];
//        _durationLabel.top = self.timeLabel.top;
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = FONTSIZE(12);
        [self.bgView addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
