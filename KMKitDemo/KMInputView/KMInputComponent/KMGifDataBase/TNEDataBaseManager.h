//
//  TNEDataBaseManager.h
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNEDataBaseManager : NSObject

+ (TNEDataBaseManager *)sharedInstance;

//增
- (BOOL)tne_insertDataWithDictionary:(NSMutableDictionary *)params
                           className:(NSString *)className;
//清
- (BOOL)tne_clearTableWithClassName:(NSString *)className;

//删
- (BOOL)tne_deleteObjWithCondition:(NSString *)condition
                         className:(NSString *)className;
//改
- (BOOL)tne_updateDataWithDictionary:(NSMutableDictionary *)params
                           condition:(NSString *)condition
                           className:(NSString *)className;
//查
- (NSArray *)tne_getObjsWithCondition:(NSString *)condition
                            className:(NSString *)className;

////替换
//- (BOOL)tne_replaceDataWithDictionary:(NSMutableDictionary *)params
//                            condition:(NSString *)condition
//                            className:(NSString *)className;
@end
