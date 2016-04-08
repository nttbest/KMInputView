//
//  TNEDBFaceBagModel.m
//  Toon
//
//  Created by wangpeirong on 15/12/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNEDBFaceBagModel.h"
#import <objc/runtime.h>

@implementation TNEDBFaceBagModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@",key);
}

- (NSArray *)allKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    
    unsigned int count;
    unsigned int index;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (index = 0; index < count; index++) {
        
        objc_property_t property = properties[index];
        
        //字段名称
        NSString *propertyName = [NSString stringWithFormat:@"%s",property_getName(property)];
        [keys addObject:propertyName];
    }
    
    return keys;
}

- (NSDictionary *)convertModelToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self allKeys]) {
        
        id propertyValue = [self valueForKey:key];
        
        if (propertyValue != nil) {
            [dic setObject:propertyValue forKey:key];
        }
    }
    
    return dic;
}

@end
