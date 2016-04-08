//
//  KMStatusComposeTextParser.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

//TODO:鉴于项目中的type使用MLEmojiLabelLinkType, 所以此处的值务必保持与之相同,后期替换
typedef NS_OPTIONS(NSUInteger, KMTextParserLinkType) {
    KMTextParserLinkTypeURL = 0,
    KMTextParserLinkTypeEmail,
    KMTextParserLinkTypePhoneNumber,
    KMTextParserLinkTypeAt,
    KMTextParserLinkTypePoundSign,
};

@protocol KMStatusComposeTextParserDelegate
-(void)yyTextViewDidTapLink:(NSString *)link type:(KMTextParserLinkType)type;
@end

@interface KMStatusComposeTextParser : NSObject <YYTextParser>

@property (nonatomic, weak)id<KMStatusComposeTextParserDelegate>delegate;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@end
