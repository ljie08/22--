//
//  EmptyDataSetType.h
//  Applications
//
//  Created by ZZY on 16/4/8.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#ifndef EmptyDataSetType_h
#define EmptyDataSetType_h


typedef NS_ENUM(NSInteger, EmptyDataSetType) {
    
    EmptyDataSetTypeUndefined = 0,          //无默认
    
    EmptyDataSetTypeDefault  = 1,           //默认(居中)
    
    EmptyDataSetTypeDefaultDown,            //默认(偏下)
    
    EmptyDataSetTypeLoading,                //加载
    
    EmptyDataSetTypeNoWifi,                 //无网络
    
    EmptyDataSetTypeListShow,               //列表
    
    EmptyDataSetTypeMessageShow,
    
    ApplicationCount // Used for count (27)
};




#endif /* EmptyDataSetType_h */
