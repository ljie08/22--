//
//  EmptyDataSet.m
//  Applications
//
//  Created by ZZY on 16/4/8.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import "EmptyDataSet.h"

@interface EmptyDataSet ()

@property (nonatomic) EmptyDataSetType type;

@property (nonatomic, strong) NSString *titleText;

@end

@implementation EmptyDataSet


- (instancetype)initWithEmptyDataSetType:(EmptyDataSetType)type
{
    return [self initWithEmptyDataSetType:type WithTitleText:@""];
}

- (instancetype)initWithEmptyDataSetType:(EmptyDataSetType)type WithTitleText:(NSString*)titleText
{
    self = [super init];
    if (self) {
        self.titleText = titleText;
        self.type = type;
    }
    return self;
}

- (void)setType:(EmptyDataSetType)type {
    
    if (_type != type) {
        _type = type;
        
        self.displayTitle   = [[EmptyDataSetTitle alloc] init];
        self.displayDetail  = [[EmptyDataSetDetail alloc] init];
        
        
        switch (_type) {
            case EmptyDataSetTypeUndefined:
            {
                self.iconName      = @"";
            }
                break;
            case EmptyDataSetTypeDefault:
            {
                self.iconName      = @"contentview_Default";
            }
                break;
            case EmptyDataSetTypeDefaultDown:
            {
                self.verticalOffset   = 100;
                
                self.iconName      = @"contentview_Default";
            }
                break;
            case EmptyDataSetTypeLoading:
            {
                _displayTitle.TitleText = @"加载中...";
                _displayTitle.TitleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
                _displayTitle.TitleTextColor = [UIColor grayColor];
                
                self.spaceHeight   = 5;
                
                self.displayBackColor = [UIColor clearColor];
            }
                break;
            case EmptyDataSetTypeNoWifi:
            {
                
                _displayTitle.TitleText = @"请求网络失败";
                _displayTitle.TitleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
                _displayTitle.TitleTextColor = [UIColor grayColor];
                
                _displayDetail.DetailText = @"请检查您的手机网络设置";
                _displayDetail.DetailFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
                _displayDetail.DetailTextColor = [UIColor lightGrayColor];
                _displayDetail.DetailLineSpacing = 4.0f;
                
                self.displayBackColor = [UIColor whiteColor];
                self.iconName      = @"placeholder_remote";
                self.spaceHeight   = 10;
            }
                break;
            case EmptyDataSetTypeListShow:
            {
                _displayDetail.DetailText = self.titleText;
                _displayDetail.DetailFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
                _displayDetail.DetailTextColor = [UIColor lightGrayColor];
                _displayDetail.DetailLineSpacing = 10.0f;
                
                self.displayBackColor = [UIColor whiteColor];
                self.iconName      = @"contentview_List";
                self.spaceHeight   = 10;
            }
                break;
            case EmptyDataSetTypeMessageShow:
            {
                _displayDetail.DetailText = @"没有消息记录";
                _displayDetail.DetailFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
                _displayDetail.DetailTextColor = [UIColor lightGrayColor];
                _displayDetail.DetailLineSpacing = 10.0f;
                
                self.displayBackColor = [UIColor whiteColor];
                self.iconName      = @"contentview_Info";
                self.spaceHeight   = 10;
            }
                break;
            default:
                break;
        }
        
    }
    
}

@end



@implementation EmptyDataSetTitle



@end





@implementation EmptyDataSetDetail


@end









