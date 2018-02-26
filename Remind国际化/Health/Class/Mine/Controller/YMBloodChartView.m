//
//  YMBloodChartView.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/30.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#define S_WIDTH  self.frame.size.width
#define S_HEIGHT self.frame.size.height
#define L_WIDTH  0.5

#import "YMBloodChartView.h"
#import "YMPickerView.h"
#import "YMClockManager.h"

@interface YMBloodChartView()<YMPickerViewDelegate>

@property (nonatomic, strong) YMPickerView *pickerView;
@property (nonatomic, assign) CGFloat wSpace;
@property (nonatomic, assign) CGFloat hSpace;
@property (nonatomic, assign) NSInteger selectLabelTag;

@end

@implementation YMBloodChartView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.wSpace = S_WIDTH/9.0;
        self.hSpace = (S_HEIGHT - 70)/8.0;
        [self drawChart];
        self.dataArray = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"星\n期"),LOCALIZED(@"凌\n晨"),@[LOCALIZED(@"早餐"),LOCALIZED(@"前"),LOCALIZED(@"后")],@[LOCALIZED(@"午餐"),LOCALIZED(@"前"),LOCALIZED(@"后")],@[LOCALIZED(@"晚餐"),LOCALIZED(@"前"),LOCALIZED(@"后")],LOCALIZED(@"睡\n前")],@[@"1"],@[@"2"],@[@"3"],@[@"4"],@[@"5"],@[@"6"],@[@"7"],@[LOCALIZED(@"测量\n时间"),@"03:00",@"06:30",@"09:00",@"11:30",@"14:00",@"17:30",@"20:00",@"22:00"],nil];

//        self.dataArray = [NSMutableArray arrayWithObjects:@[@"星\n期",@"凌\n晨",@[@"早餐",@"前",@"后"],@[@"午餐",@"前",@"后"],@[@"晚餐",@"前",@"后"],@"睡\n前"],@[@"1"],@[@"2"],@[@"3"],@[@"4"],@[@"5"],@[@"6"],@[@"7"],@[@"测量\n时间",@"03:00",@"06:30",@"09:00",@"11:30",@"14:00",@"17:30",@"20:00",@"22:00"],nil];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{

    _dataArray = dataArray;

    [self drawText];
    
    NSMutableArray *measureTimeArray  = _dataArray[8];
    for (NSInteger row = 1; row < _dataArray.count - 1; row ++) {
        NSMutableArray *rowArr = _dataArray[row];
        
        for (NSInteger index = 1; index < rowArr.count; index++) {
            NSString *tStr = rowArr[index];
            for (NSInteger i = 1; i< measureTimeArray.count ; i++) {
                NSString *timeStr = measureTimeArray[i];
                if ([timeStr isEqualToString:tStr]) {
                    
                    [rowArr replaceObjectAtIndex:index withObject:@(row * 100 + i)];
                    break;
                }
            }
        }
        
        
        [self.dataArray replaceObjectAtIndex:row withObject:rowArr];
    }

}

- (void)drawChart{//9列 10排
    
    CGFloat space = 35 ;
    
    for (NSInteger i=0; i<9;i++) {//水平
        CGRect hFrame = CGRectMake(0, 0, S_WIDTH, L_WIDTH);//水平
        if (i == 0) {
            hFrame.origin.x = self.wSpace * 2;
            hFrame.size.width = S_WIDTH - self.wSpace * 3;
        }
        
        if (i == 0 || i ==1) {
            hFrame.origin.y = space  * (i + 1);
        }else{
            hFrame.origin.y = space * 2 + self.hSpace *(i -1);
        }
        
        CALayer  *hLayer = [CALayer layer];
        hLayer.frame = hFrame;
        hLayer.backgroundColor = [UIColor clearColor].CGColor;
        hLayer.borderWidth = 1.0;
        hLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
        [self.layer addSublayer:hLayer];
    }
    
    for (NSInteger i=0; i< 8; i++) {//竖直
        CGRect vFrame = CGRectMake(self.wSpace * (i + 1), 0, L_WIDTH,S_HEIGHT);//竖直
        if (i == 2 || i == 4 || i == 6 ) {
            vFrame.origin.y = space;
            vFrame.size.height = S_HEIGHT - space;
        }
        CALayer  *vLayer = [CALayer layer];
        vLayer.frame = vFrame;
        vLayer.backgroundColor = [UIColor clearColor].CGColor;
        vLayer.borderWidth = 1.0;
        vLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
        [self.layer addSublayer:vLayer];
//        vFrame.origin.x = self.wSpace*(i+1);
    }
    
}

- (void)drawText{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (NSInteger row = 0; row < 9; row ++) {//水平
        for (NSInteger column = 0; column < 9; column ++) {
            
            NSArray *arr = self.dataArray[row];
            NSString *text;
            NSArray  *alist;
            if (row == 0 && (column >= 2 && column < 8)) {
                if (column /2) {
                    alist = arr[(column/2)+1];
                }
                
            }else{
                if (row == 0 && column == 8) {
                    text = arr[5];
                }else if (column < arr.count ) {
                    text = arr[column];
                }
            }
            
            
            CGRect frame = CGRectMake(self.wSpace * column + L_WIDTH,self.hSpace * (row - 1) + 70 + L_WIDTH, self.wSpace - L_WIDTH, self.hSpace - L_WIDTH);
            if (row == 0) {
                frame.origin.y=0;
                frame.size.height = 70;
                
                if (row == 0 && (column >= 2 && column < 8)) {
                    CGFloat height = 35 ;
                    frame.size.width = frame.size.width - L_WIDTH;
                    if (column % 2 == 0) {
                        frame.origin.x = self.wSpace * column + L_WIDTH;
                        frame.size.width = self.wSpace * 2 - L_WIDTH;
                        UIView *bgView = [[UIView alloc] initWithFrame:frame];
                        bgView.backgroundColor = CLEARCOLOR;
                        [self addSubview:bgView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.wSpace * 2 - L_WIDTH, height)];
                        label.font = [UIFont systemFontOfSize:14];
                        label.textColor = [UIColor whiteColor];
                        label.backgroundColor =[[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.text = alist[0];
                        [bgView addSubview:label];
                        
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,height + L_WIDTH, self.wSpace - L_WIDTH, height - L_WIDTH)];
                        label1.font = [UIFont systemFontOfSize:14];
                        label1.textColor = [UIColor whiteColor];
                        label1.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];
                        label1.textAlignment = NSTextAlignmentCenter;
                        label1.text = alist[1];
                        [bgView addSubview:label1];
                        
                        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.wSpace,height + L_WIDTH , self.wSpace - L_WIDTH, height - L_WIDTH)];
                        label2.font = [UIFont systemFontOfSize:14];
                        label2.textColor = [UIColor whiteColor];
                        label2.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];
                        label2.textAlignment = NSTextAlignmentCenter;
                        label2.text = alist[2];
                        [bgView addSubview:label2];
                        
                    }
                    continue;
                }
            }
           
            if (row == 0 || (row >= 1 && column == 0) || row == 8) {
                
                if (column == 0) {
                    frame.origin.x = 0;
                    frame.size.width = self.wSpace;
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:frame];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];
                label.numberOfLines = 2;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = text;
                label.userInteractionEnabled = YES;
                [self addSubview:label];
                if (row == 8 && column > 0) {
                    if (IS_IPHONE_4S_5) {
                        label.font = [UIFont systemFontOfSize:12];
                    }
                    label.tag = 100 * row + column;
                    label.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];//[UIColor colorWithWhite:0 alpha:0.02];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeLabelDidSelect:)];
                    [label addGestureRecognizer:tap];

                }
            }else{
            
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
                imgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
                imgView.userInteractionEnabled = YES;
                imgView.tag = 100 * row + column;
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewDidSelected:)];
                [imgView addGestureRecognizer:tap];
                [self addSubview:imgView];
                NSArray *measureTimeArr = self.dataArray[8];
                
                for (NSString *text in arr) {
                    if (text.length > 0) {
                        for (NSInteger i = 1; i < measureTimeArr.count; i++) {
                            if ([text isEqualToString:measureTimeArr[i]]) {
                                
                                NSInteger tag = 100 * row + i;
                                if (imgView.tag == tag) {
                                    imgView.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.3];
                                    imgView.image = IMGNAME(@"blood_clock");
                                }
                                break;
                            }
                        }
                    }
                }
            
                
            }
                        
        }
        
        
    }
    
}

- (void)imgViewDidSelected:(UITapGestureRecognizer *)tap{

    NSInteger tag = tap.view.tag;
    NSInteger row = tag / 100;
//    NSInteger column = tag %100;
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataArray[row]];
    if (mArr.count > 0) {
        if ([mArr indexOfObject:@(tag)] == NSNotFound) {
            [mArr addObject:@(tag)];
            UIImageView *imgView = (UIImageView *)tap.view;
            imgView.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.3];
            imgView.image = IMGNAME(@"blood_clock");
        }else{
            [mArr removeObject:@(tag)];
            UIImageView *imgView = (UIImageView *)tap.view;
            imgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
            imgView.image = [UIImage new];
        }
        if (mArr.count > 0) {
            [self.dataArray replaceObjectAtIndex:row withObject:mArr];
        }else{
        
            [self.dataArray removeObject:mArr];
        }
        
    }else{
    
        [mArr addObject:@(tag)];
        [self.dataArray replaceObjectAtIndex:row withObject:mArr];
        UIImageView *imgView = (UIImageView *)tap.view;
        imgView.backgroundColor = [[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.3];
        imgView.image = IMGNAME(@"blood_clock");

    }
}

- (void)timeLabelDidSelect:(UITapGestureRecognizer *)tap{
    
    self.selectLabelTag = tap.view.tag;
    UILabel *label = (UILabel *)[self viewWithTag:self.selectLabelTag];
    
    self.pickerView.dataType = UserDataTypeDate;
    [self.pickerView show];
    [self.pickerView reloadPickerViewWithContent:[[YMClockManager shareManager] getTimeWith24HourTimeStr:label.text]];
    
}

- (YMPickerView *)pickerView{
    
    if (!_pickerView) {
        
        _pickerView = [[YMPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - pickerViewDelegate

- (void)selectedComponentInPickerViewWithcontent:(NSString *)content{

    if (content.length > 0) {

        UILabel *label = (UILabel *)[self viewWithTag:self.selectLabelTag];
        label.text = @"";
        label.text = [[YMClockManager shareManager] getTimeWith12HourTimeStr:content];
        
        NSInteger row = self.selectLabelTag / 100;
        NSInteger column = self.selectLabelTag %100;
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataArray[row]];
        [mArr replaceObjectAtIndex:column withObject:label.text];
        [self.dataArray replaceObjectAtIndex:row withObject:mArr];
        
    }
    
}

- (NSString *)getTimeStrWithPickerContent:(NSString *)content{

    NSMutableString  *mStr = [NSMutableString string];
    
    if ([content hasPrefix:LOCALIZED(@"上午")]) {
        [mStr appendString:[content substringFromIndex:2]];
    }else{
        NSString *str = [content substringFromIndex:2];
        NSArray *arr = [str componentsSeparatedByString:@":"];
        NSInteger hour = [arr[0] integerValue] + 12;
        [mStr appendFormat:@"%ld:",hour];
        [mStr appendString:arr[1]];
        
    }
    
    return mStr;
    
}

- (NSString *)getPickerTimeStrWithLabelText:(NSString *)timeStr{

    NSMutableString  *mStr = [NSMutableString string];
    NSArray *arr = [timeStr componentsSeparatedByString:@":"];
    if ([arr[0] integerValue] < 12) {
        [mStr appendString:LOCALIZED(@"上午")];
        [mStr appendString:timeStr];
    }else{
        [mStr appendString:LOCALIZED(@"下午")];
        if ([arr[0] integerValue ]- 12 < 10) {
            [mStr appendFormat:@"0%ld:",[arr[0] integerValue] - 12];

        }else{
            [mStr appendFormat:@"%ld:",[arr[0] integerValue] - 12];
        }
        
        [mStr appendString:arr[1]];
    }
    
    return mStr;
}


@end















