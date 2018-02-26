//
//  YMTimerRemindViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/24.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMTimerRemindViewController.h"
#import "YMTimerAddViewController.h"
#import "YMTimerRemindPluseViewController.h"
#import "YMTimerRemindBloodViewController.h"
#import "YMTimerRemindCheckViewController.h"
#import "YMClockViewController.h"
#import "YMClockManager.h"

#import "YMTimerRemindCell.h"

#import "YMTimerRemindMode.h"
#import "YMTimerMode.h"
#import "RemindDataManager.h"

#define kTommorrowRemind    @"tomorrowRemind"
#define kTodayRemind    @"todayRemind"

@interface YMTimerRemindViewController ()

@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger lastTag;
@property (nonatomic, strong) NSMutableArray *todayArray;
@property (nonatomic, strong) NSMutableArray *tommorrowArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, assign) BOOL    isToday;

@property (nonatomic, strong) RemindDataManager *dataManger;

@end

@implementation YMTimerRemindViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = @"定时提醒";
    self.titleArr = [NSArray arrayWithObjects:@"吃药",@"测血糖",@"测脉搏",@"复查",@"理疗",@"喝水",@"运动",@"睡眠", nil];
    self.imgArr = [NSArray arrayWithObjects:@"timer_drug",@"timer_blood",@"timer_pulse",@"check",@"cure",@"drink",@"timer_run",@"timer_sleep", nil];
    self.todayArray = [NSMutableArray array];
    self.tommorrowArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.tableView.tableHeaderView = [self headerView];
    
    [self queryLocalData];
//    [self requestData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData) name:@"reloadData" object:nil];
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

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (self.lastTag > 0) {
        UIView *view = [self.view viewWithTag:self.lastTag];
        view.backgroundColor = CLEARCOLOR;
    }
}
/*
 *remindTitle;//标题
 *rTime;//提醒的几个时间，逗号拼接
 remindType;//提醒的类型（1~8，吃药、测血压等等）
 *remindId;//
 */

- (void)requestData{

//    YMGetTimerRemindApi *request = [[YMGetTimerRemindApi alloc] initWithUserId:[YMUserInfoMode getAppUserID]];
//    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        
//        if ([[request.responseJSONObject objectForKey:@"status"] integerValue]== 1) {
//            [self.todayArray addObjectsFromArray:[request.responseJSONObject objectForKey:kTodayRemind]];
//            [self.tommorrowArray addObjectsFromArray:[request.responseJSONObject objectForKey:kTommorrowRemind]];
//            
//            if (self.todayArray.count > 0) {
//                if ([self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES].count > 0) {
//                    [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.todayArray isToday:YES]];
//                }
//            }
//            
//            if (self.tommorrowArray.count > 0) {
//                if ([self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO].count > 0) {
//                    
//                    [self.dataArray addObject:[self getNextRemindTimeWithTimeArr:self.tommorrowArray isToday:NO]];
//                }
//            }
//            
//            [self.tableView reloadData];
//        }else{
//        
//            [HUDUtils showHUDToast:[request.responseJSONObject objectForKey:@"message"]];
//        }
//                
//    } failure:^(YTKBaseRequest *request) {
//        [HUDUtils showHUDTxt:HUD_ERR];
//    }];
}

- (UIView *)headerView{

    if (!_headerView) {
        //[UIColor colorWithRed:69 green:113 blue:161 alpha:0.5]
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180 * 1.5)];
        _headerView.backgroundColor = [[Tools hexStringToColor:@"183b7b"] colorWithAlphaComponent:0.5];
        CGFloat width = SCREEN_WIDTH/3.0;
        CGFloat height = _headerView.height/3.0;
        for (NSInteger i = 0; i < 8; i++) {
            UIImage *img = IMGNAME(self.imgArr[i]);
            CGRect frame = CGRectMake( width * (i%3), height * (i/3),width,height);
            UIView *bgView = [[UIView alloc] initWithFrame:frame];
            bgView.backgroundColor = CLEARCOLOR;
            bgView.tag = 101 + i;
            [_headerView addSubview:bgView];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:IMGNAME(self.imgArr[i])];
            imgView.top = (height - img.size.height - 15)/2.0;
            imgView.centerX = width/2.0;
            imgView.userInteractionEnabled = YES;
            [bgView addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 2, width, 15)];
            label.centerX = width/2.0;
            label.bottom = height - 15;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = CLEARCOLOR;
            label.font = FONTSIZE(14);
            label.text = self.titleArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled= YES;
            [bgView addSubview:label];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            [bgView addGestureRecognizer:tap];
            
        }
        
        
    }
    return _headerView;
}


#pragma mark - actions

- (void)tapView:(UITapGestureRecognizer *)tap{

    UIView *view = tap.view;
    view.backgroundColor = [Tools hexStringToColor:@"4571a1"];
    self.lastTag = view.tag;
//    NSString *title = self.titleArr[view.tag - 100];
    
    //添加定时提醒
    if (view.tag - 100 == kTimerRemindDrug || view.tag - 100 == kTimerRemindDrinkWater) {//吃药喝水
        YMTimerAddViewController *vc = [[YMTimerAddViewController alloc] init];
        vc.remindType = view.tag - 100;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (view.tag - 100 == kTimerRemindPluse){//测脉搏
        
        YMTimerRemindPluseViewController *vc = [[YMTimerRemindPluseViewController alloc] init];
        vc.remindType = view.tag - 100;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (view.tag - 100 == kTimerRemindBlood){//血糖
        YMTimerRemindBloodViewController *vc =[[YMTimerRemindBloodViewController alloc] init];
        vc.remindType = view.tag - 100;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (view.tag - 100 == kTimerRemindCheck){//复查
        
        YMTimerRemindCheckViewController *vc = [[YMTimerRemindCheckViewController alloc] init];
        vc.remindType = view.tag - 100;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (view.tag - 100 == kTimerRemindCure || view.tag - 100 == kTimerRemindSport || view.tag - 100 == kTimerRemindSleep){//运动和理疗、睡眠
        
        YMClockViewController *vc = [[YMClockViewController alloc] init];
        vc.remindType = view.tag - 100;
        vc.content = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
//    else if (view.tag - 100 == kTimerRemindSleep){//睡眠
//        
//    }
    
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
    
//    if (indexPath.row == arr.count - 1) {
//        cell.lineView.hidden = YES;
//    }
    
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
                NSInteger index = [weekArray indexOfObject:[NSString stringWithFormat:@"%ld",weekDay]];
                NSString *timeStr = tArr[index];
                [mArr addObjectsFromArray:[timeStr componentsSeparatedByString:@","]];

//                for (NSString *timeStr in tArr) {
//                    if (timeStr.length > 0) {
//                        [mArr addObjectsFromArray:[timeStr componentsSeparatedByString:@","]];
//                    }
//                }
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
                        mode.durationTime = [NSString stringWithFormat:@"还有%@",[[YMClockManager shareManager] getTimeGapWithClockTime:[[YMClockManager shareManager] getTimeWith24HourTimeStr:str]]];
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
    label.textColor = [Tools hexStringToColor:@"183b7b"];
    label.font = FONTSIZE(14);

    if (section == 0 && (self.dataArray.count == 2 || self.tommorrowArray.count <= 0)) {
        label.text = section == 0 ? @"  今天" : @"  明天";
    }else{
        label.text = @"  明天";

    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30.f;
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
