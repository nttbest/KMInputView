//
//  TNEDBConditionModel.m
//  Toon
//
//  Created by wangpeirong on 15/12/15.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNEDBConditionModel.h"

@implementation TNEDBConditionModel

+ (NSString *)defaultConditionWithDict:(NSDictionary *)dict
{
    NSMutableString *conditionStr=[[NSMutableString alloc] init];
    
    [conditionStr appendFormat:@"where "];

    BOOL isFirst = YES;
    
    for (NSString *key in [dict allKeys]) {
        if (!isFirst) {
            [conditionStr appendString:@" and "];
        }
        [conditionStr appendFormat:@"%@ = %@",key,dict[key]];
        isFirst=NO;
    }

    return [conditionStr copy];
}

+ (NSString *)orderConditionWithDict:(NSDictionary *)dict orderBy:(NSString *)orderBy
{
    NSMutableString *conditionStr = [[[self class] defaultConditionWithDict:dict] mutableCopy];
    
    [conditionStr appendFormat:@" order by %@ desc",orderBy];
    
    return conditionStr;
}

@end
