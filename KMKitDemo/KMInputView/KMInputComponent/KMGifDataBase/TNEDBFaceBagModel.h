//
//  TNEDBFaceBagModel.h
//  Toon
//
//  Created by wangpeirong on 15/12/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNEDBFaceBagModel : NSObject //16字段

//表情包ID
@property (nonatomic,copy)NSString *faceBagId;

//表情包名称
@property (nonatomic,copy)NSString *name;

//表情包价格
@property (nonatomic,copy)NSString *price;

//推广语
@property (nonatomic,copy)NSString *slogan;

//介绍
@property (nonatomic,copy)NSString *intro;

//备注
@property (nonatomic,copy)NSString *mark;

//排列顺序
@property (nonatomic,copy)NSString *orderBy;

//缩略图ID
@property (nonatomic,copy)NSString *picId;

//缩略图URL
@property (nonatomic,copy)NSString *picUrl;

//是否下载  1 -> 已下载   2 -> 未下载
@property (nonatomic,copy)NSString *isDownload;

/*********** 以下4个字段暂未用到,以后可能会用 ************/

@property (nonatomic,copy)NSString *totals;//库存量

@property (nonatomic,copy)NSString *remain;//剩余量

@property (nonatomic,copy)NSString *lineTime;//上线时间

@property (nonatomic,copy)NSString *amount;//已售总额


/************* 以下字段是数据库专用 ********************/

//备用字段1
@property (nonatomic,copy)NSString *attribute01;

//备用字段2
@property (nonatomic,copy)NSString *attribute02;

- (NSArray *)allKeys;

//model 转 dict
- (NSDictionary *)convertModelToDictionary;

@end
