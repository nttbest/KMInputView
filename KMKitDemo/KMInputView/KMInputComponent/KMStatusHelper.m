//
//  KMStatusHelper.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMStatusHelper.h"
//#import "TNEDataBaseManager.h"
//#import "TNEDBFaceBagModel.h"
//#import "TNEDBEmojiModel.h"
//#import "TNEDBConditionModel.h"
//#import "TNEExpressionDefinition.h"

@implementation KMStatusHelper

+ (NSBundle *)resourceBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceInput" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (NSBundle *)emojiBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ResourceEmoji" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

#pragma mark - 获取emoji数组
+ (NSArray *)emojiGroups {
    static NSMutableArray *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"ResourceEmoji" ofType:@"bundle"];
        NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"groups.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
        NSArray *packages = plist[@"packages"];
        groups = (NSMutableArray *)[NSArray modelArrayWithClass:[KMEmoticonGroup class] json:packages];
        
        NSMutableDictionary *groupDic = [NSMutableDictionary new];
        for (int i = 0, max = (int)groups.count; i < max; i++) {
            KMEmoticonGroup *group = groups[i];
            if (group.groupID.length == 0) {
                [groups removeObjectAtIndex:i];
                i--;
                max--;
                continue;
            }
            NSString *path = [emoticonBundlePath stringByAppendingPathComponent:group.groupID];
            NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
            [group modelSetWithDictionary:info];
            if (group.emotions.count == 0) {
                i--;
                max--;
                continue;
            }
            groupDic[group.groupID] = group;
        }
    });
    return groups;
}


#pragma mark - 获取gif数组
+ (NSArray *)gifGroups {
//    NSArray *gifsGroupArray;
//    NSDictionary *dict = @{@"isDownload":@"1"};
//    NSString *condirionStr = [TNEDBConditionModel orderConditionWithDict:dict orderBy:@"orderBy"];
//    gifsGroupArray = [[TNEDataBaseManager sharedInstance] tne_getObjsWithCondition:condirionStr className:TNEFaceBagClass];
//    gifsGroupArray = [self transferTNEFaceBagTableToKMEmoticonGroupWithTNEFaceBagTableArray:gifsGroupArray];
//    return gifsGroupArray;
    return nil;
}
//
//+ (NSArray *)transferTNEFaceBagTableToKMEmoticonGroupWithTNEFaceBagTableArray:(NSArray *)faceBagArray{
//    if (!faceBagArray || faceBagArray.count < 1) {
//        return nil;
//    }
//    
//    NSMutableArray *mGroupsArray = [NSMutableArray array];
//    NSArray *tempFaceBagArray = [faceBagArray copy];
//    
//    for (TNEDBFaceBagModel *faceBagModel in tempFaceBagArray) {
//        KMEmoticonGroup *emotionGroup = [KMEmoticonGroup new];
//        emotionGroup.groupID = [NSString stringWithFormat:@"%@",faceBagModel.faceBagId];
//        emotionGroup.name = faceBagModel.name;
//        emotionGroup.logoUrl = faceBagModel.picUrl;
//        
//        NSArray *emojiArray = [[TNEDataBaseManager sharedInstance] tne_getObjsWithCondition:[NSString stringWithFormat:@"where faceBagId = %@",emotionGroup.groupID] className:@"TNEDBEmojiModel"];
//        NSMutableArray *mEmojiArray = [NSMutableArray array];
//        for (TNEDBEmojiModel *emojiModel in emojiArray) {
//            KMEmoticon *emotion = [KMEmoticon new];
//            emotion.chs = [NSString stringWithFormat:@"[%@]",emojiModel.faceName];
//            emotion.name = emojiModel.faceName;
//            emotion.gif = emojiModel.fileName;
//            emotion.png = emojiModel.fileName;
//            emotion.emotionUrl = emojiModel.picUrl;
//            emotion.emotionId = emojiModel.faceId;
//            emotion.type = KMEmoticonTypeGif;
//            emotion.group = emotionGroup;
//            [mEmojiArray addObject:emotion];
//        }
//        
//        emotionGroup.emotions = [mEmojiArray copy];
//        [mGroupsArray addObject:emotionGroup];
//    }
//    
//    return mGroupsArray;
//}

#pragma mark - textView解析
+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emojiBundlePath = [[NSBundle mainBundle] pathForResource:@"ResourceEmoji" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emojiBundlePath];
    });
    return dic;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    KMEmoticonGroup *group = nil;
    NSString *jsonPath = [path stringByAppendingPathComponent:@"info.json"];
    NSData *json = [NSData dataWithContentsOfFile:jsonPath];
    if (json.length) {
        group = [KMEmoticonGroup modelWithJSON:json];
    }
    if (!group) {
        NSString *plistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plist.count) {
            group = [KMEmoticonGroup modelWithJSON:plist];
        }
    }
    for (KMEmoticon *emoticon in group.emotions) {
        if (emoticon.png.length == 0) continue;
        NSString *pngPath = [path stringByAppendingPathComponent:emoticon.png];
        if (emoticon.chs) dic[emoticon.chs] = pngPath;
    }
    
    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *folder in folders) {
        if (folder.length == 0) continue;
        NSDictionary *subDic = [self _emoticonDicFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDic) {
            [dic addEntriesFromDictionary:subDic];
        }
    }
    return dic;
}


#pragma mark - private methods
+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"InputImageCache";
    });
    return cache;
}

+ (NSArray *)arrayWithPlistNamed:(NSString *)name {
    
    NSString *path = [[self resourceBundle] pathForResource:name ofType:@"plist"];
    if (!path) return nil;
    NSArray *res = [NSArray arrayWithContentsOfFile:path];
    return res;
    
}
+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self resourceBundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image = [[self imageCache] objectForKey:path];
    if (image) return image;
    if (path.pathScale == 1) {
        // 查找 @2x @3x 的图片
        NSArray *scales = [NSBundle preferredScales];
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        image = [image imageByDecoded];
        [[self imageCache] setObject:image forKey:path];
    }
    return image;
}


//+ (NSRegularExpression *)regexAt {
//    static NSRegularExpression *regex;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 目前中文字符范围比这个大
//        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
//    });
//    return regex;
//}

//+ (NSRegularExpression *)regexTopic {
//    static NSRegularExpression *regex;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
//    });
//    return regex;
//}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexLink{

    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                error:NULL];
//                [NSRegularExpression regularExpressionWithPattern:kRegexPatternUrl
//                                                          options:kNilOptions error:NULL];
    });
    return regex;
}


#define ScreenFrameWidth [UIScreen mainScreen].applicationFrame.size.width
#define ScreenFrameHeight [UIScreen mainScreen].applicationFrame.size.height
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define MaxWi(f)   iPhone6plus ?  ScreenFrameWidth / 375 *(f) : ScreenFrameWidth == 375 ? (f) : ScreenFrameWidth / 375 *(f)
#define MaxWidth MaxWi(254)

+ (NSRegularExpression *)regexPhone2 {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex =
//                [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
//                                                                   error:NULL];
                [NSRegularExpression regularExpressionWithPattern:kRegexPatternPhone
                                                          options:kNilOptions error:NULL];
    });
    return regex;
}
+ (NSRegularExpression *)regexPhone {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex =
                [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                                   error:NULL];
//                [NSRegularExpression regularExpressionWithPattern:kRegexPatternPhone
//                                                          options:kNilOptions error:NULL];
    });
    return regex;

    /*
     *测试使用如下代码查看结果
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:&error];

    NSUInteger numberOfMatches = [detector numberOfMatchesInString:url
                                                           options:0
                                                             range:NSMakeRange(0, [url length])];
    NSArray *matches1 = [detector matchesInString:url
                                         options:0
                                           range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches1) {
        NSRange matchRange = [match range];
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];

            NSLog(@"url: %@", url);
        } else if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            NSString *phoneNumber = [match phoneNumber];

            NSLog(@"phone number: %@", phoneNumber);
        }
    }
    NSString *string = @"This is a sample of a http://abc.com/efg.php?EFAei687e3EsA sentence with a URL within it and a number      110 123 5987 49558 4450 097843 50348754  5098345 58398674 tence 138-1011-9828 13810119828 +8613810119828 (010)89576463";
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber error:nil];
    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];

    for (NSTextCheckingResult *match in matches) {

//        if ([match resultType] == NSTextCheckingTypeLink) {
            NSString *matchingString = [match description];
            NSLog(@"found URL: %@", matchingString);
//        }
    }

    return;


     */
}

+ (void)layoutWithText:(NSAttributedString *)text
               success:(void(^)(YYTextLayout *layout))success
               failure:(void(^)(NSError *error))failure{
    
    if (!text) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建属性字符串
        NSMutableAttributedString *_text = [text mutableCopy];
        _text.font = [UIFont systemFontOfSize:16];
        
        // 创建文本容器
        YYTextContainer *_container = [YYTextContainer new];
        _container.size = CGSizeMake(MaxWidth, CGFLOAT_MAX);
        _container.maximumNumberOfRows = 0;
        
        // 生成排版结果
        YYTextLayout *_layout = [YYTextLayout layoutWithContainer:_container text:_text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_layout) {
                if (success) {
                    success(_layout);
                }
            } else {
                if (failure) {
                    failure([NSError errorWithDomain:@"YYTextLayout" code:10001 userInfo:nil]);
                }
            }
        });
    });
}


@end















