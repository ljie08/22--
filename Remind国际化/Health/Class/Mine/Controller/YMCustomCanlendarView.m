//
//  YMCustomCanlendarView.m
//  YMCalendarView
//
//  Created by perfectbao on 17/4/2.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMCustomCanlendarView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define S_WIDTH  self.frame.size.width
#define S_HEIGHT self.frame.size.height
#define L_WIDTH  0.5
#define TOP_HEIGHT  25


@interface YMCustomCanlendarView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) NSArray   *weekArray;
@property (nonatomic, strong) NSMutableArray   *daysArray;
@property (nonatomic, strong) NSDateComponents *nowDate;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate     *lastMonthDate;
@property (nonatomic, strong) NSDate     *NowMonthFirst;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy)   NSString *cellId;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *daysLabel;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, assign) NSInteger  selectDay;

@end

@implementation YMCustomCanlendarView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = CLEARCOLOR;//[[Tools hexStringToColor:@"18387b"] colorWithAlphaComponent:0.5];
        
        _cellId = @"cellID";
        [self initDataSource];
        
        NSInteger row = _daysArray.count % 7 > 0 ? (_daysArray.count / 7) + 1 :  _daysArray.count / 7;
        
        _viewHeight = TOP_HEIGHT + 32 + 43 * row;
        
        [self drawLayers];
        [self topView];
        [self collectionView];
    }
    return self;
}

- (void)setRemindDayStr:(NSString *)remindDayStr{

    _remindDayStr = remindDayStr;
    NSArray *tArr = [_remindDayStr componentsSeparatedByString:@"-"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *sDate  = [dateFormatter dateFromString:_remindDayStr];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *sComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:sDate];
    if ([tArr[0] integerValue] == _year &&[tArr[1] integerValue] == _month) {
        
        if (sComponents.day != _day) {
            
            for (NSInteger index =7; index < _daysArray.count - 7; index ++) {
                
                if ([_daysArray[index] integerValue] == [tArr[2] integerValue]) {
//                    if (self.selectIndexPath) {
//                        
//                        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
//                        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100 * self.selectIndexPath.section + self.selectIndexPath.row];
//                        label.textColor = [UIColor whiteColor];
//                        cell.selected = nil;
//                    }
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
//                    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
//                    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100 * indexPath.section + indexPath.row];
//                    label.textColor = [UIColor blackColor];
//                    cell.selected = YES;
                    self.selectIndexPath =[NSIndexPath indexPathForRow:index inSection:1];
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                }
            }
        }
    }
    
}

- (void)drawLayers{
    
    for (NSInteger i=0; i<(_daysArray.count/7);i++) {//水平
        CGRect hFrame = CGRectMake(0,60 + 43 *i, S_WIDTH, L_WIDTH);//水平
        CALayer  *hLayer = [CALayer layer];
        hLayer.frame = hFrame;
        hLayer.backgroundColor = [UIColor clearColor].CGColor;
        hLayer.borderWidth = L_WIDTH;
        hLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
        [self.layer addSublayer:hLayer];
    }
}

- (UIView *)topView{

    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, S_WIDTH, TOP_HEIGHT)];
        _topView.backgroundColor = [UIColor clearColor];
        [self addSubview:_topView];
        
        _daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,10, 80, 15)];
        _daysLabel.centerX = S_WIDTH/2.0;
        _daysLabel.backgroundColor = [UIColor clearColor];
        _daysLabel.textColor = [UIColor whiteColor];
        _daysLabel.font = [UIFont systemFontOfSize:14];
        _daysLabel.textAlignment = NSTextAlignmentCenter;
        _daysLabel.text = [NSString stringWithFormat:@"%ld%@%ld%@",_year,LOCALIZED(@"年"),_month,LOCALIZED(@"月")];
        [_topView addSubview:_daysLabel];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(50, 10, 20, 15);
        leftBtn.right =  _daysLabel.left - 5;
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn setImage:IMGNAME(@"lastMonth") forState:UIControlStateNormal];
        [leftBtn setImage:IMGNAME(@"lastMonth") forState:UIControlStateSelected];
        [_topView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(leftBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(250, 10, 20, 15);
        rightBtn.left = _daysLabel.right + 5;
        rightBtn.backgroundColor = [UIColor clearColor];
        [rightBtn setImage:IMGNAME(@"nextMonth") forState:UIControlStateNormal];
        [rightBtn setImage:IMGNAME(@"nextMonth") forState:UIControlStateSelected];
        [_topView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _topView;
}

- (void)leftBtnDidClicked:(UIButton *)btn{
    [_daysArray removeAllObjects];
    if (_month == 1) {
        _month = 12;
        _year --;
    }else{
        
        _month --;
    }
    _daysLabel.text = [NSString stringWithFormat:@"%ld年%ld月",_year,_month];
    [self setDayArrayWithYear:_year AndMonth:_month AndDay:_day];
    [self.collectionView reloadData];
    NSInteger row = _daysArray.count % 7 > 0 ? (_daysArray.count / 7) + 1 :  _daysArray.count / 7;
    _viewHeight = TOP_HEIGHT + 32 + 43 * row;
//    [self.collectionView reloadData];

    if ([self.delegate respondsToSelector:@selector(refreshCellHeight)]) {
        [self.delegate refreshCellHeight];
    }
}

- (void)rightBtnDidClicked:(UIButton *)btn{
    [_daysArray removeAllObjects];
    
    if (_month == 12) {
        _month = 1;
        _year ++;
    }else{
        
        _month ++;
    }
    _daysLabel.text = [NSString stringWithFormat:@"%ld年%ld月",_year,(long)_month];
    [self setDayArrayWithYear:_year AndMonth:_month AndDay:_day];
    
    [self.collectionView reloadData];

    
    NSInteger row = _daysArray.count % 7 > 0 ? (_daysArray.count / 7) + 1 :  _daysArray.count / 7;
    
    _viewHeight = TOP_HEIGHT + 32 + 43 * row;
    

    if ([self.delegate respondsToSelector:@selector(refreshCellHeight)]) {
        [self.delegate refreshCellHeight];
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置对齐方式
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //cell间距
        layout.minimumInteritemSpacing = 5.0f;
        //cell行距
        layout.minimumLineSpacing = 1.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,25, S_WIDTH - 30,_viewHeight - TOP_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellId];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)initDataSource{

    _weekArray = [NSArray arrayWithObjects:LOCALIZED(@"日"),LOCALIZED(@"一"),LOCALIZED(@"二"),LOCALIZED(@"三"),LOCALIZED(@"四"),LOCALIZED(@"五"),LOCALIZED(@"六"), nil];

//    _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    _daysArray = [[NSMutableArray alloc] init];
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _nowDate = [[NSDateComponents alloc] init];
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    _nowDate = components;
    _year = _nowDate.year;
    _month = _nowDate.month;
    _day = _nowDate.day;
    NSString *d,*m;
    if (_nowDate.day < 10) {
        d = [NSString stringWithFormat:@"0%ld",(long)_nowDate.day];
    }else{
        d = [NSString stringWithFormat:@"%ld",(long)_nowDate.day];
    }
    if (_nowDate.month < 10) {
        m = [NSString stringWithFormat:@"0%ld",(long)_nowDate.month];
    }else{
        m = [NSString stringWithFormat:@"%ld",(long)_nowDate.month];
    }
    self.selectDayStr = [NSString stringWithFormat:@"%ld-%@-%@",(long)_year,m,d];
    [self setDayArrayWithYear:_year AndMonth:_month AndDay:_day];
}

- (void)setDayArrayWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day]];
    
    NSRange dayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    NSRange lastdayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self setLastMonthWithYear:year AndMonth:month AndDay:day]];
    
    _NowMonthFirst = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",year,month,1]];
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:_NowMonthFirst];
    
    NSDate *nextDay = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,dayRange.length]];
    NSDateComponents *lastDay =[_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nextDay];//最后一天
    
    for (NSInteger i = lastdayRange.length - components.weekday + 2; i <= lastdayRange.length; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%ld",i];
        [_daysArray addObject:str];
    }
    
    for (NSInteger i = 1; i <= dayRange.length ; i++) {
        
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [_daysArray addObject:string];
    }
    
    for (NSInteger i = 1;i <= (7 - lastDay.weekday) ; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%ld",i];
        [_daysArray addObject:str];
    }
    
}

- (NSDate *)setLastMonthWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = nil;
    if (month != 1) {
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month-1,day]];
    }else{
        
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%ld",year,12,day]];
    }
    
    return date;
}

- (void)nextMonthBtnDidClicked{

    [_daysArray removeAllObjects];
    
    if (_month == 12) {
        _month = 1;
        _year ++;
    }else{
    
        _month ++;
    }
    [self setDayArrayWithYear:_year AndMonth:_month AndDay:_day];
    
    [self.collectionView reloadData];
}

- (void)lastMonthBtnDidClicked{

    [_daysArray removeAllObjects];
    if (_month == 1) {
        _month = 12;
        _year --;
    }else{
    
        _month --;
    }
    [self setDayArrayWithYear:_year AndMonth:_month AndDay:_day];
    [self.collectionView reloadData];

}

#pragma mark - uicollectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (section == 0) {
        return _weekArray.count;
    }
    return _daysArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {//35 45
    
    if (indexPath.section == 0) {
        
        return CGSizeMake((S_WIDTH-30)/8,32);

    }
    
    return CGSizeMake((S_WIDTH-30)/8,43);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellId forIndexPath:indexPath];
    for (UIView *suv in cell.contentView.subviews) {
        [suv removeFromSuperview];
    }
    
    CGRect frame = CGRectZero;
    NSString *text;
    BOOL isGray = NO;
    if (indexPath.section == 0) {
        
        frame.size = CGSizeMake((S_WIDTH-30)/8,32);
        text = _weekArray[indexPath.row];
    }else{
        frame.size = CGSizeMake((S_WIDTH-30)/8,43);
        text = _daysArray[indexPath.row];
        
        if (indexPath.row < 7 && [_daysArray[indexPath.row] integerValue] > 7) {
            isGray = YES;

        }else if (indexPath.row > (_daysArray.count - 7) && [_daysArray[indexPath.row] integerValue] < 7){
            isGray = YES;

        }else{
            
            if (self.selectIndexPath ) {
                
                if (self.selectIndexPath == indexPath) {
                    cell.selected = YES;
                    
                }
                
            }else if ([_daysArray[indexPath.row] integerValue] == _day) {
                cell.selected = YES;
                self.selectIndexPath = indexPath;
            }
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = FONTSIZE(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = isGray ? [UIColor colorWithWhite:1 alpha:0.2] : [UIColor whiteColor];
    label.tag = 100 * indexPath.section + indexPath.row;
    [cell.contentView addSubview:label];

    if (cell.selected) {
        label.textColor = [UIColor blackColor];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = (indexPath.section == 0 || isGray) ? [UIColor clearColor] : [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return;
    }else{
        if (indexPath.row < 7 ) {
            if ([_daysArray[indexPath.row] integerValue] > 7) {
                return;
            }
        }else if (indexPath.row > (_daysArray.count - 7) )
            
            if ([_daysArray[indexPath.row] integerValue] < 7) {
                return;
            }
    }
    
    if (self.selectIndexPath) {
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.selectIndexPath];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100 * self.selectIndexPath.section + self.selectIndexPath.row];
        label.textColor = [UIColor whiteColor];
        cell.selected = NO;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100 * indexPath.section + indexPath.row];
    label.textColor = [UIColor blackColor];
    self.selectIndexPath = indexPath;
    NSString *d ;
    NSString *m ;
    if ([_daysArray[indexPath.row] integerValue]< 10) {
        d = [NSString stringWithFormat:@"0%@",_daysArray[indexPath.row]];
    }else{
        d = _daysArray[indexPath.row];
    }
    if (_month < 10) {
        m = [NSString stringWithFormat:@"0%ld",_month];
    }else{
        m = [NSString stringWithFormat:@"%ld",_month];
    }
    self.selectDayStr = [NSString stringWithFormat:@"%ld-%@-%@",_year,m,d];
}
@end
















