//
//  KMVoiceInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/23.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMVoiceInputViewDelegate <NSObject>
@optional
- (void)voiceInputDidTapText:(NSString *)text;
@end

@interface KMVoiceInputView : UIView

@property (nonatomic, weak) id<KMVoiceInputViewDelegate> delegate;
+ (instancetype)sharedView;

@end
