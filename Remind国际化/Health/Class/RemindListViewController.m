//
//  RemindListViewController.m
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "RemindListViewController.h"
#import "YMTimerRemindViewController.h"
#import "YMTimerAddViewController.h"
#import "YMTimerRemindPluseViewController.h"
#import "YMTimerRemindBloodViewController.h"
#import "YMTimerRemindCheckViewController.h"
#import "YMClockViewController.h"
#import "YMClockManager.h"
#import "RemindCell.h"
#import "NewRemindCell.h"
#import "RemindOptionView.h"
#import "RemindDataManager.h"
#import "YMTimerRemindMode.h"
#import "YMTimerMode.h"
#import "YMTimerRemindCell.h"

#import "ClockView.h"
#import "StarView.h"

@interface RemindListViewController ()<RemindOptionViewDelegate,YMTimerRemindCellDelegate>

@property (nonatomic, strong) RemindOptionView *optionView;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) StarView       *starView;

@property (nonatomic, strong) NSMutableArray *todayArray;
@property (nonatomic, strong) NSMutableArray *tommorrowArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) BOOL    isToday;
@property (nonatomic, assign) BOOL    isShowOption;


@property (nonatomic, strong) RemindDataManager *dataManger;


@end

@implementation RemindListViewController{
    ClockView *clockView;
    NSTimeInterval  timeInterval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
    self.isShowOption = NO;
    
    self.titleArr = [NSArray arrayWithObjects:LOCALIZED(@"吃药"),LOCALIZED(@"测血糖"),LOCALIZED(@"测脉搏"),LOCALIZED(@"复查"),LOCALIZED(@"理疗"),LOCALIZED(@"喝水"),LOCALIZED(@"运动"),LOCALIZED(@"睡眠"), nil];

//    self.titleArr = [NSArray arrayWithObjects:LOCALIZED(@"吃药"),@"测血糖",@"测脉搏",@"复查",@"理疗",@"喝水",@"运动",@"睡眠", nil];
    self.imgArr = [NSArray arrayWithObjects:@"timer_drug",@"timer_blood",@"timer_pulse",@"check",@"cure",@"drink",@"timer_run",@"timer_sleep", nil];
    self.dataSource = [NSMutableArray array];
    self.todayArray = [NSMutableArray array];
    self.tommorrowArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    self.tableView.top = clockView.bottom + 20;
    self.tableView.height = SCREEN_HEIGHT - (clockView.bottom + 20);
    [self queryLocalData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData) name:@"reloadData" object:nil];
    
}

- (void)initUI{
    self.navigationTitle = LOCALIZED(@"定时提醒");//NSLocalizedString(@"定时提醒",nil);//@"定时提醒";
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithImageNormal:IMGNAME(@"navbar_add_nor") imageSelected:nil];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton   = rightBarItem;
    
    [self starView];
    [self showClockView];
    [self timeLabel];
    self.timeLabel.text = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
    timeInterval = 60 -[[YMClockManager shareManager] getCurrentSeconds];
    clockView.progress = timeInterval/60.0;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (timeInterval >= 60) {
            timeInterval = 0;
            self.timeLabel.text = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
            [self reloadTableView];
        }else{
            timeInterval +=1;
        }
        clockView.progress = timeInterval/60.0;
        self.starView.roateAngel = M_PI * 2 * timeInterval/60.0;
    }];
    
}

- (void)reloadTableView{
    [self.dataArray removeAllObjects];
    if (self.todayArray.count > 0) {
        if ([self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES].count > 0) {
            [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES]];
        }
    }
    
    if (self.tommorrowArray.count > 0) {
        if ([self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO].count > 0) {
            
            [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO]];
        }
    }
//    if (self.dataArray.count > 0) {
//        for (NSInteger i = 0; i < self.dataArray.count ; i ++) {
//            NSArray *arr = self.dataArray[i];
//            for (NSInteger row = 0; row < self.dataArray.count ; row ++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:i];
//                
//            }
//        }
//    }
    
    [self.tableView reloadData];
}

- (void)showClockView{
    CGFloat itemWidth = 170 + 20 + 50;//150
    
    CGFloat xCrack = ([UIScreen mainScreen].bounds.size.width-itemWidth)/2.0;
    //    CGFloat yCrack = ([UIScreen mainScreen].bounds.size.height-150)/2.0;
    clockView = [[ClockView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, itemWidth + 40) pathBackColor:[UIColor whiteColor] pathFillColor:[UIColor whiteColor] startAngle:-M_PI_2 strokeWidth:1];
    clockView.pointImage = IMGNAME(@"musicDot");
    clockView.sliderModel = kClockViewProgress;
    clockView.animationModel = kClockViewIncreaseByProgress;
    clockView.showPoint = YES;
    clockView.increaseFromLast = YES;

    [self.view addSubview:clockView];
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
    
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 180, 40)];
        _timeLabel.center = clockView.center;
        _timeLabel.font = FONTSIZE(40);//[UIFont fontWithName:@"HelveticaNeue-ExtBlackCond" size:40];
        _timeLabel.textColor = COLOR_002;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
//        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (RemindOptionView *)optionView{
    if (!_optionView) {
        
        _optionView = [[RemindOptionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _optionView.delegate = self;
    }
    return _optionView;
}

- (StarView *)starView{
    if (!_starView) {
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [self.view addSubview:_starView];
        [self.view bringSubviewToFront:_starView];
    }
    return _starView;
}

- (void)rightItemDidClicked{
    
    [self.optionView showWithAnimate:YES];
   
//    YMTimerRemindViewController *vc = [[YMTimerRemindViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - remindOptionViewDelegate
- (void)didSelectecRemindType:(NSInteger)remindType{
    
    //添加定时提醒
    if (remindType == kTimerRemindDrug || remindType == kTimerRemindDrinkWater) {//吃药喝水
        YMTimerAddViewController *vc = [[YMTimerAddViewController alloc] init];
        vc.remindType = remindType;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (remindType == kTimerRemindPluse){//测脉搏
        
        YMTimerRemindPluseViewController *vc = [[YMTimerRemindPluseViewController alloc] init];
        vc.remindType = remindType;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (remindType == kTimerRemindBlood){//血糖
        YMTimerRemindBloodViewController *vc =[[YMTimerRemindBloodViewController alloc] init];
        vc.remindType = remindType;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (remindType == kTimerRemindCheck){//复查
        
        YMTimerRemindCheckViewController *vc = [[YMTimerRemindCheckViewController alloc] init];
        vc.remindType = remindType;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (remindType == kTimerRemindCure || remindType == kTimerRemindSport || remindType == kTimerRemindSleep){//运动和理疗、睡眠
        
        YMClockViewController *vc = [[YMClockViewController alloc] init];
        vc.remindType = remindType;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}

- (void)queryLocalData{
    self.dataManger = [RemindDataManager manager];
    [self.dataSource addObjectsFromArray:[self.dataManger queryRemindList]];
    if ([self.dataSource count]) {
        for (YMTimerRemindMode *content in self.dataSource) {
            if (content.remindPeriod.length <= 0) {
                [self.todayArray addObject:content];
            }else{
                if (content.remindType == 4) {//复查
                    NSString *nowStr = [[YMClockManager shareManager] getNowDay];
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *nextDate = [date dateByAddingHours:24];
                    NSString *nextStr = [formatter stringFromDate:nextDate];
                    
                    if ([nowStr isEqualToString:content.remindPeriod]) {
                        [self.todayArray addObject:content];
                    }else if ([nextStr isEqualToString:content.remindPeriod]){
                        [self.tommorrowArray addObject:content];
                    }
                }
                NSInteger type = [self isToday:content.remindPeriod];
                if (type == 1) {
                    [self.todayArray addObject:content];
                }else if (type == 2) {
                    [self.tommorrowArray addObject:content];
                }else if (type == 3) {
                    [self.todayArray addObject:content];
                    [self.tommorrowArray addObject:content];
                }
                
            }
        }
        if (self.todayArray.count > 0) {
            if ([self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES].count > 0) {
                [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES]];
            }
        }
        
        if (self.tommorrowArray.count > 0) {
            if ([self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO].count > 0) {
                
                [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO]];
            }
        }
        
        [self.tableView reloadData];
    }
}

- (NSInteger)isToday:(NSString *)remindPeriod{//1 今天  2 明天  3 今明两天或者每天  0都不是
    
    NSArray *sArray = [remindPeriod componentsSeparatedByString:@","];
    if (sArray.count > 0) {
        NSInteger weekDay = [[YMClockManager shareManager] getCurrentLocalWeekDay];
        if (weekDay == 0) {
            weekDay = 8;
        }
        weekDay = weekDay - 1;
        
        for (NSInteger i = 0; i < sArray.count; i++) {
            NSString *weekStr = sArray[0];
            if ([weekStr integerValue] == 8) {//每天
                return  3;
            }else if ([weekStr integerValue] == 7){//工作日
                
                if (weekDay == 4 || weekDay == 5) {//周五、周六不提醒
                    return  0;
                }else{
                    
                    return  3;
                }
            }
            
            if ([weekStr integerValue] == weekDay) {
                for (NSString *nextWeekStr in sArray) {
                    if([nextWeekStr integerValue] == weekDay + 1){
                        return 3;
                    }
                }
                return  1;
            }else if([weekStr integerValue] == weekDay + 1){
                
                for (NSString *nextWeekStr in sArray) {
                    if([nextWeekStr integerValue] == weekDay){
                        return 3;
                    }
                }
                return 2;
            }
            
        }
    }
    return 0;
}

- (void)reloadRequestData{
    
    [self.todayArray removeAllObjects];
    [self.tommorrowArray removeAllObjects];
    [self.dataArray removeAllObjects];
    //    [self requestData];
    [self.dataSource removeAllObjects];
    [self queryLocalData];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.dataArray[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMTimerRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[YMTimerRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    NSArray *arr = self.dataArray[indexPath.section];
    YMTimerMode *content = arr[indexPath.row];
    cell.imgView.image = IMGNAME(self.imgArr[content.remindType - 1]);
    cell.timeLabel.text = content.rTime;
    cell.tLabel.text = content.remindTitle;
    cell.durationLabel.text = content.durationTime;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)getNextRemindTimeWithTimeArr:(NSArray *)Array  isToday:(BOOL)isToday{
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (YMTimerRemindMode *content in Array) {
        
        NSArray *timeArr;
        if (content.remindType == 2) {//测血糖
            
            NSMutableArray *mArr = [NSMutableArray array];
            
            NSArray *tArr = [content.remindTime componentsSeparatedByString:@";"];
            if (tArr.count > 0) {
                
                NSInteger weekDay = [self getWeekDayWithIsToday:isToday];
                NSArray *weekArray = [content.remindPeriod componentsSeparatedByString:@","];
                NSInteger index = [weekArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)weekDay]];
                NSString *timeStr = tArr[index];
                [mArr addObjectsFromArray:[timeStr componentsSeparatedByString:@","]];
               
            }
            timeArr = [NSArray arrayWithArray:mArr];
            
        }else{
            
            timeArr = [content.remindTime componentsSeparatedByString:@","];
            
        }
        if (timeArr.count <= 0) {
            return mArr;
        }
        for (NSString *str in timeArr) {
            if (str.length > 0) {
                
                if (isToday) {
                    
                    NSInteger seconds = [self getSecondsWithClockTime:str];
                    if (seconds >= 0) {
                        YMTimerMode *mode = [[YMTimerMode alloc] init];
                        mode.remindId = content.remindId;
                        mode.remindTitle = content.remindTitle;
                        mode.remindType = content.remindType;
                        mode.rTime =  str; //[self getTimeStrWithRemindStr:str];
                        mode.durationTime = [NSString stringWithFormat:@"%@%@",LOCALIZED(@"还有"),[[YMClockManager shareManager] getTimeGapWithClockTime:[[YMClockManager shareManager] getTimeWith24HourTimeStr:str]]];
                        [mArr addObject:mode];
                    }
                }else{
                    
                    YMTimerMode *mode = [[YMTimerMode alloc] init];
                    mode.remindId = content.remindId;
                    mode.remindTitle = content.remindTitle;
                    mode.remindType = content.remindType;
                    mode.rTime =  str; //[self getTimeStrWithRemindStr:str];
                    mode.durationTime = [self getDescriptionWithClockTime:str];
                    [mArr addObject:mode];
                }
                
                
            }
        }
        
    }
    return mArr;
}

//距离明天闹钟的时间差
- (NSString *)getDescriptionWithClockTime:(NSString *)cTime{
    
    NSString *nowDateStr = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
    NSArray *nArr = [nowDateStr componentsSeparatedByString:@":"];
    NSArray *cArr = [cTime componentsSeparatedByString:@":"];
    
    NSInteger minutes = ([cArr[0] integerValue] + 24 - [nArr[0] integerValue]) * 60 + [cArr[1] integerValue] - [nArr[1] integerValue];
    
    
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"还有%ld小时%ld分钟",minutes/60,minutes%60];
    return mStr;
}

- (NSInteger)getSecondsWithClockTime:(NSString *)str{
    
    NSArray *timeArr = [str componentsSeparatedByString:@":"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hourStr = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"mm"];
    NSString *minuteStr = [dateFormatter1 stringFromDate:date];
    NSInteger seconds = ([timeArr[0] integerValue] * 3600 + [timeArr[1] integerValue] * 60) - ([hourStr integerValue] * 3600 + [minuteStr integerValue] * 60);
    
    return seconds;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH - 25, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_002;//[Tools hexStringToColor:@"183b7b"];
    label.font = FONTSIZE(14);
    
    if (section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
        label.text = section == 0 ? LOCALIZED(@"今天") : LOCALIZED(@"明天");
    }else{
        label.text = LOCALIZED(@"明天");
        
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f + 10.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
}

- (void)didDeleteCell:(YMTimerRemindCell *)cell{
    
    NSIndexPath *indexPath = cell.indexPath;
    //上传删除的数据
    NSMutableArray *mArr = self.dataArray[indexPath.section];
    YMTimerMode *mode = mArr[indexPath.row];
    BOOL isToday = YES;
    YMTimerRemindMode *content;
    
    
    if (indexPath.section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
        for (YMTimerRemindMode *con in self.todayArray) {
            if ([con.remindId isEqualToString:mode.remindId]) {
                content = con;
                NSMutableString *mStr = [NSMutableString stringWithString:[self getRemindStrWithSourceStr:content.remindTime deleteStr:mode.rTime withRemindPeriod:content.remindPeriod isToday:YES]];;
                
                //单次
                if (content.remindPeriod.length <= 0) {
                    
                    if ([self getRemindStrWithRemindId:content.remindId andIsToday:NO].length > 0) {
                        [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:NO]];
                    }
                    
                }
                
                content.remindTime = mStr;
                if (content.remindType == kTimerRemindBlood) {
                    
                    content.remindPeriod = [self getNewPeriodWithSourcePeriod:content.remindPeriod andIsToday:YES];
                }
                
                break;
            }
        }
    }else{
        isToday = NO;
        for (YMTimerRemindMode *con in self.tommorrowArray) {
            if ([con.remindId isEqualToString:mode.remindId]) {
                content = con;
                NSMutableString *mStr = [NSMutableString stringWithString:[self getRemindStrWithSourceStr:content.remindTime deleteStr:mode.rTime withRemindPeriod:content.remindPeriod isToday:NO]];;
                
                //单次
                if (content.remindPeriod.length <= 0) {
                    
                    if ([self getRemindStrWithRemindId:content.remindId andIsToday:NO].length > 0) {
                        [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:YES]];
                    }
                }
                content.remindTime = mStr;
                if (content.remindType == kTimerRemindBlood) {
                    
                    content.remindPeriod = [self getNewPeriodWithSourcePeriod:content.remindPeriod andIsToday:NO];
                }
                break;
            }
        }
        
    }
    //删除本地数据
    [mArr removeObject:mode];
    if (mArr.count <=0) {
        [self.dataArray removeObject:mArr];
    }else{
        
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:mArr];
        
    }
    if (content.remindTime.length > 0) {
        [self.dataManger updateLocalRemindData:content];
    }else{
        [self.dataManger removeRelationShipOfRemindContent:content];
        [self cancelNotificationWithContent:content withDeleteClockTime:mode.rTime isToday:isToday];
    }
    [HUDUtils showHUDToast:LOCALIZED(@"删除成功")];
    [self reloadRequestData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArray[indexPath.section];
    YMTimerMode *mode = arr[indexPath.row];
    NSMutableArray *mArr ;
    BOOL tureToday = NO;
    if (indexPath.section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
        
        mArr  = self.todayArray;
        tureToday = YES;
    }else{
        
        mArr = self.tommorrowArray;
    }
    
    YMTimerRemindMode *content;
    for (YMTimerRemindMode *con in mArr) {
        if ([con.remindId isEqualToString:mode.remindId]) {
            content = con;
            //单次提醒
            NSString *rPeriod = content.remindPeriod;
            if (rPeriod.length <= 0) {
                NSMutableString *mStr = [NSMutableString stringWithString:content.remindTime];
                if ([self getRemindStrWithRemindId:content.remindId andIsToday:!tureToday].length > 0) {
                    //                        [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:NO]];
                    [mStr insertString:[self getRemindStrWithRemindId:content.remindId andIsToday:!tureToday] atIndex:0];
                }
                content.remindTime = mStr;
            }
            
            break;
        }
    }
    
    //编辑对应的提醒类型
    if (content.remindType == kTimerRemindDrug || content.remindType == kTimerRemindDrinkWater) {//吃药喝水
        YMTimerAddViewController *vc = [[YMTimerAddViewController alloc] init];
        vc.remindType = content.remindType;
        vc.content = content;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (content.remindType == kTimerRemindPluse){//测脉搏
        
        YMTimerRemindPluseViewController *vc = [[YMTimerRemindPluseViewController alloc] init];
        vc.remindType = content.remindType;
        vc.content = content;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (content.remindType == kTimerRemindBlood){//血糖
        YMTimerRemindBloodViewController *vc =[[YMTimerRemindBloodViewController alloc] init];
        vc.remindType = content.remindType;
        vc.content = content;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (content.remindType == kTimerRemindCheck){//复查
        
        YMTimerRemindCheckViewController *vc = [[YMTimerRemindCheckViewController alloc] init];
        vc.remindType = content.remindType;
        vc.content = content;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (content.remindType == kTimerRemindCure || content.remindType == kTimerRemindSport || content.remindType == kTimerRemindSleep){//运动和理疗、睡眠
        
        YMClockViewController *vc = [[YMClockViewController alloc] init];
        vc.remindType = content.remindType;
        vc.content = content;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        NSArray *arr = self.dataArray[indexPath.section];
        YMTimerMode *mode = arr[indexPath.row];
        NSMutableArray *mArr ;
        BOOL tureToday = NO;
        if (indexPath.section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
            
            mArr  = self.todayArray;
            tureToday = YES;
        }else{
            
            mArr = self.tommorrowArray;
        }
        
        YMTimerRemindMode *content;
        for (YMTimerRemindMode *con in mArr) {
            if ([con.remindId isEqualToString:mode.remindId]) {
                content = con;
                //单次提醒
                NSString *rPeriod = content.remindPeriod;
                if (rPeriod.length <= 0) {
                    NSMutableString *mStr = [NSMutableString stringWithString:content.remindTime];
                    if ([self getRemindStrWithRemindId:content.remindId andIsToday:!tureToday].length > 0) {
                        //                        [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:NO]];
                        [mStr insertString:[self getRemindStrWithRemindId:content.remindId andIsToday:!tureToday] atIndex:0];
                    }
                    content.remindTime = mStr;
                }
                
                break;
            }
        }
        
        //编辑对应的提醒类型
        if (content.remindType == kTimerRemindDrug || content.remindType == kTimerRemindDrinkWater) {//吃药喝水
            YMTimerAddViewController *vc = [[YMTimerAddViewController alloc] init];
            vc.remindType = content.remindType;
            vc.content = content;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (content.remindType == kTimerRemindPluse){//测脉搏
            
            YMTimerRemindPluseViewController *vc = [[YMTimerRemindPluseViewController alloc] init];
            vc.remindType = content.remindType;
            vc.content = content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (content.remindType == kTimerRemindBlood){//血糖
            YMTimerRemindBloodViewController *vc =[[YMTimerRemindBloodViewController alloc] init];
            vc.remindType = content.remindType;
            vc.content = content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (content.remindType == kTimerRemindCheck){//复查
            
            YMTimerRemindCheckViewController *vc = [[YMTimerRemindCheckViewController alloc] init];
            vc.remindType = content.remindType;
            vc.content = content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (content.remindType == kTimerRemindCure || content.remindType == kTimerRemindSport || content.remindType == kTimerRemindSleep){//运动和理疗、睡眠
            
            YMClockViewController *vc = [[YMClockViewController alloc] init];
            vc.remindType = content.remindType;
            vc.content = content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //上传删除的数据
        NSMutableArray *mArr = self.dataArray[indexPath.section];
        YMTimerMode *mode = mArr[indexPath.row];
        BOOL isToday = YES;
        YMTimerRemindMode *content;
        
        
        if (indexPath.section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
            for (YMTimerRemindMode *con in self.todayArray) {
                if ([con.remindId isEqualToString:mode.remindId]) {
                    content = con;
                    NSMutableString *mStr = [NSMutableString stringWithString:[self getRemindStrWithSourceStr:content.remindTime deleteStr:mode.rTime withRemindPeriod:content.remindPeriod isToday:YES]];;
                    
                    //单次
                    if (content.remindPeriod.length <= 0) {
                        
                        if ([self getRemindStrWithRemindId:content.remindId andIsToday:NO].length > 0) {
                            [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:NO]];
                        }
                        
                    }
                    
                    content.remindTime = mStr;
                    if (content.remindType == kTimerRemindBlood) {
                        
                        content.remindPeriod = [self getNewPeriodWithSourcePeriod:content.remindPeriod andIsToday:YES];
                    }
                    //                    if (content.remindTime.length <=0) {
                    //                        [self.todayArray removeObject:dict];
                    //
                    ////                        if (self.todayArray.count > 0) {
                    ////                            if ([self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES].count > 0) {
                    ////                                [self.dataArray replaceObjectAtIndex:indexPath.section withObject:[self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES]];
                    ////                            }
                    ////                         }
                    //                    }
                    
                    break;
                }
            }
        }else{
            isToday = NO;
            for (YMTimerRemindMode *con in self.tommorrowArray) {
                if ([con.remindId isEqualToString:mode.remindId]) {
                    content = con;
                    NSMutableString *mStr = [NSMutableString stringWithString:[self getRemindStrWithSourceStr:content.remindTime deleteStr:mode.rTime withRemindPeriod:content.remindPeriod isToday:NO]];;
                    
                    //单次
                    if (content.remindPeriod.length <= 0) {
                        
                        if ([self getRemindStrWithRemindId:content.remindId andIsToday:NO].length > 0) {
                            [mStr appendString:[self getRemindStrWithRemindId:content.remindId andIsToday:YES]];
                        }
                    }
                    content.remindTime = mStr;
                    if (content.remindType == kTimerRemindBlood) {
                        
                        content.remindPeriod = [self getNewPeriodWithSourcePeriod:content.remindPeriod andIsToday:NO];
                    }
                    break;
                }
            }
            
        }
        //删除本地数据
        [mArr removeObject:mode];
        if (mArr.count <=0) {
            [self.dataArray removeObject:mArr];
        }else{
            
            [self.dataArray replaceObjectAtIndex:indexPath.section withObject:mArr];
            
        }
        if (content.remindTime.length > 0) {
            [self.dataManger updateLocalRemindData:content];
        }else{
            [self.dataManger removeRelationShipOfRemindContent:content];
            [self cancelNotificationWithContent:content withDeleteClockTime:mode.rTime isToday:isToday];
        }
        [HUDUtils showHUDToast:@"删除成功"];
        [self reloadRequestData];
        
        //上传数据
        
        //        YMTimerRemindApi *request = [[YMTimerRemindApi alloc] initWithTimerRemindContent:content];
        //        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        //
        //            YMTimerRemindMode *content = [[YMTimerRemindMode alloc] initWithDictionary:request.responseJSONObject];
        //            if ([content.status integerValue]== Status_Succ) {
        //
        //                [self.todayArray removeAllObjects];
        //                [self.tommorrowArray removeAllObjects];
        //                [self.dataArray removeAllObjects];
        //                [self requestData];
        //                [self cancelNotificationWithContent:content withDeleteClockTime:mode.rTime isToday:isToday];
        //                [HUDUtils showHUDToast:@"删除成功"];
        //
        //            }else{
        //                [HUDUtils showHUDToast:content.message];
        //
        //            }
        //
        //        } failure:^(YTKBaseRequest *request) {
        //            [HUDUtils showHUDToast:HUD_ERR];
        //        }];
        
    }];
    editAction.backgroundColor = COLOR_000;
    deleteAction.backgroundColor = [COLOR_000 colorWithAlphaComponent:0.5];
    
    return @[deleteAction,editAction];
}


-(NSString *)getRemindStrWithRemindId:(NSString *)remindId andIsToday:(BOOL)isToday{
    
    if (isToday) {
        for (YMTimerRemindMode *content in self.todayArray) {
            if ([content.remindId isEqualToString:remindId]) {
                return content.remindTime;
            }
        }
    }else{
        for (YMTimerRemindMode *content in self.tommorrowArray) {
            if ([content.remindId isEqualToString:remindId]) {
                return content.remindTime;
            }
        }
    }
    
    return @"";
}

- (NSString *)getNewPeriodWithSourcePeriod:(NSString *)sPeriod andIsToday:(BOOL)isToday{
    
    NSInteger weekDay = [self getWeekDayWithIsToday:isToday];
    NSMutableString *mStr = [NSMutableString stringWithString:sPeriod];
    NSRange range = [mStr rangeOfString:[NSString stringWithFormat:@"%ld",weekDay]];
    if (range.location != NSNotFound) {
        
        if (range.location + range.length == mStr.length) {
            [mStr deleteCharactersInRange:range];
        }else{
            
            [mStr deleteCharactersInRange:NSMakeRange(range.location, range.length + 1)];
            
        }
    }
    
    return mStr;
}

- (NSInteger)getWeekDayWithIsToday:(BOOL)isToday{
    
    NSInteger weekDay = [[YMClockManager shareManager] getCurrentWeekDay] - 1;
    
    if (!isToday) {
        
        weekDay += 1;
    }
    
    return weekDay;
}


- (NSString *)getRemindStrWithSourceStr:(NSString *)sourceStr deleteStr:(NSString *)dStr withRemindPeriod:(NSString *)rPeriod isToday:(BOOL)isToday{
    
    NSMutableArray *timeArr = [NSMutableArray arrayWithCapacity:0];
    if ([sourceStr rangeOfString:@";"].location != NSNotFound) {//血糖
        
        NSInteger weekDay = [self getWeekDayWithIsToday:isToday];
        
        NSMutableArray *sArr = [NSMutableArray arrayWithArray:[sourceStr componentsSeparatedByString:@";"]];
        NSArray *wArray = [rPeriod componentsSeparatedByString:@","];
        
        NSInteger index = [wArray indexOfObject:[NSString stringWithFormat:@"%ld",weekDay]];
        
        NSMutableString *mStr = [NSMutableString stringWithString:sArr[index]];
        NSRange range = [mStr rangeOfString:dStr];
        if (range.location != NSNotFound) {
            if (range.location + range.length == mStr.length) {
                [mStr deleteCharactersInRange:range];
                
            }else{
                
                [mStr deleteCharactersInRange:NSMakeRange(range.location, range.length + 1)];
                
            }
        }
        
        if (mStr.length > 0) {
            [sArr replaceObjectAtIndex:index withObject:mStr];
        }else{
            [sArr removeObjectAtIndex:index];
        }
        
        [timeArr addObjectsFromArray:sArr];
        
    }else{
        
        [timeArr addObjectsFromArray:[sourceStr componentsSeparatedByString:@","]];
        if ([timeArr indexOfObject:dStr] != NSNotFound) {
            [timeArr removeObject:dStr];
        }
        
    }
    
    if (timeArr.count > 0) {
        NSMutableString *mStr = [NSMutableString string];
        for (NSInteger i = 0; i < timeArr.count; i++) {
            
            [mStr appendString: timeArr[i]];
            if (i != timeArr.count - 1) {
                [mStr appendString:@","];
            }
        }
        return mStr;
    }
    return @"";
}

- (void)cancelNotificationWithContent:(YMTimerRemindMode *)content  withDeleteClockTime:(NSString *)cTime isToday:(BOOL)isToday{
    
    if (content.remindType == kTimerRemindBlood) {
        
        NSInteger weekDay = [self getWeekDayWithIsToday:isToday];
        
        [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.titleArr[content.remindType] remindTitle:content.remindTitle weekDay:[NSString stringWithFormat:@"%ld",weekDay] clockTime:cTime];
    }
    
    if (content.remindPeriod.length > 0) {//周期
        
        NSArray *weekArray = [content.remindPeriod componentsSeparatedByString:@","];
        for (NSString *weekDay in weekArray) {
            
            [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.titleArr[content.remindType] remindTitle:content.remindTitle weekDay:weekDay clockTime:cTime];
        }
        
    }else{
        
        [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.titleArr[content.remindType] remindTitle:content.remindTitle weekDay:@"" clockTime:cTime];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
