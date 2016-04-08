//
//  TNESqlStringManager.m
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNESqlStringManager.h"
#import "TNEExpressionDefinition.h"

/**
 *  我的表情包详情 和 商城表情包详情 字段完全一样
 */
static const NSString *TNEFaceBagTable  = @"TNEFaceBagTable"; //我的表情包详情 16 个
static const NSString *TNEFaceShopTable = @"TNEFaceShopTable";//商城表情包详情 16 个
static const NSString *TNEEmojiTable    = @"TNEEmojiTable";   //小表情详情     8 个

@implementation TNESqlStringManager

+ (NSSet *)tne_createTablesSqlString{
    
    NSSet *tables = [[NSSet alloc]initWithObjects:
                     @"create table if not exists TNEFaceBagTable(Id integer primary key autoincrement,faceBagId integer,name text,price integer,slogan text,intro text,mark text,orderBy integer,picId integer,picUrl text,isDownload integer,totals integer,remain integer,lineTime text,amount integer,attribute01 text,attribute02 text)",//我的表情包
                     
                     @"create table if not exists TNEFaceShopTable(Id integer primary key autoincrement,faceBagId integer,name text,price integer,slogan text,intro text,mark text,orderBy integer,picId integer,picUrl text,isDownload integer,totals integer,remain integer,lineTime text,amount integer,attribute01 text,attribute02 text)",//商城表情包

                     @"create table if not exists TNEEmojiTable(Id integer primary key autoincrement,faceBagId integer,faceName text,faceId integer,fileName text,facePicId int,picUrl text,attribute01 text,attribute02 text)", //小表情详情
                     
                     nil];
    
    return tables;
}

+ (NSString *)tne_saveSqlString:(NSMutableDictionary *)params className:(NSString *)className{
    
    NSString *tableName = [self tne_tableName:className];
    
    NSMutableString *sql=[[NSMutableString alloc] init];
    
    [sql appendFormat:@"insert into %@(",tableName];
    
    [sql appendString:[[params allKeys] componentsJoinedByString:@","]];
    [sql appendString:@") VALUES ("];
    BOOL isFirst = YES;
    for (NSString *key in [params allKeys]) {
        if (!isFirst) {
            [sql appendString:@","];
        }
        [sql appendFormat:@":%@",key];
        isFirst=NO;
    }
    
    [sql appendString:@")"];
    return sql;
    
}

+ (NSString *)tne_deleteSqlString:(NSString *)condition className:(NSString *)className{
    
    NSString *tableName = [self tne_tableName:className];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    if (condition){
        sql = [sql stringByAppendingFormat:@" %@",condition];
    }
    return sql;
    
}

+ (NSString *)tne_updateSqlString:(NSMutableDictionary *)params condition:(NSString *)condition className:(NSString *)className{
    
    NSString *tableName = [self tne_tableName:className];
    
    NSMutableString *sql=[[NSMutableString alloc] init];
    [sql appendFormat:@"update %@ set ",tableName];
    
    BOOL isFirst=YES;
    for (NSString *key in [params allKeys]) {
        if (!isFirst) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@=:%@",key,key];
        isFirst=NO;
    }
    
    [sql appendFormat:@" %@",condition];
    
    return sql;
    
}

+ (NSString *)tne_getObjsSqlString:(NSString *)condition className:(NSString *)className{
    
    NSString *tableName = [self tne_tableName:className];
    NSString *sql = [NSString stringWithFormat:@"select *from %@",tableName];
    if (condition){
        sql = [sql stringByAppendingFormat:@" %@",condition];
    }
    return sql;
    
}

+ (NSString *)tne_tableName:(NSString *)className{
    
    NSDictionary * methodMap = @{TNEFaceBagClass  : TNEFaceBagTable,
                                 TNEFaceShopClass : TNEFaceShopTable,
                                 TNEEmojiClass    : TNEEmojiTable};
    
    return [methodMap objectForKey:className];
    
}

////替换
//+ (NSString *)tne_replaceObjsSqlString:(NSMutableDictionary *)params
//                             condition:(NSString *)condition
//                             className:(NSString *)className
//{
//    NSString *tableName = [self tne_tableName:className];
//    
//    NSMutableString *sql=[[NSMutableString alloc] init];
//    [sql appendFormat:@"replace %@ set ",tableName];
//    
//    BOOL isFirst=YES;
//    for (NSString *key in [params allKeys]) {
//        if (!isFirst) {
//            [sql appendString:@","];
//        }
//        [sql appendFormat:@"%@=:%@",key,key];
//        isFirst=NO;
//    }
//    
//    [sql appendFormat:@" %@",condition];
//    
//    return sql;
//
//}

@end
