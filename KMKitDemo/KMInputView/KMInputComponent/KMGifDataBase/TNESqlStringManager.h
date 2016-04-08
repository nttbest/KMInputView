//
//  TNESqlStringManager.h
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNESqlStringManager : NSObject

//创建表
+ (NSSet *)tne_createTablesSqlString;

//增
+ (NSString *)tne_saveSqlString:(NSMutableDictionary *)params
                      className:(NSString *)className;
//删
+ (NSString *)tne_deleteSqlString:(NSString *)condition
                        className:(NSString *)className;
//改
+ (NSString *)tne_updateSqlString:(NSMutableDictionary *)params
                        condition:(NSString *)condition
                        className:(NSString *)className;
//查
+ (NSString *)tne_getObjsSqlString:(NSString *)condition
                         className:(NSString *)className;

////替换
//+ (NSString *)tne_replaceObjsSqlString:(NSMutableDictionary *)params
//                             condition:(NSString *)condition
//                             className:(NSString *)className;

@end
