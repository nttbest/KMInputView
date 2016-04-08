//
//  KMEmoticonInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMModel.h"

@protocol KMEmoticonInputViewDelegate <NSObject>
@optional
- (void)emoticonInputDidTapText:(NSString *)text;
- (void)emoticonInputDidTapGif:(KMEmoticon *)emotion;
- (void)emoticonInputDidTapSend;
- (void)emoticonInputDidTapAdd;
- (void)emoticonInputDidTapBackspace;
@end

@interface KMEmoticonInputView : UIView

@property (nonatomic, weak) id<KMEmoticonInputViewDelegate> delegate;
+ (instancetype)sharedView;

@end
