//
//  KMInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/22.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "KMInputDefinition.h"

#define kInputViewHeight 96
#define KTextViewHeight 36
#define kToolBarHeight 48
#define KPlaceHolderInputViewHeight 216

#define KTextViewMaximumHeight 115
#define KTextViewMinimumHeight 36

@class KMInputView;
@protocol KMInputViewDelegate <NSObject>
@optional
//inputView delegate methods
- (BOOL)inputViewShouldBeginEditing:(KMInputView *)inputView;
- (void)inputViewDidSelectMenuItem:(KMInputViewType)type;
- (void)inputView:(KMInputView *)inputView didChangeText:(NSString *)text;
- (void)inputView:(KMInputView *)inputView didChangeHeight:(CGFloat)height;
- (BOOL)inputView:(KMInputView *)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@end

@interface KMInputView : UIView
@property (nonatomic, weak) id<KMInputViewDelegate> delegate;
@property (nonatomic, strong, readonly) YYTextView *textView;

+ (instancetype)sharedView;
- (CGFloat)heightOfTextViewBackground;
- (void)reset;
- (void)setText:(NSString *)txt withRange:(NSRange )range;
- (void)setText:(NSString *)txt;

@end
