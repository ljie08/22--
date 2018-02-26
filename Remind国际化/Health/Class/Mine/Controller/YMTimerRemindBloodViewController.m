//
//  YMTimerRemindBloodViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/30.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMTimerRemindBloodViewController.h"
#import "YMRemindTitleViewController.h"
#import "YMBellViewController.h"

#import "YMClockCell.h"
#import "YMPickerView.h"
#import "YMClockManager.h"

#import "YMTimerRemindMode.h"
#import "YMBloodChartView.h"
#import "RemindDataManager.h"

#import <AudioToolbox/AudioToolbox.h>

#define YMOnceDay  @"Once"
#define YMDays     @"Days"

@interface YMTimerRemindBloodViewController ()<YMRemindTitleViewControllerDeleagate,YMBellViewControllerDelegate,YMBloodChartViewDelegate>

@property (nonatomic, strong) NSMutableArray      *titleArr;
@property (nonatomic, assign) BOOL         isOpenClock;
@property (nonatomic, assign) BOOL         isOpenShake;
@property (nonatomic, copy)   NSString     *remindTitle;//标题
@property (nonatomic, copy)   NSString     *bellStr;//铃声
@property (nonatomic, strong) RemindDataManager *dataManger;

@end

@implementation YMTimerRemindBloodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    self.dataManger = [RemindDataManager manager];
    //    self.tableView.frame = CGRectMake(0, 100, 200, 100);
}

- (void)initUI{
    
    self.navigationTitle = LOCALIZED(@"测血糖");
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithTitle:LOCALIZED(@"确认")];
    [rightBarItem setTitleColor:COLOR_002 forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton = rightBarItem;
    
//    self.bellStr = @"吉他声";
}

- (void)setContent:(YMTimerRemindMode *)content{
    
    _content = content;
    if (_content) {//修改
        
        self.remindType = _content.remindType;
        self.isOpenClock = YES;
        self.remindTitle = _content.remindTitle;
        self.isOpenShake = _content.remindShake;
        self.bellStr = _content.remindBellId;
    }else{
    
        self.remindTitle = LOCALIZED(@"测血糖");
        self.bellStr = @"吉他声";

    }
    [self.tableView reloadData];
    
}


#pragma mark - getters

- (NSMutableArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"闹钟开关"),LOCALIZED(@"标题")],@[@""],@[LOCALIZED(@"震动")],nil];

//        _titleArr = [NSMutableArray arrayWithObjects:@[@"闹钟开关",@"标题"],@[@""],@[@"震动"],nil];
    }
    return _titleArr;
}


#pragma mark - actions

- (void)rightItemDidClicked{
        
    BOOL isUploadData = NO;
    if (self.isOpenClock) {
        if ([self.content.remindId integerValue] > 0) {//修改
            isUploadData = YES;
        }else{
            NSArray *tArr = [self getTimeArr];
            if (tArr.count > 0) {
                
                NSString *rStr = tArr[0];
                if (rStr.length > 0) {//新增
                    isUploadData = YES;
                }else{
                    
                    [HUDUtils showHUDToast:LOCALIZED(@"请设置时间")];
                    return;
                }
            }else{
                
                [HUDUtils showHUDToast:LOCALIZED(@"请设置时间")];
                return;
            }
            
        }
    }else{
        
        if ([self.content.remindId integerValue] > 0) {//之前有闹钟，现在关闭
            isUploadData = YES;
        }
    }
    
    if (isUploadData) {
        
        NSArray *tArr = [self getTimeArr];
        YMTimerRemindMode *content = [[YMTimerRemindMode alloc] init];
        //    content.userId = @"1";
        content.remindTitle = self.remindTitle;
        content.remindBellId = self.bellStr;
        content.remindTime = tArr.count > 0 ? tArr[0] : @"";
        content.remindShake = self.isOpenShake;
        content.remindPeriod = tArr.count > 0 ? tArr[1] : @"";
        content.remindStatus = [NSString stringWithFormat:@"%d",self.isOpenClock];
        content.remindType = self.remindType;//吃药
        NSString *remindId = self.content.remindId.length>0 ? self.content.remindId:[[YMClockManager shareManager]getCurrentTimeString];
        content.remindId = remindId;
        if (self.content) {
            [self cancelLocalNotification];
            [self.dataManger updateLocalRemindData:content];
        }else{
            [self.dataManger insertRemindData:content];
        }
        
        [self addLocalNotification];
        [HUDUtils showHUDToast:LOCALIZED(@"设置成功")];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        YMBloodChartView *chartView = (YMBloodChartView *)[cell.contentView viewWithTag:101];
        [USER_DEFAULTS setObject:chartView.dataArray[8] forKey:@"MeasureTimes"];
        [USER_DEFAULTS synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        
    }
    if (self.content == nil && !self.isOpenClock) {
        [self.navigationController popViewControllerAnimated:YES];

    }else{
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSArray *)getTimeArr{
    
    NSMutableArray *mArr = [NSMutableArray array];
    NSMutableString *timeStr = [NSMutableString string];
    NSMutableString *weekdayStr = [NSMutableString string];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    YMBloodChartView *chartView = (YMBloodChartView *)[cell viewWithTag:101];
   
    NSArray *timeArray = chartView.dataArray[8];
    
    for (NSInteger row = 1;row < chartView.dataArray.count - 1; row ++) {
        
        NSArray *arr = chartView.dataArray[row];
        
        if (arr.count > 1) {
            for (NSInteger column = 1; column < arr.count ;column ++ ) {
                NSInteger index = [arr[column] integerValue] % 100;
                [timeStr appendString:timeArray[index]];
                if (column == arr.count - 1) {
                    [timeStr appendString:@";"];
                }else{
                    [timeStr appendString:@","];
                }
            }
            if (row == 7) {
                row = 0;
            }

            [weekdayStr appendFormat:@"%ld",row];
            if (row != chartView.dataArray.count - 2) {
                [weekdayStr appendString:@","];
            }
        }
    }
    if (timeStr.length > 0) {
        [mArr addObject:timeStr];
        [mArr addObject:weekdayStr];
    }
    
    return mArr;
}

- (NSMutableArray *)getDataArrayWithSourceArray:(NSArray *)sArray{
    

    NSMutableArray *mArray = [NSMutableArray arrayWithArray:sArray];    
    
    NSMutableArray *measureTimeArray  = sArray[8];;
    if ([USER_DEFAULTS objectForKey:@"MeasureTimes"]) {
        measureTimeArray = [USER_DEFAULTS objectForKey:@"MeasureTimes"];
        [mArray replaceObjectAtIndex:8 withObject:measureTimeArray];
    }
    
    if (self.content.remindTime.length > 0) {
        NSArray *timeArr = [self.content.remindTime componentsSeparatedByString:@";"];
        NSArray *weekArr = [self.content.remindPeriod componentsSeparatedByString:@","];
        for (NSInteger i = 0; i < weekArr.count; i ++) {
            NSInteger weekday = [weekArr[i] integerValue];
            NSMutableArray *rowArray = [NSMutableArray arrayWithArray:mArray[weekday]];
            NSString *timeStr = timeArr[i];
            if (timeStr.length > 0) {
//                NSArray *arr = [timeStr componentsSeparatedByString:@","];
//                for (NSString *str in arr) {
//                    if (str.length > 0) {
//                        for (NSInteger i = 1; i < measureTimeArray.count; i++) {
//                            if ([str isEqualToString:measureTimeArray[i]]) {
//                                [rowArray addObject:@(weekday * 100 + i)];
//                            }
//                        }
//                    }
//                }
                [rowArray addObjectsFromArray:[timeStr componentsSeparatedByString:@","]];
            }
            
            [mArray replaceObjectAtIndex:weekday withObject:rowArray];
        }
    }
    
    
    return mArray;
}


//闹钟
- (void)clockSwitchDidClicked:(UISwitch *)sw{
    
    self.isOpenClock = sw.isOn;
    [self.tableView reloadData];
}

//震动
- (void)shakeSwitchDidClicked:(UISwitch *)sw{
    
    self.isOpenShake = sw.isOn;
    
    if (self.isOpenShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (!self.isOpenClock) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.isOpenClock) {
        return 1;
    }
    
    if (section == 1) {
        return  1;
    }
    
    NSArray *arr = self.titleArr[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = self.titleArr[indexPath.section];
    
    if (indexPath.section == 1) {//定时
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChartCellID"];
            cell.backgroundColor = CLEARCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        YMBloodChartView *chartView = [[YMBloodChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 405 )];
        chartView.tag = 101;
        chartView.delegate = self;
        chartView.dataArray = [self getDataArrayWithSourceArray:chartView.dataArray];
       
        [cell.contentView addSubview:chartView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,chartView.bottom + 15 ,SCREEN_WIDTH,25)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = COLOR_002;
        label.backgroundColor = CLEARCOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = LOCALIZED(@"您可以根据医生建议制定适合自己的监测方案");
        [cell.contentView addSubview:label];
        return cell;
    }
    
    
    YMClockCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[YMClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClockCellID"];
    }
    
    
    if (indexPath.section != 1 && indexPath.section !=2) {
        if (indexPath.row == arr.count -1) {
            cell.lineView.hidden = YES;
        }
    }
    
    cell.tlabel.text = arr[indexPath.row];
    for (UIView *subView in cell.contentView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.cLabel.hidden = YES;
            cell.switchView.hidden = NO;
            cell.switchView.on = self.isOpenClock;
            [cell.switchView addTarget:self action:@selector(clockSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.text = self.remindTitle;
            cell.rightImgName = @"箭头-右";
        }
    }else if (indexPath.section == 2){
        if (indexPath.row ==0) {
            
            cell.cLabel.hidden = YES;
            cell.switchView.hidden = NO;
             cell.switchView.on = self.isOpenShake;
            [cell.switchView addTarget:self action:@selector(shakeSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.hidden = NO;
            cell.cLabel.text =self.bellStr;
            cell.rightImgName = @"箭头-右";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 445 ;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSArray *arr = self.titleArr[indexPath.section];
    if (indexPath.section == 0 && indexPath.row == 1) {//标题
        
        YMRemindTitleViewController *vc = [[YMRemindTitleViewController alloc] init];
        vc.delegate = self;
        //        vc.showButtons = NO;
    
        vc.remindTitle = self.remindTitle;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1) {//
        
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        YMBellViewController *vc = [[YMBellViewController alloc] init];
        vc.delegate = self;
        vc.bellStr = self.bellStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - remindTitleVC

- (void)remindTitleDidEdited:(NSString *)title{
    
    self.remindTitle = LOCALIZED(title);
    
    YMClockCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.cLabel.text = self.remindTitle;
    
}

#pragma mark - YMBellViewControllerDelegate

- (void)didSelectBellName:(NSString *)bellName{
    
    self.bellStr = bellName;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - YMBloodChartViewDelegate

- (void)refreshCellWithTimeDidChange{

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma  mark - localnotification

- (void)addLocalNotification{
    
    //1 只响一次
    //2 不固定日期
    //3 工作日
    //4 每天
    
//    NSString *notificationID;
//    NSString *notificationName;
//    NSDate *fireDate;
//    NSString *bodyText = self.navigationTitle;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    YMBloodChartView *chartView = (YMBloodChartView *)[cell.contentView viewWithTag:101];
    
    NSArray *timeArr = chartView.dataArray[8];
    for (NSInteger row = 1; row < chartView.dataArray.count - 1 ; row ++ ) {
        
        NSArray *rowArray = chartView.dataArray[row];
        if (rowArray.count > 1) {
            
            for (NSInteger index = 1;index < rowArray.count ;index++) {
                
                NSInteger column = [rowArray[index] integerValue]%100;
//                notificationID = [NSString stringWithFormat:@"测血糖周%ld%@%ld",row,YMDays,index];//吃药  周一 第一次
//                notificationName = [NSString stringWithFormat:@"%@Name",notificationID];
//                NSDictionary *useInfo =@{notificationID:notificationName};
//                fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:[self getTimeStrWithClockTime:timeArr[column]] selectedDay:row - 1];
//                
//                [[YMClockManager shareManager] addLocalNotificationForFireDate:fireDate forKey:notificationID alertBody:@"测血糖" alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:NSCalendarUnitWeekOfYear];
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navigationTitle remindTitle:self.remindTitle weekDay:rowArray[0] clockTime:timeArr[column] RepeatInterval:NSCalendarUnitWeekOfYear];
            }
            
        }
    }
    
}

- (void)cancelLocalNotification{
    
//    NSString *key;
    if (_content.remindPeriod.length > 0) {
        NSMutableArray *sArr =[NSMutableArray arrayWithArray:[_content.remindPeriod componentsSeparatedByString:@","]];
        NSMutableArray *tArray = [NSMutableArray arrayWithArray:[_content.remindTime componentsSeparatedByString:@";"]];
        [sArr removeObject:@""];
        [tArray removeObject:@""];
        if (sArr.count > 0 ) {
            for (NSInteger weekDay = 0; weekDay < sArr.count; weekDay ++) {
                
                NSString *tStr = tArray[weekDay];
                NSMutableArray *timeArr = [NSMutableArray arrayWithArray:[tStr componentsSeparatedByString:@","]];
                [timeArr removeObject:@""];

                for (NSInteger i = 0; i < timeArr.count; i ++){
                    
//                    key = [NSString stringWithFormat:@"测血糖周%ld%@%ld",weekDay + 1,YMDays,(long)weekDay];
//                    [[YMClockManager shareManager] cancelLocalNotificationWithKey:key];
                    
                    if (weekDay == 0) {
                        weekDay = 7;
                    }
                    
                    [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navigationTitle remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",weekDay + 1] clockTime:timeArr[i]];
                }
            }
        }
        
    }
    
}

//- (NSString *)getTimeStrWithClockTime:(NSString *)timeStr{
//    
//    NSMutableString  *mStr = [NSMutableString string];
//    NSArray *arr = [timeStr componentsSeparatedByString:@":"];
//    if ([arr[0] integerValue] < 12) {
//        [mStr appendString:@"上午"];
//        [mStr appendString:timeStr];
//    }else{
//        [mStr appendString:@"下午"];
//        if ([arr[0] integerValue ]- 12 < 10) {
//            [mStr appendFormat:@"0%ld:",[arr[0] integerValue] - 12];
//            
//        }else{
//            [mStr appendFormat:@"%ld:",[arr[0] integerValue] - 12];
//        }
//        
//        [mStr appendString:arr[1]];
//    }
//    
//    return mStr;
//}

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
