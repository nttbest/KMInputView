//
//  TNEDBConditionModel.h
//  Toon
//
//  Created by wangpeirong on 15/12/15.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNEDBConditionModel : NSObject
/**
 *  默认条件格式
 *
 *  @param dict 生成条件语句的键值对
 *
 */
+ (NSString *)defaultConditionWithDict:(NSDictionary *)dict;


/**
 *  需要排序的条件格式 默认升序
 *
 *  @param dict    生成条件语句的键值对
 *  @param orderBy 排序所依据的字段名称
 *
 */
+ (NSString *)orderConditionWithDict:(NSDictionary *)dict orderBy:(NSString *)orderBy;

@end
