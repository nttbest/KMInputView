//
//  TNEUtil.m
//  Toon
//
//  Created by wangpeirong on 15/12/8.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNEUtil.h"
#import "YYKit.h"

@implementation TNEUtil

+ (NSString *)tneLibraryPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);;
    NSString *libDir = [paths objectAtIndex:0];
    
    return libDir;
}

+ (NSString *)tneDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
    NSString *docDir = [paths objectAtIndex:0];
    
    return docDir;
}

+ (NSString *)tne_imageCachPath
{
    NSString *basePath = [TNEUtil tneDocumentPath];
    NSString *path = [basePath stringByAppendingFormat:@"/imageCache/emoji_decompress"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)tne_expressionDataBasePath
{
    NSString *basePath = [TNEUtil tneLibraryPath];
    
    NSString *path = [basePath stringByAppendingFormat:@"/Expression"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)tne_faceBagImagePathWithUrl:(NSString *)url;
{
    NSString *basePath = [TNEUtil tneDocumentPath];
    NSString *path = [basePath stringByAppendingFormat:@"/imageCache/faceBagImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* md5 = [url md5String];

    return [path stringByAppendingFormat:@"/%@",md5];

}

@end
