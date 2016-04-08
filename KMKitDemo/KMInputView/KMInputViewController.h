//
//  KMInputViewController.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMInputView.h"
#import "KMInputDefinition.h"
#import "KMVoiceInputView.h"
#import "KMVideoInputView.h"
#import "KMPictureInputView.h"
#import "KMEmoticonInputView.h"
#import "KMMoreInputView.h"

#define KAnimationDuration .25
#define KKeyboardHeight 216

@interface KMInputViewController : UIViewController

@property (nonatomic, readonly, weak) KMInputView *kmInputView;
@property (nonatomic, readonly, weak) KMVoiceInputView *voiceInputView;
@property (nonatomic, readonly, weak) KMVideoInputView *videoInputView;
@property (nonatomic, readonly, weak) KMPictureInputView *pictureInputView;
@property (nonatomic, readonly, weak) KMEmoticonInputView *emotionInputView;
@property (nonatomic, readonly, weak) KMMoreInputView *moreInputView;
@property (nonatomic, assign) KMInputViewType currentInputViewType;

- (void)addInputView;
- (void)removeInputView;

@end
