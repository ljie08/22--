//
//  YMClockViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/14.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMClockViewController.h"
#import "YMBellViewController.h"
#import "YMRemindTitleViewController.h"
#import "YMPickerView.h"
#import "YMClockCell.h"
#import <AudioToolbox/AudioToolbox.h>
//#import <UserNotifications/UserNotifications.h>
#import "YMClockManager.h"
#import "YMTimerRemindMode.h"
#import "YMCLockMode.h"
#import "RemindDataManager.h"

#define YMClockStatus         @"YMClockSwitchStatus"
#define YMShakeAndWeekStatus  @"YMYMShakeAndWeekStatus"
#define YMClockTimeBellWeek   @"YMClockTimeBellWeek"

#define YMLocalNotificationOnceDayID  @"YMLocalNotificationOnceDayID"
#define YMLocalNotificationDaysID     @"YMLocalNotificationDaysID"
#define YMLocalNotificationWeekDayID  @"YMLocalNotificationWeekDayID"
#define YMLocalNotificationEveryDayID @"YMLocalNotificationEveryDayID"

#define YMOnceDay  @"Once"
#define YMDays     @"Days"
#define YMWeekDay  @"WeekDay"
#define YMEveryDay @"EveryDay"

#define YMWeekDayTag        107
#define YMEveryDayTag       108

#define kDayConvertSecond     24*3600
#define kHourConvertSecond    3600
#define kMinuteConvertSecond  60


@interface YMClockViewController ()<YMPickerViewDelegate,YMBellViewControllerDelegate,YMRemindTitleViewControllerDeleagate>

@property (nonatomic, strong) YMPickerView *pickerView;
@property (nonatomic, strong) NSArray      *titleArr;
@property (nonatomic, strong) NSMutableArray      *selectedDaysArr;
@property (nonatomic, copy)   NSString     *clockTime;//闹钟定时
@property (nonatomic, copy)   NSString     *bellStr;//铃声
@property (nonatomic, assign) BOOL         isOpenClock;
@property (nonatomic, assign) BOOL         isOpenVoice;
@property (nonatomic, assign) BOOL         isOpenShake;
@property (nonatomic, assign) BOOL         isOpenWeek;
@property (nonatomic, assign) BOOL         isShowTitle;
@property (nonatomic, strong) NSString *remindTitle;//标题
@property (nonatomic, copy)   NSString *navTitle;
@property (nonatomic, strong) RemindDataManager *dataManger;


@end

@implementation YMClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitle = self.navTitle;
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithTitle:LOCALIZED(@"确认")];
    [rightBarItem setTitleColor:COLOR_002 forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton   = rightBarItem;
    
    self.dataManger = [RemindDataManager manager];
}

- (void)setRemindType:(TimerRemindType)remindType{
    
    _remindType = remindType;
    if (_remindType == kTimerRemindCure) {
        self.navTitle = LOCALIZED(@"理疗");
        self.isShowTitle = YES;

    }else if (_remindType == kTimerRemindSport){
        
        self.navTitle = LOCALIZED(@"运动");
        self.isShowTitle = YES;

    }else if (_remindType == kTimerRemindSleep){
        
        self.navTitle = LOCALIZED(@"睡眠");
        
    }else {
    
        self.navTitle = LOCALIZED(@"闹钟");
    }
}

- (void)setContent:(YMTimerRemindMode *)content{
    
    _content = content;
    if (_content) {//修改
        
        self.remindType = _content.remindType;
        self.isOpenClock = YES;
        self.remindTitle = _content.remindTitle;
        self.clockTime = _content.remindTime;
        self.isOpenShake =_content.remindShake;
        self.bellStr = _content.remindBellId;
        if (_content.remindPeriod.length > 0 ) {
            
            NSArray *arr = [_content.remindPeriod componentsSeparatedByString:@","];
            [self.selectedDaysArr addObjectsFromArray:arr];
            self.isOpenWeek = YES;

            if (arr.count >= 7) {//每天
                
                [self.selectedDaysArr addObject:@(8)];
            }else if (arr.count >=5){
                
                if ([arr indexOfObject:@(0)] == NSNotFound && [arr indexOfObject:@(6)] == NSNotFound) {
                    [self.selectedDaysArr addObject:@(7)];
                }
            }
        }
        
    } else {//新增
        
        if (self.remindType == kTimerRemindSleep || self.remindType == 0) {//闹钟或者睡眠
            [self getData];
        }
        
        if (self.clockTime.length <=0) {
            self.clockTime = [[YMClockManager shareManager] getCurrentTimeBy24Hours];
        }
        self.bellStr = @"吉他声";
        self.remindTitle = self.navTitle;
    }
    [self.tableView reloadData];
    
}

#pragma mark - getters

- (NSArray *)titleArr{

    if (!_titleArr) {
        
        if (self.isShowTitle) {
            _titleArr = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"闹钟开关"),LOCALIZED(@"标题")],@[LOCALIZED(@"闹钟定时"),LOCALIZED(@"震动")],@[LOCALIZED(@"周期")],nil];

        } else {
            _titleArr = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"闹钟开关")],@[LOCALIZED(@"闹钟定时"),LOCALIZED(@"震动")],@[LOCALIZED(@"周期")],nil];

        }
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

- (NSMutableArray *)selectedDaysArr{

    if (!_selectedDaysArr) {
        
        _selectedDaysArr = [[NSMutableArray alloc] init];
    }
    return _selectedDaysArr;
}

#pragma mark -actions

- (void)navigationBackClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemDidClicked{
    
    [self saveTimerRemindData];   
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveTimerRemindData{

    YMTimerRemindMode *content = [[YMTimerRemindMode alloc] init];
    content.remindTitle = self.remindTitle;
    content.remindBellId = self.bellStr;
    content.remindTime = self.clockTime;
    content.remindShake = self.isOpenShake;
    if (self.isOpenWeek && self.selectedDaysArr.count > 0) {
        content.remindPeriod = [self getDayStrWithArray:self.selectedDaysArr];
    }
    content.remindStatus = [NSString stringWithFormat:@"%d",self.isOpenClock];
    content.remindType = self.remindType > 0 ? self.remindType : kTimerRemindSleep;//闹钟为睡眠
    NSString *remindId = self.content.remindId.length>0 ? self.content.remindId:[[YMClockManager shareManager]getCurrentTimeString];
    content.remindId = remindId;
    if (self.content) {
        [self cancelNotification];
        [self.dataManger updateLocalRemindData:content];
    }else{
        [self.dataManger insertRemindData:content];
    }
    
    [self addNotification];//添加本地推送
    [HUDUtils showHUDToast:LOCALIZED(@"设置成功")];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}

- (NSString *)getTimeStrWithClockTime:(NSString *)content{
    
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

- (NSString *)getDayStrWithArray:(NSArray *)array{
    
    NSMutableString *mStr = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i++) {
        
        if ([self isSelectedDayWithTag:107]) {//工作日
            
            [mStr appendString:@"1,2,3,4,5"];
            
            return mStr;
        }else if ([self isSelectedDayWithTag:108]) {//每天
            [mStr appendString:@"0,1,2,3,4,5,6"];
            return mStr;
        }
        
        NSString *str = array[i];
        if ([str integerValue] == 6) {//周日
            [mStr appendFormat:@"0"];
        }
        
        [mStr appendFormat:@"%ld",[str integerValue] + 1];
        
        if (i != array.count - 1) {
            [mStr appendString:@","];
        }
    }
    return mStr;
}

- (void)saveClockData{

    BOOL lastOpenClock = false;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YMClockStatus]) {
        
        lastOpenClock = [[NSUserDefaults standardUserDefaults] boolForKey:YMClockStatus];
    }
    
    //1 添加通知或者关闭通知
    if (self.isOpenClock) {
        //假如之前存在通知，关闭，再重新添加
        if (lastOpenClock) {
            
            [self cancelLocalNotification];
        }
        
        [self addLocalNotification];
        
    }else{
        //假如之前存在通知，关闭
        if (lastOpenClock) {
            
            [self cancelLocalNotification];
        }
    }
    
    if (!self.isOpenClock) {
        self.clockTime = @"";
        self.isOpenShake = NO;
        self.isOpenWeek = NO;
        [self.selectedDaysArr removeAllObjects];
        [self removeClockData];
    }
    //2 存储
    [self saveData];

    if ([self.delegate respondsToSelector:@selector(didSelectedClockTime:)]) {
        [self.delegate didSelectedClockTime:self.clockTime];
    }
}

//闹钟
- (void)clockSwitchDidClicked:(UISwitch *)sw{

    self.isOpenClock = sw.isOn;
    [self.tableView reloadData];
}

- (void)voiceSwitchDidClicked:(UISwitch *)sw{

    self.isOpenVoice = sw.isOn;

}

//震动
- (void)shakeSwitchDidClicked:(UISwitch *)sw{

    self.isOpenShake = sw.isOn;
    
    if (self.isOpenShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

//周期
- (void)cycleSwitchDidClicked:(UISwitch *)sw{

    self.isOpenWeek = sw.isOn;
    if (!self.isOpenWeek) {
        [self.selectedDaysArr removeAllObjects];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    
}

//日期选择按钮
- (void)dayBtnDidClicked:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    NSNumber *day = [NSNumber numberWithInteger:btn.tag - 100];
    NSArray *sArr = [NSArray arrayWithArray:self.selectedDaysArr];
    
    if (btn.selected) {
        
        if ([sArr indexOfObject:day] == NSNotFound) {
            if (btn.tag >= 104 && btn.tag <= 106) {//六 日
                
                if ([self isSelectedDayWithTag:107]) {//取消工作日按钮
                    [self removeSelectDaysWithTag:107 cancelOtherDays:NO];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
                }
                [self addSelectedDaysWithTag:btn.tag];
            }else  if (btn.tag == 107) {//先取消每天，再选中工作日
                if ([self isSelectedDayWithTag:105]) {
                    [self removeSelectDaysWithTag:105 cancelOtherDays:NO];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
                }
                if ([self isSelectedDayWithTag:106]) {
                    [self removeSelectDaysWithTag:106 cancelOtherDays:NO];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];

                }
                if ([self isSelectedDayWithTag:108]) {
                    [self removeSelectDaysWithTag:108 cancelOtherDays:YES];
                }
                
                [self addSelectedDaysWithTag:btn.tag];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];

            }else  if (btn.tag == 108 && [self isSelectedDayWithTag:107]) {
                [self removeSelectDaysWithTag:107 cancelOtherDays:YES];
                [self addSelectedDaysWithTag:btn.tag];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
            
                [self addSelectedDaysWithTag:btn.tag];

            }
        }
    }else{
    
        if ([sArr indexOfObject:day] != NSNotFound) {
            
            if (btn.tag <= 104) {
                if ([self isSelectedDayWithTag:107]) {
                    [self removeSelectDaysWithTag:107 cancelOtherDays:NO];
                }
                
                if ([self isSelectedDayWithTag:108]) {
                    [self removeSelectDaysWithTag:108 cancelOtherDays:NO];
                }
                [self removeSelectDaysWithTag:btn.tag cancelOtherDays:NO];

            }else if (btn.tag > 104 && btn.tag <= 106){
                
                if ([self isSelectedDayWithTag:108]) {
                    [self removeSelectDaysWithTag:108 cancelOtherDays:NO];
                }
                [self removeSelectDaysWithTag:btn.tag cancelOtherDays:NO];
            }else {
            
                [self removeSelectDaysWithTag:btn.tag cancelOtherDays:YES];
            }
            
        }
    }
}


- (BOOL)isSelectedDayWithTag:(NSInteger)tag{//是否选中工作日

    NSInteger dayNum = tag - 100;
    for (id sNum in self.selectedDaysArr ) {
        if ([sNum integerValue] == dayNum) {
            
            return YES;
        }
    }
    return NO;
    
}

- (BOOL)isSelectedDayWithTag:(NSInteger)tag andSelectArray:(NSArray *)selectedArray{//上次是否选中工作日
    
    NSInteger dayNum = tag - 100;
    for (id sNum in selectedArray ) {
        if ([sNum integerValue] == dayNum) {
            
            return YES;
        }
    }
    return NO;
    
}

- (void)addSelectedDaysWithTag:(NSInteger)tag{
    if (tag == 107) {
        
        for (NSInteger i = 0; i < 5; i++) {
            [self.selectedDaysArr addObject:[NSNumber numberWithInteger:i]];//添加周一至周五
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }else if (tag == 108){
    
        for (NSInteger i = 0; i < 7; i++) {
            [self.selectedDaysArr addObject:[NSNumber numberWithInteger:i]];//添加周一至周日
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self.selectedDaysArr addObject:[NSNumber numberWithInteger:tag - 100]];

}

- (void)removeSelectDaysWithTag:(NSInteger)tag cancelOtherDays:(BOOL)cancel{

    [self.selectedDaysArr removeObject:[NSNumber numberWithInteger:tag - 100]];
    
    if (tag == 107) {
        
        if (cancel) {
            for (NSInteger i = 0; i < 5; i++) {
                [self.selectedDaysArr removeObject:[NSNumber numberWithInteger:i]];//取消周一至周五
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];

        
    }else if (tag == 108){
        
        if (cancel) {
            for (NSInteger i = 0; i < 7; i++) {
                [self.selectedDaysArr removeObject:[NSNumber numberWithInteger:i]];//取消周一至周五
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];

    }
    
}


#pragma mark - tableview

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.isOpenClock) {
        return self.titleArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (!self.isOpenClock) {
        return 1;
    }
    
    if (section == 2 && self.isOpenWeek) {
        return 3;
    }
    
    NSArray *arr = self.titleArr[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2 && indexPath.row != 0) {//一周
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DaysCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DaysCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
            cell.userInteractionEnabled = YES;
        }
        
        for (UIView *sv in cell.contentView.subviews) {
            [sv removeFromSuperview];
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//        bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        [cell.contentView addSubview:bgView];
        if (indexPath.row == 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,49, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
//            [cell.contentView addSubview:lineView];
            [cell.contentView addSubview:[self daysView]];
        }else{
        
            [cell.contentView addSubview:[self daysSettingFastView]];
        }
       
        return cell;
    }
    
    
    YMClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClockCellID"];
    
    if (cell == nil) {
        cell = [[YMClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClockCellID"];
    }
    
    NSArray *arr = self.titleArr[indexPath.section];
    
    NSInteger row = indexPath.row;
    if (self.isOpenWeek) {
        
        if (indexPath.section != 2 ) {
            
            if (arr.count - 1 == row) {
                cell.lineView.hidden = YES;
            }

        }
        
    }else{
        
        if (arr.count - 1 == row) {
            cell.lineView.hidden = YES;
        }
    }
    
    
    cell.tlabel.text = arr[indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.switchView.on = self.isOpenClock;
            [cell.switchView addTarget:self action:@selector(clockSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.text = self.remindTitle;
            cell.rightImgName = @"箭头-右";
        }
        
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            //当前时间
            cell.switchView.hidden = YES;
            cell.cLabel.text = self.clockTime;
        }else if (indexPath.row ==1) {
            
            cell.switchView.on = self.isOpenShake;
            [cell.switchView addTarget:self action:@selector(shakeSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.text = self.bellStr;
            cell.rightImgName = @"箭头-右";
        }
    }else{
        for (UIView *sub in cell.contentView.subviews) {
            if ([sub isKindOfClass:[UIImageView class]]) {
                [sub removeFromSuperview];
            }
        }
            cell.cLabel.text = nil;
            cell.switchView.hidden = NO;
            cell.switchView.on = self.isOpenWeek;
            [cell.switchView addTarget:self action:@selector(cycleSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = CLEARCOLOR;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 1) {
        YMRemindTitleViewController *vc = [[YMRemindTitleViewController alloc] init];
        vc.delegate = self;
        //        vc.showButtons = NO;
        vc.remindTitle = self.remindTitle;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {//闹钟定时
            YMClockCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.pickerView.dataType = UserDataTypeDate;
            [self.pickerView show];
            [self.pickerView reloadPickerViewWithContent:[[YMClockManager shareManager] getTimeWith24HourTimeStr:cell.cLabel.text]];
            
        }else if (indexPath.row == 2){//铃声
        
            YMBellViewController *vc = [[YMBellViewController alloc] init];
            vc.delegate = self;
            vc.bellStr = self.bellStr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

#pragma mark - YMBellViewControllerDelegate

- (void)didSelectBellName:(NSString *)bellName{
    
    self.bellStr = bellName;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - YMPickerViewDelegate

- (void)selectedComponentInPickerViewWithcontent:(NSString *)content{

    YMClockCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.clockTime = [[YMClockManager shareManager] getTimeWith12HourTimeStr:content];
    cell.cLabel.text = self.clockTime;
}


- (UIView *)daysView{

    UIView *daysView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    daysView.backgroundColor = CLEARCOLOR;

    for (UIView *sv in daysView.subviews) {
        [sv removeFromSuperview];
    }
    NSArray *arr = [NSArray arrayWithObjects:LOCALIZED(@"一"),LOCALIZED(@"二"),LOCALIZED(@"三"),LOCALIZED(@"四"),LOCALIZED(@"五"),LOCALIZED(@"六"),LOCALIZED(@"日"), nil];

//    NSArray *arr = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
    
    CGFloat space = (SCREEN_WIDTH - 25*2 - 40*7) / 6.0;
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25 + (space + 40) * i, 0 , 40, 20);
        btn.centerY = 25;
        btn.backgroundColor = CLEARCOLOR;
        btn.titleLabel.font = FONTSIZE(14);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(90, 200, 150) forState:UIControlStateSelected];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateSelected];
        btn.tag = 100 + i;
        if ([self isSelectedDayWithTag:btn.tag]) {
            btn.selected = YES;
        }
        
        [daysView addSubview:btn];
        [btn addTarget:self action:@selector(dayBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return daysView;
}

- (UIView *)daysSettingFastView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = CLEARCOLOR;
    
    for (UIView *sv in view.subviews) {
        [sv removeFromSuperview];
    }
    
//    NSArray *arr = [NSArray arrayWithObjects:@"闹钟-工作日-未选",@"闹钟-工作日-选中",@"闹钟-每天-未选",@"闹钟-每天-选中的", nil];
    NSArray *tArr = [NSArray arrayWithObjects:LOCALIZED(@"工作日"),LOCALIZED(@"工作日"),LOCALIZED(@"每天"),LOCALIZED(@"每天"), nil];

    
    CGFloat space = (SCREEN_WIDTH - 45*2 - 20*7) / 6.0;
    for (NSInteger i = 0; i < 3; i = i + 2) {
        
        NSInteger num = i > 1 ? 1 :0;
        UIImage *image = IMGNAME(@"闹钟-工作日-未选");
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(45 + (space + image.size.width + 30) * num, 0 , image.size.width + 30, image.size.height);
        btn.centerY = 25;
        btn.backgroundColor = CLEARCOLOR;
        [btn setTitle:tArr[i] forState:UIControlStateNormal];
        [btn setTitle:tArr[i + 1] forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_002 forState:UIControlStateNormal];
        [btn setTitleColor:RGB(90, 200, 150) forState:UIControlStateSelected];

//        [btn setImage:IMGNAME(arr[i]) forState:UIControlStateNormal];
//        [btn setImage:IMGNAME(arr[i+1]) forState:UIControlStateSelected];
        btn.tag = 107 + num;
        
        if ([self isSelectedDayWithTag:btn.tag]) {
            btn.selected = YES;
        }
        [view addSubview:btn];
        [btn addTarget:self action:@selector(dayBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    return view;
}

- (void)saveData{

    //闹钟
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isOpenClock] forKey:YMClockStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.isOpenClock) {
//        //震动、周期的开关状态
//        NSArray *statusArr = [NSArray arrayWithObjects:@(self.isOpenShake), @(self.isOpenWeek),nil];
//        [[NSUserDefaults standardUserDefaults]setObject:statusArr forKey:YMShakeAndWeekStatus];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        //定时、铃声、选中的day
//        
//        NSArray *Array = [NSArray arrayWithObjects:self.clockTime,self.bellStr,self.selectedDaysArr, nil];
//        [[NSUserDefaults standardUserDefaults] setObject:Array forKey:YMClockTimeBellWeek];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        YMCLockMode *content = [[YMCLockMode alloc] init];
        content.isOpenClock = self.isOpenClock;
        content.isOpenShake = self.isOpenShake;
        content.isOpenWeek = self.isOpenWeek;
        content.remindTime = self.clockTime;
        content.remindBellId = self.bellStr;
        content.remindPeriod = self.selectedDaysArr;
        
        if (self.selectedDaysArr.count > 0) {
            
            if ([self isSelectedDayWithTag:107]) {//工作日
                content.clockType = 3;
            }else if ([self isSelectedDayWithTag:108]){//每天
                content.clockType = 4;

            }else{
                content.clockType = 2;

            }
            
        }else{
        
            content.clockType = 1;
        }
        
        [[YMClockManager shareManager] saveClockData:content];
        
    }
        
}

- (void)getData{

    //闹钟
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YMClockStatus]) {
        
        self.isOpenClock = [[NSUserDefaults standardUserDefaults] boolForKey:YMClockStatus];
    }
    
    if (self.isOpenClock) {
//        //震动、周期的开关状态
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:YMShakeAndWeekStatus]) {
//            NSArray *sArray = [[NSUserDefaults standardUserDefaults] arrayForKey:YMShakeAndWeekStatus];
//            self.isOpenShake = [sArray[0] integerValue];
//            self.isOpenWeek  = [sArray[1] integerValue];
//        }
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:YMClockTimeBellWeek]) {
//            NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:YMClockTimeBellWeek];
//            if (arr.count <=0 ) {
//                return;
//            }
//            self.clockTime = arr[0];
//            self.bellStr = arr[1];
//            NSArray *array = (NSArray *)arr[2];
//            if (array.count > 0) {
//                [self.selectedDaysArr addObjectsFromArray:array];
//            }
//        }
//
//        YMCLockMode *content = [[YMClockManager shareManager] getClockData];
//         self.isOpenClock = content.isOpenClock ;
//         self.isOpenShake = content.isOpenShake;
//         self.isOpenWeek  = content.isOpenWeek;
//         self.clockTime   = content.remindTime;
//         self.bellStr     = content.remindBellId;
//        if (content.remindPeriod.count > 0) {
//            [self.selectedDaysArr addObjectsFromArray:content.remindPeriod];
//        }
        
        self.isOpenClock = [[YMClockManager shareManager] isOpenClock] ;
        self.isOpenShake = [[YMClockManager shareManager] isOpenShake];
        self.isOpenWeek  = [[YMClockManager shareManager] isOpenWeek];
        self.clockTime   = [[YMClockManager shareManager] getRemindTime];
        self.bellStr     = [[YMClockManager shareManager] getRemindBellId];
        if (self.bellStr.length <= 0) {
            self.bellStr = @"吉他声";
        }
        if ([[YMClockManager shareManager] getRemindPeriod].count > 0) {
            [self.selectedDaysArr addObjectsFromArray:[[YMClockManager shareManager] getRemindPeriod]];
        }
    }
}

- (void)removeClockData{

    [[YMClockManager shareManager] removeClockData];
}

- (void)addLocalNotification{
    //1 只响一次
    //2 不固定日期
    //3 工作日
    //4 每天
    
    NSString *title = [self.navTitle isEqualToString:@"闹钟"] ? @"睡眠" : self.navTitle;
    if (!self.isOpenWeek || self.selectedDaysArr.count<= 0) {
                
//        NSDictionary *useInfo =@{YMLocalNotificationOnceDayID:@"YMLocalNotificationOnceDay"};
////        NSDate *fireDate = [[NSDate date] dateByAddingTimeInterval:[self getNowTimeStr:[self getCurrentTime] ClockTime:self.clockTime]];
//        NSDate *fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:self.clockTime selectedDay:-1];
//        [[YMClockManager shareManager] addLocalNotificationForFireDate:fireDate forKey:YMLocalNotificationOnceDayID alertBody:@"该起床了" alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:0];
        
        [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:@"" clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];

        
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        if (notification != nil) {
//            notification.fireDate = fireDate;
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//            notification.alertBody = @"起床啦";
////            notification.repeatInterval = NSCalendarUnitDay;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            notification.userInfo = useInfo;
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
    }else{
    
        if (![self isSelectedDayWithTag:YMWeekDayTag] && ![self isSelectedDayWithTag:YMEveryDayTag]) {
            for (NSInteger i = 0; i < self.selectedDaysArr.count; i ++) {
                
//                NSString *notificationID = [NSString stringWithFormat:@"%@%ld",YMLocalNotificationDaysID,[self.selectedDaysArr[i] integerValue]];
//                NSString *notificationName = [NSString stringWithFormat:@"YMLocalNotificationDays%ld",[self.selectedDaysArr[i] integerValue]];
//                NSDictionary *useInfo =@{notificationID:notificationName};
//                
//                NSDate *fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:self.clockTime selectedDay:[self.selectedDaysArr[i] integerValue]];
//
//                
//                [[YMClockManager shareManager] addLocalNotificationForFireDate:fireDate forKey:notificationID alertBody:@"该起床了" alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:NSCalendarUnitWeekOfYear];
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[i] integerValue]] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];


            }
        }else if ([self isSelectedDayWithTag:YMWeekDayTag]){
        
//            NSDictionary *useInfo =@{YMLocalNotificationWeekDayID:@"YMLocalNotificationWeekDay"};
//            NSDate *fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:self.clockTime selectedDay:-1];
//            
//            [[YMClockManager shareManager] addLocalNotificationForFireDate:fireDate forKey:YMLocalNotificationWeekDayID alertBody:@"该起床了" alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:NSCalendarUnitWeekday];
            
            for (NSInteger i = 1; i < 6; i ++) {
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%ld",i] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];

            }



        }else if([self isSelectedDayWithTag:YMEveryDayTag]){
            
            for (NSInteger i = 0; i < 7; i ++) {
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%ld",i] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];
                
            }
        
//            NSDictionary *useInfo =@{YMLocalNotificationEveryDayID:@"YMLocalNotificationEveryDay"};
//            NSDate *fireDate = [[YMClockManager shareManager] getFireDataWithClockTime:self.clockTime selectedDay:-1];
//            [[YMClockManager shareManager] addLocalNotificationForFireDate:fireDate forKey:YMLocalNotificationEveryDayID alertBody:@"该起床了" alertAction:nil soundName:@"" userInfo:useInfo badgeCount:0 repeatInterval:NSCalendarUnitDay];

        }
    }
    
}

- (void)cancelLocalNotification{
    //上次是否开启闹钟
    BOOL lastOpenShake,lastOpenWeek = false;
    NSArray *lastSelArr;
    
//    YMCLockMode *content = [[YMClockManager shareManager] getClockData];
    lastOpenShake = [[YMClockManager shareManager] isOpenShake];
    lastOpenWeek = [[YMClockManager shareManager] isOpenWeek];
    if ([[YMClockManager shareManager] getRemindPeriod].count > 0) {
        lastSelArr = [NSArray arrayWithArray:[[YMClockManager shareManager] getRemindPeriod]];
    }
    
//    //震动、周期的开关状态
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:YMShakeAndWeekStatus]) {
//        NSArray *sArray = [[NSUserDefaults standardUserDefaults] arrayForKey:YMShakeAndWeekStatus];
//        lastOpenShake = [sArray[0] integerValue];
//        lastOpenWeek  = [sArray[1] integerValue];
//    }
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:YMClockTimeBellWeek]) {
//        NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:YMClockTimeBellWeek];
//        if (arr.count <=0 ) {
//            return;
//        }
//        
//        NSArray *array = (NSArray *)arr[2];
//        if (array.count > 0) {
//            lastSelArr = [NSArray arrayWithArray:array];
//        }
//    }

    NSString *title = [self.navTitle isEqualToString:@"闹钟"] ? @"睡眠" : self.navTitle;
    NSString *cTime = [[YMClockManager shareManager] getRemindTime];
    if (!lastOpenWeek || lastSelArr.count <= 0) {
        
        [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:@""  clockTime:cTime];

//        [[YMClockManager shareManager] cancelLocalNotificationWithKey:YMLocalNotificationOnceDayID];
        
    }else{
    
        if (![self isSelectedDayWithTag:YMWeekDayTag andSelectArray:lastSelArr] && ![self isSelectedDayWithTag:YMEveryDayTag andSelectArray:lastSelArr]) {
            if (lastSelArr.count >0) {
                for (NSInteger i = 0;i < lastSelArr.count ; i++) {
//                    keyWord = [NSString stringWithFormat:@"%@%ld",YMLocalNotificationDaysID,[lastSelArr[i] integerValue]];
//                    [[YMClockManager shareManager] cancelLocalNotificationWithKey:keyWord];
                    [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%@",lastSelArr[i]]  clockTime:cTime];

                }
            }

        }else if ([self isSelectedDayWithTag:YMWeekDayTag andSelectArray:lastSelArr]){
            for (NSInteger i = 1;i < 6 ; i++) {
                
                [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%ld",i]  clockTime:cTime];
                
            }
//            [[YMClockManager shareManager] cancelLocalNotificationWithKey:YMLocalNotificationWeekDayID];
            
        }else if([self isSelectedDayWithTag:YMEveryDayTag andSelectArray:lastSelArr]){
//            [[YMClockManager shareManager] cancelLocalNotificationWithKey:YMLocalNotificationEveryDayID];
            
            for (NSInteger i = 0;i < 7 ; i++) {
                
                [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:title remindTitle:@"" weekDay:[NSString stringWithFormat:@"%ld",i]  clockTime:cTime];
                
            }
           
        }

    }    
    
}

#pragma mark - remindTitleVC

- (void)remindTitleDidEdited:(NSString *)title{
    
    self.remindTitle = LOCALIZED(title);
    
    YMClockCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.cLabel.text = self.remindTitle;
    
}

#pragma  mark - localnotification

- (void)addNotification{

    
    NSString *title = self.navTitle;
    
    if (!self.isOpenWeek || self.selectedDaysArr.count<= 0) {
        
        [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:self.remindTitle weekDay:@"" clockTime:self.clockTime RepeatInterval:0];

    }else{
        
        
        if (![self isSelectedDayWithTag:YMWeekDayTag] && ![self isSelectedDayWithTag:YMEveryDayTag]) {
            for (NSInteger weekDay = 0; weekDay < self.selectedDaysArr.count; weekDay ++) {
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];

            }
        }else if ([self isSelectedDayWithTag:YMWeekDayTag]){
            for (NSInteger weekDay = 0; weekDay < 5; weekDay ++) {
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];

            }
            
        }else if([self isSelectedDayWithTag:YMEveryDayTag]){
            
            for (NSInteger weekDay = 0; weekDay < 7; weekDay ++) {
                
                [[YMClockManager shareManager] addLocalNotificationWithNavTitle:title remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.clockTime RepeatInterval:NSCalendarUnitWeekOfYear];

            }
            
        }
        
    }
}

- (void)cancelNotification{
    
    if (_content.remindPeriod.length > 0) {
        NSArray *sArr = [_content.remindPeriod componentsSeparatedByString:@","];
        
        if (sArr.count > 0 ) {
            for (NSInteger weekDay = 0; weekDay < sArr.count; weekDay ++) {
               
                [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:sArr[weekDay]  clockTime:self.clockTime];
            }
        }
        
    }else{//单次
        
        if (_content.remindTime.length > 0) {
            
            [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:@"" clockTime:self.clockTime];

        }
        
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
