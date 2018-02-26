//
//  RemindCell.m
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "RemindCell.h"

@interface RemindCell()

@property(nonatomic, strong) UILabel     *tLabel;
@property(nonatomic, strong) UILabel     *desLabel;

@end

@implementation RemindCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [COLOR_000 colorWithAlphaComponent:0.5];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self tLabel];
        [self desLabel];
    }
    return self;
}

//- (void)setContent:(PDLookListMode *)content{
//    _content = content;
//    
//    CGFloat width = [content.kanTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]}].width;
//    self.tLabel.width = width;
//    self.markImgView.left = self.tLabel.right + 2;
//    self.tLabel.text = content.kanTitle;
//    self.desLabel.text = content.kanDesc;
//    [self.imgView setImgWithURL:[NSURL URLWithString:content.filePath] WithPlaceImage:nil];
//    
//    if (content.ishot) {
//        self.markImgView.image = IMGNAME(@"HOT");
//        
//    }else if (content.isnew){
//        self.markImgView.image = IMGNAME(@"NEW");
//    }
//}

- (UILabel *)tLabel{
    if (!_tLabel) {
        _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.contentView.width, 30 * HEIGHT_PROPORTION)];
        _tLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _tLabel.font = [UIFont boldSystemFontOfSize:14];
        _tLabel.textColor = COLOR_002;
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.text = @"09:00";
        //        _tLabel.text = text;
        [self.contentView addSubview:_tLabel];
    }
    return _tLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.tLabel.bottom, self.width - 10 , 60 )];
        
        _desLabel.backgroundColor = CLEARCOLOR;
        _desLabel.font = FONTSIZE(16);
        _desLabel.textColor = COLOR_002;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.text = @"喝水";
        //        _desLabel.numberOfLines = 0;
        //        _desLabel.text = @"利用跑步换气的方式在入睡前做一次全身放松";
        [self.contentView addSubview:_desLabel];
    }
    return _desLabel;
}

@end
