//
//  KMStatusHelper.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "YYKit.h"
#import "KMModel.h"

#define kRegexPatternUrl @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z\\.\\-~!@#$%^&*+?:_/=<>]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([0-9]+\\.[0-9]+\\.[0-9\\.]+\\.[0-9])|([0-9]+\\.[0-9]+\\.[a-zA-Z])"
#define kRegexPatternPhone @"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}"

@interface KMStatusHelper : NSObject

/// 素材资源 bundle
+ (NSBundle *)resourceBundle;

/// emoji表情资源 bundle
+ (NSBundle *)emojiBundle;

/// emoji表情数组
+ (NSArray *)emojiGroups;

/// gif表情数组
+ (NSArray *)gifGroups;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;




/// 图片 cache
+ (YYMemoryCache *)imageCache;

+ (NSArray *)arrayWithPlistNamed:(NSString *)name;

/// 从bundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// At正则 例如 @王思聪
//+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
//+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 链接正则
+ (NSRegularExpression *)regexLink;

+ (NSRegularExpression *)regexPhone2;

/// 手机号正则
+ (NSRegularExpression *)regexPhone;

+ (void)layoutWithText:(NSAttributedString *)text
               success:(void(^)(YYTextLayout *layout))success
               failure:(void(^)(NSError *error))failure;


@end
