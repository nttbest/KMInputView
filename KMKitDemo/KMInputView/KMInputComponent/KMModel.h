//
//  KMModel.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMEmoticonGroup;
@class KMApplicationGroupModel;

typedef NS_ENUM(NSUInteger, KMEmoticonType) {
    KMEmoticonTypeEmoji = 0, ///< emoji表情
    KMEmoticonTypeGif = 1, ///< gif表情
};

typedef NS_ENUM(NSUInteger, KMApplicationAppType) {
    KMApplicationAppTypeA = 0,
    KMApplicationAppTypeB = 1,
    KMApplicationAppTypeC = 2,
    KMApplicationAppTypeD = 3
};



#pragma mark - KMEmotion
@interface KMEmoticon : NSObject
@property (nonatomic, copy) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, copy) NSString *name; ///< 例如 吃惊
@property (nonatomic, copy) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, copy) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, copy) NSString *emotionUrl;
@property (nonatomic, copy) NSString *emotionId;
@property (nonatomic, weak) KMEmoticonGroup *group;
@property (nonatomic, assign) KMEmoticonType type;
@end


@interface KMEmoticonGroup : NSObject
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, strong) NSArray *emotions;
@end


#pragma mark - KMApplication
@interface KMApplicationModel : NSObject
@property (nonatomic, copy) NSString *saId;                 //唯一标识
@property (nonatomic, copy) NSString *name;                 //名称
@property (nonatomic, copy) NSString *title;                //标题
@property (nonatomic, copy) NSString *uri;                  //连接地址
@property (nonatomic, copy) NSString *icon;                 //图标地址
@property (nonatomic, copy) NSString *content;              //描述
@property (nonatomic, copy) NSString *nameSpace;            //名称
@property (nonatomic, copy) NSString *appType;              //类型
@property (nonatomic, copy) NSString *isRecommend;          //是否推荐
@property (nonatomic, copy) NSString *status;               //是否可点击
@property (nonatomic, weak) KMApplicationGroupModel *group;
@property (nonatomic, assign) KMApplicationAppType type;
@property (nonatomic, copy) NSString *actionType;           //0全屏打开;1半屏打开;2发消息
@property (nonatomic, copy) NSString *screenSize;           //屏幕尺寸
@property (nonatomic, copy) NSString *jsonParameter;        //参数
@property (nonatomic, copy) NSString *mwapType;             //mwap加载方式(0：url审核页；1:跳转到插件预装载；其他：url链接)
@end

@interface KMApplicationGroupModel : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *appList;
@end










