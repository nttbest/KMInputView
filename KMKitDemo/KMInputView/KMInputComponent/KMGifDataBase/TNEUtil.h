//
//  TNEUtil.h
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TNEDBFaceBagModel.h"

static  NSString * const KTNEFaceBagDidChangeNotification = @"KTNEFaceBagDidChangeNotification";

@interface TNEUtil : NSObject

+ (NSString *)tneLibraryPath;
+ (NSString *)tneDocumentPath;

//存放小表情图片的位置
+ (NSString *)tne_imageCachPath;

//存放表情包数据库的位置
+ (NSString *)tne_expressionDataBasePath;

//获取存放表情包缩略图的位置
+ (NSString *)tne_faceBagImagePathWithUrl:(NSString *)url;

@end
