//
//  YMClockCell.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMClockCell.h"

#define LeftSpace  25
#define CellHeight 50

@interface YMClockCell()

//@property (nonatomic, strong) UIImageView *rightImgView;

@end

@implementation YMClockCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
        [self.contentView addSubview:bgView];
        
//        [self lineView];
    }
    return self;
}

- (void)setRightImgName:(NSString *)rightImgName{

    _rightImgName = rightImgName;
    _rightImgView = [[UIImageView alloc] initWithImage:IMGNAME(_rightImgName)];
    _rightImgView.origin = CGPointMake(0, 0);
    _rightImgView.centerY = CellHeight/2.0;
    _rightImgView.right = SCREEN_WIDTH - LeftSpace;
    [self.contentView addSubview:_rightImgView];
    
    self.cLabel.right = _rightImgView.left - 4;
    
}

- (UILabel *)tlabel{

    if (!_tlabel) {
        
        _tlabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftSpace,0, 70, CellHeight)];
        _tlabel.centerY = CellHeight/2.0;
        _tlabel.backgroundColor = CLEARCOLOR;
        _tlabel.font = FONT(16);
        _tlabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_tlabel];
    }
    return _tlabel;
}

- (UILabel *)cLabel{
    
    if (!_cLabel) {
        
        _cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 260, CellHeight)];
        _cLabel.right = SCREEN_WIDTH - 25 ;
        _cLabel.centerY = CellHeight/2.0;
        _cLabel.backgroundColor = CLEARCOLOR;
        _cLabel.font = FONT(16);
        _cLabel.textColor = COLOR_002;
        _cLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_cLabel];
    }
    return _cLabel;
}

- (UISwitch *)switchView{

    if (!_switchView) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _switchView.right = SCREEN_WIDTH - LeftSpace;
        _switchView.centerY = CellHeight/2.0;
        _switchView.onTintColor = RGB(90, 200, 150);
        [self.contentView addSubview:_switchView];
    }
    return _switchView;
}

- (UIView *)lineView{

    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(LeftSpace, CellHeight - 1, SCREEN_WIDTH - 2 *LeftSpace, 1)];
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
