//
//  RemindDataManager.m
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "RemindDataManager.h"
#import <FMDB.h>

@interface RemindDataManager()

@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

@property (nonatomic, strong)NSMutableDictionary *allTopicCache;//存储所有帖子
@property (nonatomic, strong)NSMutableDictionary *topicCacheForModules;//各个模块的缓存

@end

@implementation RemindDataManager

+ (RemindDataManager *)manager{
    static RemindDataManager *manager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
       
        manager = [[RemindDataManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createTables];
    }
    return self;
}

- (NSString *)dbPath
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path   = [docsPath stringByAppendingPathComponent:@"RemindDB.sqlite"];
    
    return path;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        NSString *dbPath   = [self dbPath];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return _dbQueue;
}

- (void)clearTables //清除表数据
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"drop TABLE t_remind"];//帖子实体列表
        
    }];
}

- (void)createTables{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (db) {
            BOOL result = [db executeUpdate:@"create table if not exists t_remind (remindId text,remindTitle text,remindBellId text,remindTime text,remindShake integer not null,remindPeriod text,medicineInfo text,remindType integer)"];
            if (result) {
                NSLog(@"创建提醒实体表成功");
            }
        }
    }];
}

//查询
- (NSArray *)queryRemindList{
    __block  NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
      FMResultSet *result = [db executeQuery:@"select * from t_remind"];
        while ([result next]) {
            YMTimerRemindMode *content = [[YMTimerRemindMode alloc] init];
            content.remindId = [result stringForColumn:@"remindId"];
            content.remindTitle = [result stringForColumn:@"remindTitle"];
            content.remindBellId = [result stringForColumn:@"remindBellId"];
            content.remindTime = [result stringForColumn:@"remindTime"];
            content.remindShake = [result intForColumn:@"remindShake"];
            content.remindPeriod = [result stringForColumn:@"remindPeriod"];
            content.remindType = [result intForColumn:@"remindType"];
            content.medicineInfo = [result stringForColumn:@"medicineInfo"];
            [list addObject:content];
        }
        NSLog(@"");
    }];
    
    
    return list;
}

- (YMTimerRemindMode *)queryRemindData:(NSString *)remindId toDataBase:(FMDatabase *)db{
    NSString *sql = [NSString stringWithFormat:@"select * from t_remind where remindId = %@",remindId];
    FMResultSet *resultSet = [db executeQuery:sql];
    YMTimerRemindMode *content = [[YMTimerRemindMode alloc] init];
    if ([resultSet next]) {
        NSDictionary *dict = resultSet.resultDictionary;
        content.remindId = dict[@"remindId"];
    }
    return content;
}



- (void)updateLocalRemindData:(YMTimerRemindMode *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
////            NSString *sql = [NSString stringWithFormat:@"select * from t_remind where remindId = %@",content.remindId];
//            NSString *sql = @"select * from t_remind where remindId = ？";
//            FMResultSet *resultSet = [db executeQueryWithFormat:sql,content.remindId];
//            if ([resultSet next]) {
//                [self removeRelationShipOfRemindId:content.remindId fromDataBase:db];
//            }
//            
//            BOOL result = [self insertRemindData:content toDataBase:db];
//            if (result) {
//                NSLog(@"更新数据成功");
//            }
            //[db executeUpdate:@"update t_topic set loves = ? where news_id = ?",@(likeCount),topicId];

//            NSString *sql = @"update t_remind set remindTitle = ?,remindBellId = ?,remindTime = ?,remindShake = ?,remindPeriod = ?,medicineInfo = ?,remindType = ? where remindId = ？";
            NSString *remindId = content.remindId ?content.remindId : @"";
            NSString *remindTitle = content.remindTitle ? content.remindTitle: @"";
            NSString *remindBellId = content.remindBellId ?content.remindBellId: @"";
            NSString *remindTime = content.remindTime ?content.remindTime: @"";
            NSNumber *remindShake = [NSNumber numberWithInteger:content.remindShake];
            NSString *remindPeriod = content.remindPeriod ?content.remindPeriod: @"";
            NSString *medicineInfo = content.medicineInfo ?content.medicineInfo: @"";
            NSNumber *remindType = [NSNumber numberWithInteger:content.remindType];
            NSString *sql = @"update t_remind set remindTitle = ? ,remindBellId = ? ,remindTime = ? ,remindShake = ?,remindPeriod = ? ,medicineInfo = ? ,remindType = ? where remindId = ?";
            BOOL updateResult = [db executeUpdate:sql,remindTitle,remindBellId,remindTime,remindShake,remindPeriod,medicineInfo,remindType,remindId];
            if (updateResult) {
                NSLog(@"更新成功");
            }
        }];
        
    });
}

//插入数据
- (void)insertRemindData:(YMTimerRemindMode *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"insert into t_remind (remindId ,remindTitle ,remindBellId ,remindTime ,remindShake ,remindPeriod ,medicineInfo ,remindType) values (?,?,?,?,?,?,?,?)";
            NSString *remindId = content.remindId ?content.remindId : @"";
            NSString *remindTitle = content.remindTitle ? content.remindTitle: @"";
            NSString *remindBellId = content.remindBellId ?content.remindBellId: @"";
            NSString *remindTime = content.remindTime ?content.remindTime: @"";
            NSNumber *remindShake = [NSNumber numberWithInteger:content.remindShake];
            NSString *remindPeriod = content.remindPeriod ?content.remindPeriod: @"";
            NSString *medicineInfo = content.medicineInfo ?content.medicineInfo: @"";
            NSNumber *remindType = [NSNumber numberWithInteger:content.remindType];
            NSArray *argArray = @[remindId,remindTitle,remindBellId,remindTime,remindShake,remindPeriod,medicineInfo,remindType];
            BOOL insertResult = [db executeUpdate:sql withArgumentsInArray:argArray];
            if (insertResult) {
                NSLog(@"新增成功");
                
            }
        }];
        
    });
    
//    return insertResult;
}

- (void)removeRelationShipOfRemindContent:(YMTimerRemindMode *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [self removeRelationShipOfRemindId:content.remindId fromDataBase:db];
            
        }];
        
    });
}

//删除数据
- (void)removeRelationShipOfRemindId:(NSString *)remindId fromDataBase:(FMDatabase *)db{
    
    NSString *sql = [NSString stringWithFormat:@"delete from t_remind where remindId = %@",remindId];
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"删除成功");
    }
}


@end


























