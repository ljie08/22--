//
//  YMBellCell.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMBellCell.h"
#import "Tools.h"

#define LeftSpace  25
#define CellHeight 50

@interface YMBellCell()

@property (nonatomic, strong) UILabel *tlabel;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIView  *lineView;

@end

@implementation YMBellCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        
        [self tlabel];
        [self rightImgView];
        [self lineView];
    }
    return self;
}

- (void)setText:(NSString *)text{

    _text = text;
    self.tlabel.text = text;
}

- (void)setIsPlaying:(BOOL)isPlaying{

    _isPlaying = isPlaying;
    self.rightImgView.hidden = !isPlaying;
}

- (UILabel *)tlabel{
    
    if (!_tlabel) {
        
        _tlabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftSpace,0, 70, CellHeight)];
        _tlabel.centerY = CellHeight/2.0;
        _tlabel.backgroundColor = CLEARCOLOR;
        _tlabel.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _tlabel.textColor = COLOR_002;//[Tools hexStringToColor:@"183b7b"];
//        _tlabel.alpha = 0.6;
        [self.contentView addSubview:_tlabel];
    }
    return _tlabel;
}

- (UIImageView *)rightImgView{

    if (!_rightImgView) {
        
        _rightImgView = [[UIImageView alloc] initWithImage:IMGNAME(@"ok")];//选中闹钟铃声
        _rightImgView.origin = CGPointMake(0, 0);
        _rightImgView.centerY = CellHeight/2.0;
        _rightImgView.right = SCREEN_WIDTH - LeftSpace;
        _rightImgView.backgroundColor = CLEARCOLOR;
        _rightImgView.hidden = YES;
        [self.contentView addSubview:_rightImgView];

    }
    return _rightImgView;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CellHeight - 1, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.1;
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
