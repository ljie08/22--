//
//  YMBellViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMBellViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YMBellCell.h"

@interface YMBellViewController ()

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSArray     *bellsArray;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation YMBellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitle = @"铃声";
    self.isHideNavigationBack = NO;
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"吉他声",@"蝉鸣",@"火车滴滴",@"滴滴滴",@"轻音乐", nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"clock.mp3" ofType:nil];
    self.bellsArray = [NSArray arrayWithObjects:filePath,filePath,filePath,filePath,filePath, nil];
}

- (void)navigationBackClick{

    if ([self.delegate respondsToSelector:@selector(didSelectBellName:)]) {
        [self.delegate didSelectBellName:self.dataSource[self.selectIndexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YMBellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BellCellID"];
    if (cell == nil) {
        cell = [[YMBellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BellCellID"];
    }
    
    cell.text = self.dataSource[indexPath.row];
    
    if ([cell.text isEqualToString:self.bellStr]) {
        cell.isPlaying = YES;
        self.selectIndexPath = indexPath;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath != self.selectIndexPath) {
        
        YMBellCell *lastCell = [tableView cellForRowAtIndexPath:self.selectIndexPath];
        lastCell.isPlaying = NO;
        
        YMBellCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        cell.isPlaying = YES;
        self.selectIndexPath = indexPath;
        
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.bellsArray[indexPath.row]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];

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
