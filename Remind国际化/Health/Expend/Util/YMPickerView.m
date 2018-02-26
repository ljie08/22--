//
//  YMPickerView.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMPickerView.h"
#import "Tools.h"

#define Height   312

@interface YMPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, retain) UIView         *bgView;
@property (nonatomic, retain) UIView         *titleView;
@property (nonatomic, retain) UIPickerView   *userPickerView;
@property (nonatomic, strong) UILabel        *promptLabel;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) UITextField    *textField;

@end

@implementation YMPickerView

- (id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        
        [self bgView];
        [self titleView];
        [self userPickerView];
        [self promptLabel];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - setter

- (void)setDataType:(UserDataType)dataType{

    _dataType = dataType;
    
    NSString *text;
    
    switch (_dataType) {
        case UserDataTypeDate:
        {
           NSArray *oneArray = [NSArray arrayWithObjects:LOCALIZED(@"上午"),LOCALIZED(@"下午"), nil];
           NSArray *twoArray = [NSArray arrayWithArray:[self getArrayWithArrrayCount:12 increase:1 fromNum:0]];
           NSArray *threeArray = [NSArray arrayWithArray:[self getArrayWithArrrayCount:60 increase:1 fromNum:0]];
            self.dataArray = [NSArray arrayWithObjects:oneArray,twoArray,threeArray,nil];
            text = LOCALIZED(@"闹钟定时");
            self.textField.hidden = YES;
        }break;
        case UserDataTypeGender:{
            NSArray *oneArray = [NSArray arrayWithObjects:@"男",@"女", nil];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = @"性别";

        }break;
        case UserDataTypeAge:{
            NSArray *oneArray = [NSArray arrayWithArray:[self getArrayWithArrrayCount:101 increase:1 fromNum:1]];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = @"年龄";

        }break;
        case UserDataTypeSmokeAge:{
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:[self getArrayWithArrrayCount:11 increase:1 fromNum:1]];
            [mArr addObject:@"10+"];
            NSArray *oneArray = [NSArray arrayWithArray:mArr];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = @"烟龄";
            self.promptLabel.hidden = NO;
        }break;
        case UserDataTypeSmokeCount:{
        
            NSArray *oneArray = [NSArray arrayWithObjects:@"0.5",@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5",nil];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = @"一天抽几盒？";
            self.promptLabel.hidden = NO;
        }break;
        case UserDataTypeDosage:{
            NSArray *oneArray = [NSArray arrayWithObjects:LOCALIZED(@"片"),LOCALIZED(@"袋"),LOCALIZED(@"毫升"),LOCALIZED(@"克"), nil];
//            NSArray *oneArray = [NSArray arrayWithObjects:@"片",@"袋",@"毫升",@"克", nil];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = LOCALIZED(@"剂量");
            self.textField.hidden = NO;
        }break;
        case UserDataTypeCup:{
            NSArray *oneArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
            self.dataArray = [NSArray arrayWithObjects:oneArray,nil];
            text = LOCALIZED(@"容量");
        }break;
        default:
            break;
    }
    for (UIView *view in self.titleView.subviews) {
        if (view.tag == 101) {
            UILabel *label = (UILabel *)view;
            label.text = text;
        }
    }
    [self.userPickerView reloadAllComponents];

}

- (NSArray *)getArrayWithArrrayCount:(NSInteger)count increase:(CGFloat)increase fromNum:(NSInteger)num{

    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = num; i < count * increase ; i = i + increase) {
        [mArr addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return mArr;
}

#pragma mark - getter

- (UIView *)bgView{

    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, Height)];//SCREEN_HEIGHT - 267
        _bgView.backgroundColor = CLEARCOLOR;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)promptLabel{

    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _promptLabel.backgroundColor = CLEARCOLOR;
        _promptLabel.font = FONTSIZE(16);
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"*设置完成不可修改";
        [self.bgView addSubview:_promptLabel];
        _promptLabel.hidden = YES;
        
    }
    return _promptLabel;
}

- (UIView *)titleView{

    if (!_titleView) {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(25 * WIDTH_PROPORTION, 35,SCREEN_WIDTH - 50 * WIDTH_PROPORTION , 45)];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.layer.cornerRadius = 5.0;
        [self.bgView addSubview:_titleView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(15 * WIDTH_PROPORTION, 0, 40, 15);
        cancelBtn.centerY = _titleView.height/2.0;
        [cancelBtn setTitleColor:[Tools hexStringToColor:@"183b7b"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FONT_12;
        [cancelBtn setTitle:LOCALIZED(@"取消") forState:UIControlStateNormal];
        [_titleView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancelBtn.right, 0, 120, 20)];
        titleLabel.centerX = _titleView.width/2.0;
        titleLabel.centerY = _titleView.height/2.0;
        titleLabel.font = FONT(16);
        titleLabel.textColor = [Tools hexStringToColor:@"183b7b"];
//        titleLabel.text = @"闹钟定时";
        titleLabel.tag = 101;
//        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:titleLabel];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0, 0, 30, 15);
        sureBtn.centerY = _titleView.height/2.0;
        sureBtn.right = _titleView.width - 15;
        [sureBtn setTitleColor:[Tools hexStringToColor:@"183b7b"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = FONT_12;
        [sureBtn setTitle:LOCALIZED(@"确认") forState:UIControlStateNormal];
        [_titleView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(suerBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleView;
}

- (UIPickerView *)userPickerView{
    if (!_userPickerView) {
        _userPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(25 * WIDTH_PROPORTION,self.titleView.bottom + 2, SCREEN_WIDTH - 50 * WIDTH_PROPORTION, 220)];
        _userPickerView.layer.cornerRadius = 5;
        _userPickerView.delegate = self;
        _userPickerView.dataSource = self;
        _userPickerView.backgroundColor = [UIColor whiteColor];
        _userPickerView.showsSelectionIndicator = YES;
        _userPickerView.userInteractionEnabled = YES;
        [self.bgView addSubview:_userPickerView];
    }
    return _userPickerView;
}

- (UITextField *)textField{

    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, 150 * WIDTH_PROPORTION, 50)];
        _textField.centerY = self.userPickerView.centerY;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.placeholder = LOCALIZED(@"  输入剂量");
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.exclusiveTouch = YES;
        _textField.hidden = YES;
        [self.bgView addSubview:_textField];
    }
    return _textField;
}

#pragma mark - pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    if (self.dataType == UserDataTypeDosage) {
        return 2;
    }
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen{
    
    if (self.dataType == UserDataTypeDosage) {
        if (componen == 0) {
            return 1;
        }else{
            NSArray *arr = self.dataArray[0];
            return arr.count;
        }
    }
    
    NSArray *arr = self.dataArray[componen];
    return arr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (self.dataType == UserDataTypeDosage) {
        
        if (component == 0) {
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150 * WIDTH_PROPORTION, 50)];
            newView.backgroundColor = CLEARCOLOR;
            return newView;

        }else{
        
            NSArray *arr = self.dataArray[0];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - (50 + 150 + 10 + 40 + 40) * WIDTH_PROPORTION), 50)];
            label.font = FONT(16);
            label.textColor = [Tools hexStringToColor:@"183b7b"];
            label.text = arr[row];
            label.textAlignment = NSTextAlignmentCenter;
            return label;
        }
    }
    
    NSArray *arr = self.dataArray[component];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 50 * WIDTH_PROPORTION)/(CGFloat)(self.dataArray.count + 1), 50)];
    label.font = FONT(16);
    label.textColor = [Tools hexStringToColor:@"183b7b"];
    label.text = arr[row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    if (self.dataType == UserDataTypeDosage) {
        if (component == 0) {
            
            return 150 * WIDTH_PROPORTION;
            
        }else{
        
            return SCREEN_WIDTH - (50 + 150 + 10 + 40 + 40) * WIDTH_PROPORTION;
        }
    }
    return (SCREEN_WIDTH - 50 * WIDTH_PROPORTION)/(CGFloat)(self.dataArray.count + 1);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 50.f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    
}

#pragma mark - actions

- (void)endEdit{

    [self endEditing:YES];
}

- (void)cancelBtnDidClicked{

    [self hide];
}

- (void)suerBtnDidClicked{
    
    NSInteger row1 = [self.userPickerView selectedRowInComponent:0];
    
    
    NSString *content;
    if (self.dataType == UserDataTypeDate) {
        NSInteger row2 = [self.userPickerView selectedRowInComponent:1];
        NSInteger row3 = [self.userPickerView selectedRowInComponent:2];
        NSString *noon;
        if (row1 == 0) {
            noon = @"上午";
        }else{
            
            noon = @"下午";
        }
        
        NSString *row2Str;
        if (row2 < 10) {
            
            if (row2 == 0) {
                row2Str = @"12";
            }else{
                row2Str = [NSString stringWithFormat:@"0%ld",row2];

            }
        }else{
            
            row2Str = [NSString stringWithFormat:@"%ld",row2];
        }
        
        NSString *row3Str;
        if (row3 < 10) {
            
            row3Str = [NSString stringWithFormat:@"0%ld",row3];
        }else{
            
            row3Str = [NSString stringWithFormat:@"%ld",row3];
            
        }
        

       content = [NSString stringWithFormat:@"%@%@:%@",noon,row2Str,row3Str];

    }else if (self.dataType == UserDataTypeDosage){
        if (self.textField.text.length > 0) {
            NSInteger row2 = [self.userPickerView selectedRowInComponent:1];
            NSArray *array = self.dataArray[0];
            NSString *rowStr = array[row2];
            content = [NSString stringWithFormat:@"%@ %@",self.textField.text,rowStr];
        }        
    }else if (self.dataType == UserDataTypeCup){
        
        NSArray *array = self.dataArray[0];
        content = [NSString stringWithFormat:@"%@杯",array[row1]];
        
    }else {
    
        NSArray *array = self.dataArray[0];
        content = array[row1];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectedComponentInPickerViewWithcontent:)]) {
        
        [self.delegate selectedComponentInPickerViewWithcontent:content];
    }
    
    [self hide];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bgView.top = [UIScreen mainScreen].bounds.size.height - Height;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bgView.top = [UIScreen mainScreen].bounds.size.height;
                     } completion:^(BOOL finished) {
                         
                     }];
    [self removeFromSuperview];
}

- (void)reloadPickerViewWithContent:(NSString *)content{
    
    if (self.dataType == UserDataTypeDate) {
        NSString *noon = [content substringWithRange:NSMakeRange(0, 2)];
        if (![noon isEqualToString:@"上午"]) {
            [self.userPickerView selectRow:1 inComponent:0 animated:YES];
        }
        
        NSString *hour = [content substringWithRange:NSMakeRange(2, 2)];
        [self.userPickerView selectRow:[hour integerValue] inComponent:1 animated:YES];
        
        NSString *minute = [content substringWithRange:NSMakeRange(5, 2)];
        [self.userPickerView selectRow:[minute integerValue] inComponent:2 animated:YES];
    }else if(self.dataType == UserDataTypeGender){
    
        if ([content isEqualToString:@"女"]) {
            [self.userPickerView selectRow:1 inComponent:0 animated:YES];
        }
    }else if(self.dataType == UserDataTypeAge){
    
        [self.userPickerView selectRow:[content integerValue] - 1 inComponent:0 animated:YES];

    }else if(self.dataType == UserDataTypeSmokeAge){
    
        if (![content hasSuffix:@"+"]) {
            
            [self.userPickerView selectRow:[content integerValue] - 1 inComponent:0 animated:YES];

        }else{
        
            NSArray *arr = self.dataArray[0];
            [self.userPickerView selectRow:arr.count - 1 inComponent:0 animated:YES];

        }
        
    }else if(self.dataType == UserDataTypeSmokeCount){
    
        [self.userPickerView selectRow:[content floatValue] - 1 inComponent:0 animated:YES];

    }else{//剂量
    
        NSArray *cArr = [content componentsSeparatedByString:@" "];
        self.textField.text = cArr[0];
        
        NSArray *arr = self.dataArray[0];
        if ([arr indexOfObject:cArr[1]] != NSNotFound) {
            
            [self.userPickerView selectRow:[arr indexOfObject:cArr[1]] inComponent:1 animated:YES];

        }
        
        
    }
}


@end
