//
//  KMModel.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMModel.h"

#pragma mark - KMEmotion

@implementation KMEmoticon
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}
@end

@implementation KMEmoticonGroup
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"name" : @"group_name"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emotions" : [KMEmoticon class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emotions enumerateObjectsUsingBlock:^(KMEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}
@end

#pragma mark - KMApplication

@implementation KMApplicationModel
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}
@end

@implementation KMApplicationGroupModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupId" : @"groupId",
             @"name" : @"groupName"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"appList" : [KMApplicationModel class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_appList enumerateObjectsUsingBlock:^(KMApplicationModel *application, NSUInteger idx, BOOL *stop) {
        application.group = self;
    }];
    return YES;
}
@end