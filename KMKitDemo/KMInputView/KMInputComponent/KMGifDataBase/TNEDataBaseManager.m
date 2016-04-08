//
//  TNEDataBaseManager.m
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNEDataBaseManager.h"
#import "TNESqlStringManager.h"
#import <FMDB/FMDB.h>
#import "TNEUtil.h"
#import "TNEExpressionDefinition.h"

@interface TNEDataBaseManager ()
{
    //存储表名称集合
    NSSet *_tableSqlSet;
}

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@end

@implementation TNEDataBaseManager

+ (TNEDataBaseManager *)sharedInstance{
    
    static TNEDataBaseManager *dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataBase = [[self alloc]init];
        
    });
    return dataBase;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _tableSqlSet = [TNESqlStringManager tne_createTablesSqlString];
        
        NSLog(@"内容DB路径:%@",self.dataBaseQueue.path);
        
    }
    return self;
}

- (FMDatabaseQueue *)dataBaseQueue{
    
    if (!_dataBaseQueue) {
        
        NSString *documentPath  = [TNEUtil tne_expressionDataBasePath];
        
        NSString *dbPath        = [NSString stringWithFormat:@"%@/tne_expression_135277.db",documentPath];
        
        _dataBaseQueue          = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        //创建表
        [self createTable];
        
    }
    return _dataBaseQueue;
}

- (void)createTable
{
    //创建所有的表
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [_tableSqlSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            
            if(![db executeUpdate:obj]){
                *stop = YES;
            }
            
        }];
        
    }];
    
}

- (BOOL)tne_insertDataWithDictionary:(NSMutableDictionary *)params className:(NSString *)className{
    
    __block BOOL ret = YES;
    
    NSString *sql = [TNESqlStringManager tne_saveSqlString:params className:className];
    
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:sql withParameterDictionary:params];
        
        if ([db hadError]) {
            
            ret = NO;
            NSLog(@"tne insert error:%@ %@",[db lastError],[db lastErrorMessage]);
            
        }
        
    }];
    
    return ret;
}

- (BOOL)tne_deleteObjWithCondition:(NSString *)condition className:(NSString *)className{
    
    __block BOOL ret = YES;
    
    NSString *sql = [TNESqlStringManager tne_deleteSqlString:condition className:className];
    
    NSLog(@"______sql:%@",sql);
    
    
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:sql withArgumentsInArray:nil];
        
        if ([db hadError]) {
            
            ret = NO;
            NSLog(@"tnc delete error:%@ %@",[db lastError],[db lastErrorMessage]);
            
        }
        
    }];
    
    return ret;
}

- (BOOL)tne_clearTableWithClassName:(NSString *)className{
    
    __block BOOL ret = YES;
    
    NSString *sql = [TNESqlStringManager tne_deleteSqlString:nil className:className];
    
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:sql withArgumentsInArray:nil];
        
        if ([db hadError]) {
            
            ret = NO;
            NSLog(@"tne delete error:%@ %@",[db lastError],[db lastErrorMessage]);
            
        }
        
    }];
    
    return ret;
    
}

- (BOOL)tne_updateDataWithDictionary:(NSMutableDictionary *)params condition:(NSString *)condition className:(NSString *)className{
    
    __block BOOL ret = YES;
    
    NSString *sql = [TNESqlStringManager tne_updateSqlString:params condition:condition className:className];
    
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:sql withParameterDictionary:params];
        
        if ([db hadError]) {
            
            ret = NO;
            NSLog(@"tne update error:%@ %@",[db lastError],[db lastErrorMessage]);
            
        }
        
    }];
    
    return ret;
}

- (NSArray *)tne_getObjsWithCondition:(NSString *)condition className:(NSString *)className{
    
    NSMutableArray* retArray = [NSMutableArray new];
    
    NSString *sql = [TNESqlStringManager tne_getObjsSqlString:condition className:className];
    
    Class OBJC_Class;
    
    //商城也是生成TNEDBFaceBagModel 的类
    if ([className isEqualToString:TNEFaceShopClass]) {
        
        OBJC_Class = NSClassFromString(TNEFaceBagClass);
        
    }else{
        
        OBJC_Class = NSClassFromString(className);
    }
    
    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            NSObject *model = [[OBJC_Class alloc]init];
            
            [model setValuesForKeysWithDictionary:[rs resultDictionary]];
            
            [retArray addObject:model];
        }
        [rs close];
        
    }];
    
    return [retArray copy];
    
}

////替换
//- (BOOL)tne_replaceDataWithDictionary:(NSMutableDictionary *)params
//                            condition:(NSString *)condition
//                            className:(NSString *)className
//{
//    __block BOOL ret = YES;
//    
//    NSString *sql = [TNESqlStringManager tne_replaceObjsSqlString:params condition:condition className:className];
//    
//    [self.dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        
//        [db executeUpdate:sql withParameterDictionary:params];
//        
//        if ([db hadError]) {
//            
//            ret = NO;
//            NSLog(@"tne replace error:%@ %@",[db lastError],[db lastErrorMessage]);
//            
//        }
//        
//    }];
//    
//    return ret;
//}

@end
