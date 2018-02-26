//
//  YMTimerRemindCheckViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/4/1.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMTimerRemindCheckViewController.h"
#import "YMRemindTitleViewController.h"
#import "YMBellViewController.h"

#import "YMCustomCanlendarView.h"
#import "YMClockCell.h"
#import "YMPickerView.h"
#import "YMClockManager.h"
#import "YMPickerView.h"

#import "YMTimerRemindMode.h"

#import <AudioToolbox/AudioToolbox.h>
#import "RemindDataManager.h"


@interface YMTimerRemindCheckViewController ()<YMRemindTitleViewControllerDeleagate,YMBellViewControllerDelegate,YMCustomCanlendarViewDelegate,YMPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray      *titleArr;
@property (nonatomic, assign) BOOL         isOpenClock;
@property (nonatomic, assign) BOOL         isOpenShake;
@property (nonatomic, copy)   NSString     *remindTitle;//标题
@property (nonatomic, copy)   NSString     *bellStr;//铃声
@property (nonatomic, copy)   NSString     *clockTime;
@property (nonatomic, strong) YMPickerView *pickerView;
@property (nonatomic, strong) YMCustomCanlendarView *calendarView;
@property (nonatomic, strong) RemindDataManager *dataManger;

@end

@implementation YMTimerRemindCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    self.dataManger = [RemindDataManager manager];
    //    self.tableView.frame = CGRectMake(0, 100, 200, 100);
}

- (void)initUI{
    
    self.navigationTitle = LOCALIZED(@"复查");
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithTitle:LOCALIZED(@"确认")];
    [rightBarItem setTitleColor:COLOR_002 forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton = rightBarItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.bellStr = @"吉他声";
//    self.clockTime = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
}

- (void)setContent:(YMTimerRemindMode *)content{
    
    _content = content;
    if (_content) {//修改
        
        self.remindType = _content.remindType;
        self.isOpenClock = YES;
        self.clockTime = _content.remindTime;
        self.remindTitle = _content.remindTitle;
        self.isOpenShake = _content.remindShake;
        self.bellStr = _content.remindBellId;
        
    }else{
        
        self.remindTitle = LOCALIZED(@"复查");
        self.bellStr = @"吉他声";
        self.clockTime = [[YMClockManager shareManager] getCurrentTimeBy24Hours];

    }
    [self.tableView reloadData];
    
}


#pragma mark - getters

- (NSMutableArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"闹钟开关"),LOCALIZED(@"标题")],@[@""],@[LOCALIZED(@"闹钟定时")],@[LOCALIZED(@"震动")],nil];

//        _titleArr = [NSMutableArray arrayWithObjects:@[@"闹钟开关",@"标题"],@[@""],@[@"闹钟定时"],@[@"震动"],nil];
    }
    return _titleArr;
}

- (YMPickerView *)pickerView{
    
    if (!_pickerView) {
        
        _pickerView = [[YMPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (YMCustomCanlendarView *)calendarView{

    if (!_calendarView) {
        _calendarView = [[YMCustomCanlendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,0)];
        _calendarView.height = _calendarView.viewHeight;
        _calendarView.delegate = self;
//        view.tag = 101;
  
    }
    return _calendarView;
}

#pragma mark - actions

- (void)rightItemDidClicked{
    
   NSString *nowStr = [[YMClockManager shareManager] getNowDay];
    
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDay = [formatter dateFromString:nowStr];
    NSDate *remindDay = [formatter dateFromString:self.calendarView.selectDayStr];
    
    NSTimeInterval interval = [remindDay timeIntervalSinceDate:nowDay];
    if (interval >= 0) {
        
        
    }else{
        NSTimeInterval seconds = [[YMClockManager shareManager] getSecondsWithClockTime:self.clockTime];
        if (seconds <=0) {
            [HUDUtils showHUDToast:LOCALIZED(@"不能小于当前时间")];
            return;
        }
        [HUDUtils showHUDToast:LOCALIZED(@"不能小于当前日期")];
        return;
    }
    
    BOOL isUploadData = NO;
    if (self.isOpenClock) {
        if ([self.content.remindId integerValue] > 0) {//修改
            isUploadData = YES; 
        }else{
            
            if (self.clockTime.length > 0) {//新增
                isUploadData = YES;
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
        
        YMTimerRemindMode *content = [[YMTimerRemindMode alloc] init];
        //content.userId = @"1";
        content.remindTitle = self.remindTitle;
        content.remindBellId = self.bellStr;
        content.remindTime =  self.clockTime;
        content.remindShake = self.isOpenShake;
        content.remindPeriod = self.calendarView.selectDayStr ? self.calendarView.selectDayStr : @"";
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    }
    
        
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (NSString *)getStrWithTimeStr:(NSString *)str{
//    NSMutableString *mStr = [NSMutableString string];
//    
//    if ([str hasPrefix:@"上午"] ) {
//        [mStr appendString:[str substringFromIndex:2]];
//    }else if ([str hasPrefix:@"下午"]){
//        
//        NSString *time = [str substringFromIndex:2];
//        NSArray *tArr = [time componentsSeparatedByString:@":"];
//        NSInteger hour = [tArr[0] integerValue]  < 12 ? [tArr[0] integerValue] + 12 : [tArr[0] integerValue];
//        NSString *s = [NSString stringWithFormat:@"%ld:%@",hour,tArr[1]];
//        [mStr appendString:s];
//    }    return mStr;
//}

//- (NSString *)getPickerTimeStrWithLabelText:(NSString *)timeStr{
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
    return 4;
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
        
        for (UIView *suv in cell.contentView.subviews) {
            [suv removeFromSuperview];
        }
        if (self.content) {
            self.calendarView.remindDayStr = self.content.remindPeriod;
        }

        [cell.contentView addSubview:[self calendarView]];
        
        return cell;
    }
    
    
    YMClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClockCellID"];
    
    if (cell == nil) {
        cell = [[YMClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClockCellID"];
    }
    
    
    if (indexPath.section != 1 && indexPath.section !=2) {
        if (indexPath.row == arr.count -1) {
            cell.lineView.hidden = YES;
        }
    }
    
    cell.tlabel.text = arr[indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            for (UIView *subView in cell.contentView.subviews) {
                if ([subView isKindOfClass:[UIImageView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
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
    
//        cell.cLabel.textColor = [UIColor blueColor];
        cell.cLabel.text = self.clockTime;
        
    }else if (indexPath.section == 3){
        if (indexPath.row ==0) {
            
            cell.cLabel.hidden = YES;
            cell.switchView.on = self.isOpenShake;
            [cell.switchView addTarget:self action:@selector(shakeSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.hidden = NO;
            cell.switchView.hidden = YES;
            cell.cLabel.text =self.bellStr;
            cell.rightImgName = @"箭头-右";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        self.calendarView.height = self.calendarView.viewHeight;
        return self.calendarView.viewHeight;
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
    
    if (indexPath.section == 0 && indexPath.row == 1) {//标题
        
        YMRemindTitleViewController *vc = [[YMRemindTitleViewController alloc] init];
        vc.delegate = self;
        //        vc.showButtons = NO;
        vc.remindTitle = self.remindTitle;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1) {//
        
        
    }else if (indexPath.section == 2) {//
        
        self.pickerView.dataType = UserDataTypeDate;
        [self.pickerView show];
        [self.pickerView reloadPickerViewWithContent:[[YMClockManager shareManager] getTimeWith24HourTimeStr:self.clockTime]];
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
        
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
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YMCustomCalenderViewDelegate

- (void)refreshCellHeight{

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - pickerView

- (void)selectedComponentInPickerViewWithcontent:(NSString *)content{

    YMClockCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    self.clockTime = [[YMClockManager shareManager] getTimeWith12HourTimeStr:content];
    cell.cLabel.text = self.clockTime;
}

- (NSString *)getTimeStrWithPickerContent:(NSString *)content{
    
    NSMutableString  *mStr = [NSMutableString string];
    
    if ([content hasPrefix:@"上午"]) {
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

#pragma  mark - localnotification

- (void)addLocalNotification{
    
//    NSString *notificationID = [NSString stringWithFormat:@"%@",self.navigationTitle];//吃药  周一 第一次
//    NSString *notificationName = [NSString stringWithFormat:@"%@Name",notificationID];
//    NSDictionary *useInfo =@{notificationID:notificationName};
//    
//    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
//    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    NSString *cStr = [NSString stringWithFormat:@"%@ %@:00",self.calendarView.selectDayStr,self.clockTime];
//    NSDate *clockDate = [dateFomatter dateFromString:cStr];
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:clockDate];
//    
//    
//    
//    NSDate *fireDate = [[NSDate date] dateByAddingTimeInterval:interval];
    
    [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navigationTitle remindTitle:self.remindTitle weekDay:self.calendarView.selectDayStr clockTime:self.clockTime RepeatInterval:0];
    
}

- (void)cancelLocalNotification{
    
    [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navigationTitle remindTitle:self.remindTitle weekDay:self.calendarView.selectDayStr clockTime:self.clockTime];

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
