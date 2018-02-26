//
//  YMTimerRemindPluseViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/29.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMTimerRemindPluseViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YMRemindTitleViewController.h"
#import "YMBellViewController.h"

#import "YMClockCell.h"
#import "YMTimerAddCell.h"
#import "YMPickerView.h"
#import "YMClockManager.h"

#import "YMTimerRemindMode.h"
#import "RemindDataManager.h"

#define YMOnceDay  @"Once"
#define YMDays     @"Days"
#define YMWeekDay  @"WeekDay"
#define YMEveryDay @"EveryDay"

#define YMWeekDayTag        107
#define YMEveryDayTag       108

@interface YMTimerRemindPluseViewController ()<YMPickerViewDelegate,YMRemindTitleViewControllerDeleagate,YMBellViewControllerDelegate>

@property (nonatomic, strong) YMPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray      *titleArr;
@property (nonatomic, strong) NSArray             *timeCountArr;//每次提醒次数文字
@property (nonatomic, strong) NSMutableArray      *timeArr;//每次提醒次数
@property (nonatomic, strong) NSMutableArray      *selectedDaysArr;
@property (nonatomic, assign) BOOL         isOpenClock;
@property (nonatomic, assign) BOOL         isOpenShake;
@property (nonatomic, assign) BOOL         isOpenWeek;//remindTitle
@property (nonatomic, copy)   NSString     *remindTitle;//标题
@property (nonatomic, copy)   NSString     *bellStr;//铃声
@property (nonatomic, strong) NSIndexPath  *selectIndexPath;

@property (nonatomic, strong) RemindDataManager *dataManger;


@end

@implementation YMTimerRemindPluseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    self.navigationTitle = self.navTitle;
    self.dataManger = [RemindDataManager manager];
//    self.tableView.frame = CGRectMake(0, 100, 200, 100);
}

- (void)initUI{
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithTitle:LOCALIZED(@"确认")];
    [rightBarItem setTitleColor:COLOR_002 forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton = rightBarItem;
    
}

- (void)setRemindType:(TimerRemindType)remindType{
    
    _remindType = remindType;
    if (_remindType == kTimerRemindPluse){
        
        self.navTitle = LOCALIZED(@"测脉搏");
        
    }
}

- (void)setContent:(YMTimerRemindMode *)content{
    
    _content = content;
    if (_content) {//修改
        
        self.remindType = _content.remindType;
        self.isOpenClock = YES;
        self.remindTitle = _content.remindTitle;
        NSArray *tArr = [_content.remindTime componentsSeparatedByString:@","];
        for (NSString *tStr in tArr) {
            if (tStr.length > 0) {
                [self.timeArr addObject:tStr];
            }
        }
        [self.titleArr insertObject:[self getArrWithSourceArray:self.timeCountArr andCount:self.timeArr.count] atIndex:1];
        self.isOpenShake = _content.remindShake;
        self.bellStr = _content.remindBellId;
        if (_content.remindPeriod.length > 0 ) {
            [self.selectedDaysArr addObjectsFromArray:[_content.remindPeriod componentsSeparatedByString:@","]];
            self.isOpenWeek = YES;
        }
        
    }else{//新增
        
        NSArray *arr = [NSArray arrayWithArray:[self getArrWithSourceArray:self.timeCountArr andCount:3]];
        [self.titleArr insertObject:arr atIndex:1];
        
        [self.timeArr addObject:@"09:00"];
        [self.timeArr addObject:@"15:00"];
        [self.timeArr addObject:@"21:00"];
        
        self.remindTitle = self.navTitle;
        self.bellStr = @"吉他声";
    }
    [self.tableView reloadData];
    
}

- (NSString *)getTimeStrWithRemindStr:(NSString *)remindStr{
    
    if (remindStr.length <= 0) {
        return @"";
    }
    
    NSMutableString *mStr = [NSMutableString string];
    NSArray *timeArr = [remindStr componentsSeparatedByString:@":"];
    if ([timeArr[0] integerValue] >= 12) {
        NSInteger hour = [timeArr[0] integerValue] > 12 ? [timeArr[0] integerValue] - 12 : [timeArr[0] integerValue];
        [mStr appendString:@"下午"];
        if (hour < 10) {
            [mStr appendString:@"0"];
        }
        [mStr appendString:[NSString stringWithFormat:@"%ld",hour]];
        [mStr appendString:@":"];
        [mStr appendString:timeArr[1]];
    }else{
        [mStr appendString:@"上午"];
        [mStr appendString:remindStr];
    }
    
    return  mStr;
    
}

- (NSArray *)getArrWithSourceArray:(NSArray *)sArr andCount:(NSInteger)count{
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        NSString *str = sArr[i];
        [mArr addObject:str];
    }
    
    return mArr;
}
#pragma mark - getters 

- (NSMutableArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@[LOCALIZED(@"闹钟开关"),LOCALIZED(@"标题")],@[LOCALIZED(@"震动")],@[LOCALIZED(@"周期")],nil];

//        _titleArr = [NSMutableArray arrayWithObjects:@[@"闹钟开关",@"标题"],@[@"震动"],@[@"周期"],nil];
    }
    return _titleArr;
}

- (NSMutableArray *)timeArr{
    
    if (!_timeArr) {
        _timeArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _timeArr;
}

- (NSMutableArray *)selectedDaysArr{
    
    if (!_selectedDaysArr) {
        
        _selectedDaysArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedDaysArr;
}

- (NSArray *)timeCountArr{
    
    if (!_timeCountArr) {
        _timeCountArr = [NSArray arrayWithObjects:LOCALIZED(@"第一次"),LOCALIZED(@"第二次"),LOCALIZED(@"第三次"),LOCALIZED(@"第四次"),LOCALIZED(@"第五次"),LOCALIZED(@"第六次"), nil];

//        _timeCountArr = [NSArray arrayWithObjects:@"第一次",@"第二次",@"第三次",@"第四次",@"第五次",@"第六次", nil];
        
    }
    return _timeCountArr;
}

#pragma mark - actions

- (void)rightItemDidClicked{
    
    BOOL isUploadData = NO;
    
    if (self.isOpenClock) {
        if ([self.content.remindId integerValue] > 0) {//修改
            isUploadData = YES;
        }else{
            
            if ([self getStrWithArray:self.timeArr].length > 0) {//新增
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
        content.remindTitle = self.remindTitle;
        content.remindBellId = self.bellStr;
        content.remindTime = [self getStrWithArray:self.timeArr];
        content.remindShake = self.isOpenShake;
        if (self.isOpenWeek && self.selectedDaysArr.count > 0) {
            content.remindPeriod = [self getDayStrWithArray:self.selectedDaysArr];
        }
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

- (NSString *)getStrWithArray:(NSArray *)array{
    NSMutableString *mStr = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i++) {
            
            [mStr appendString:array[i]];
        
        if (i != array.count - 1) {
            [mStr appendString:@","];
        }
    }
    return mStr;
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

//周期
- (void)cycleSwitchDidClicked:(UISwitch *)sw{
    
    self.isOpenWeek = sw.isOn;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)timebtnDidClicked:(UIGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    
    self.selectIndexPath = [NSIndexPath indexPathForRow:tap.view.tag - 300 inSection:1];
    self.pickerView.dataType = UserDataTypeDate;
    [self.pickerView  show];
    [self.pickerView reloadPickerViewWithContent:[[YMClockManager shareManager] getTimeWith24HourTimeStr:label.text]];
}


- (void)deletebtnDidClicked:(UIGestureRecognizer *)tap{
    
    HMAlertView *alertView = [[HMAlertView alloc]initWithTitle:LOCALIZED(@"定时提醒") andMessage:LOCALIZED(@"删除此次闹钟？")];
    [alertView addButtonWithTitle:LOCALIZED(@"取消") type:HMAlertViewButtonTypeCancel handler:^(HMAlertView *alertView) {
        
    }];
    [alertView addButtonWithTitle:LOCALIZED(@"确定") type:HMAlertViewButtonTypeDestructive handler:^(HMAlertView *alertView) {
        NSInteger row = tap.view.tag - 200;
        [self.timeArr removeObjectAtIndex:row];
        [self.titleArr replaceObjectAtIndex:1 withObject:[self getArrWithSourceArray:self.timeCountArr andCount:self.timeArr.count]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    [alertView show];
    
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
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
                }
                [self addSelectedDaysWithTag:btn.tag];
            }else  if (btn.tag == 107) {//先取消每天，再选中工作日
                if ([self isSelectedDayWithTag:105]) {
                    [self removeSelectDaysWithTag:105 cancelOtherDays:NO];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
                if ([self isSelectedDayWithTag:106]) {
                    [self removeSelectDaysWithTag:106 cancelOtherDays:NO];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
                if ([self isSelectedDayWithTag:108]) {
                    [self removeSelectDaysWithTag:108 cancelOtherDays:YES];
                }
                
                [self addSelectedDaysWithTag:btn.tag];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
                
            }else  if (btn.tag == 108 && [self isSelectedDayWithTag:107]) {
                [self removeSelectDaysWithTag:107 cancelOtherDays:YES];
                [self addSelectedDaysWithTag:btn.tag];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
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
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }else if (tag == 108){
        
        for (NSInteger i = 0; i < 7; i++) {
            [self.selectedDaysArr addObject:[NSNumber numberWithInteger:i]];//添加周一至周日
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
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
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }else if (tag == 108){
        
        if (cancel) {
            for (NSInteger i = 0; i < 7; i++) {
                [self.selectedDaysArr removeObject:[NSNumber numberWithInteger:i]];//取消周一至周五
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        
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
    
    NSArray *arr = self.titleArr[section];
    
    if (section == 1) {
        return arr.count + 1;
    }else if (section == 3){
        
        if (self.isOpenWeek) {
            return 3;
        }
    }
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = self.titleArr[indexPath.section];
    
    if (indexPath.section == 1) {//定时
        if (indexPath.row < arr.count) {
            YMTimerAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timerAddCellID"];
            if (cell == nil) {
                cell = [[YMTimerAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timerAddCellID"];
            }
            cell.tlabel.text = arr[indexPath.row];
            cell.cLabel.text = self.timeArr[indexPath.row];
            cell.rightImgView.tag = 200 + indexPath.row;
            cell.cLabel.tag = 300 + indexPath.row;
            UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timebtnDidClicked:)];
            [cell.cLabel addGestureRecognizer:tap0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletebtnDidClicked:)];
            [cell.rightImgView addGestureRecognizer:tap];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IncreaseCellID"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IncreaseCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = CLEARCOLOR;
                cell.userInteractionEnabled = YES;
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
                [cell.contentView addSubview:bgView];
            }
            UIImage *img = IMGNAME(@"increase");
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            imgView.left = (SCREEN_WIDTH - 80)/2.0;
            imgView.centerY = 25;
            [cell.contentView addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 5, 0,150, 50)];
            label.backgroundColor = CLEARCOLOR;
            label.textColor = COLOR_002;
            label.font = FONTSIZE(14);
            label.text = LOCALIZED(@"增加一次");
            [cell.contentView addSubview:label];
            
            return cell;
        }
    }
    
    
    if (indexPath.section == 3 && indexPath.row != 0) {//一周
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
//        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
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
    
    
    YMClockCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[YMClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClockCellID"];
    }
    
    cell.lineView.hidden = YES;

//    if (indexPath.section != 1 && indexPath.section !=3) {
//        if (indexPath.row == arr.count -1) {
//            cell.lineView.hidden = YES;
//        }
//    }
    
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
    }else if (indexPath.section == 2){
        if (indexPath.row ==0) {
            
            cell.switchView.on = self.isOpenShake;
            [cell.switchView addTarget:self action:@selector(shakeSwitchDidClicked:) forControlEvents:UIControlEventValueChanged];
        }else{
            
            cell.switchView.hidden = YES;
            cell.cLabel.text =self.bellStr;
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
    
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = self.titleArr[indexPath.section];
    if (indexPath.section == 0 && indexPath.row == 1) {//标题
        
        YMRemindTitleViewController *vc = [[YMRemindTitleViewController alloc] init];
        vc.delegate = self;
//        vc.showButtons = NO;
        vc.remindTitle = self.remindTitle;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1) {//添加时间
        if (indexPath.row < arr.count) {
            //            self.pickerView.dataType = UserDataTypeDate;
            //            [self.pickerView  show];
        }else{
            
            if (self.timeArr.count >= 6) {
                [HUDUtils showHUDToast:LOCALIZED(@"至多设置6个闹钟")];
            }else{
                [self.titleArr replaceObjectAtIndex:1 withObject:[self getArrWithSourceArray:self.timeCountArr andCount:self.timeArr.count + 1]];
                [self.timeArr addObject:[[YMClockManager shareManager] getCurrentTimeBy24Hours]];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        YMBellViewController *vc = [[YMBellViewController alloc] init];
        vc.delegate = self;
        vc.bellStr = self.bellStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (YMPickerView *)pickerView{
    
    if (!_pickerView) {
        
        _pickerView = [[YMPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
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

#pragma mark - pickerView

- (void)selectedComponentInPickerViewWithcontent:(NSString *)content{
    
   if (self.pickerView.dataType == UserDataTypeDate){
        [self.timeArr addObject:content];
        YMClockCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
        cell.cLabel.text = [[YMClockManager shareManager] getTimeWith12HourTimeStr:content];
        
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

#pragma  mark - localnotification

- (void)addLocalNotification{
    // 类型 + 标题 + 周期(周一) + 时间
    //1 只响一次
    //2 不固定日期
    //3 工作日
    //4 每天
    
    if (!self.isOpenWeek || self.selectedDaysArr.count<= 0) {
        
        for (NSInteger i = 0; i < self.timeArr.count; i ++) {
            [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:@"" clockTime:self.timeArr[i] RepeatInterval:0];
        }
        
    }else{
        
        
        if (![self isSelectedDayWithTag:YMWeekDayTag] && ![self isSelectedDayWithTag:YMEveryDayTag]) {
            for (NSInteger weekDay = 0; weekDay < self.selectedDaysArr.count; weekDay ++) {
                
                for (NSInteger i = 0; i < self.timeArr.count; i ++){
                    [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.timeArr[i] RepeatInterval:NSCalendarUnitWeekOfYear];
                    
                }
            }
        }else if ([self isSelectedDayWithTag:YMWeekDayTag]){
            for (NSInteger weekDay = 0; weekDay < 5; weekDay ++) {
                
                for (NSInteger i = 0; i < self.timeArr.count; i ++){
                    
                    [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.timeArr[i] RepeatInterval:NSCalendarUnitWeekOfYear];
                }
            }
            
        }else if([self isSelectedDayWithTag:YMEveryDayTag]){
            
            for (NSInteger weekDay = 0; weekDay < 7; weekDay ++) {
                
                for (NSInteger i = 0; i < self.timeArr.count; i ++){
                    
                    [[YMClockManager shareManager] addLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.timeArr[i] RepeatInterval:NSCalendarUnitWeekOfYear];
                    
                }
            }
            
        }
        
    }
}

- (void)cancelLocalNotification{
    
    if (_content.remindPeriod.length > 0) {
        NSArray *sArr = [_content.remindPeriod componentsSeparatedByString:@","];
        
        if (sArr.count > 0 ) {
            for (NSInteger weekDay = 0; weekDay < sArr.count; weekDay ++) {
                
                for (NSInteger i = 0; i < self.timeArr.count; i ++){
                    
                    [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:[NSString stringWithFormat:@"%ld",[self.selectedDaysArr[weekDay] integerValue]] clockTime:self.timeArr[i]];
                    
                }
            }
        }
        
    }else{//单次
        
        if (_content.remindTime.length > 0) {
            NSArray *timeArr = [_content.remindTime componentsSeparatedByString:@";"];
            
            for (NSInteger i = 0; i < timeArr.count; i ++) {
                NSString *str = timeArr [i];
                if (str.length > 0) {
                [[YMClockManager shareManager] cancelLocalNotificationWithNavTitle:self.navTitle remindTitle:self.remindTitle weekDay:@"" clockTime:self.timeArr[i]];
                    
                }
            }
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
