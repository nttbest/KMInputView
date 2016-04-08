//
//  TNEDBEmojiModel.h
//  Toon
//
//  Created by wangpeirong on 15/12/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNEDBEmojiModel : NSObject

//表情包名称
@property (nonatomic,copy)NSString *faceBagId;

//表情名称（哈哈，嘻嘻...）
@property (nonatomic,copy)NSString *faceName;

//表情ID
@property (nonatomic,copy)NSString *faceId;

//文件名(本地存储的图片名称)
@property (nonatomic,copy)NSString *fileName;

//表情图的ID
@property (nonatomic,copy)NSString *facePicId;

//表情图URL
@property (nonatomic,copy)NSString *picUrl;

//备用字段1
@property (nonatomic,copy)NSString *attribute01;

//备用字段2
@property (nonatomic,copy)NSString *attribute02;

-(NSArray *)allKeys;

//model 转 dict
- (NSDictionary *)convertModelToDictionary;

@end
