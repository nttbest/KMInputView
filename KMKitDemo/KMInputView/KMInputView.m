//
//  KMInputView.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/22.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMInputView.h"
#import "KMStatusHelper.h"
#import "KMStatusComposeTextParser.h"
#import "KMStatusLayout.h"
#import "KMInputMenuView.h"
#import "KMInputDefinition.h"
#import "KMSegmentedItem.h"
#import "KMSegmentedData.h"
#import "KMSegmentedView.h"

#define KTextViewMarginTop 6
#define KTextViewMarginLeft 8
#define KTextViewMarginBottom 6
#define KTextViewMarginRight 8

#define KTextViewTextContainerInset_top 4
#define KTextViewTextContainerInset_left 4
#define KTextViewTextContainerInset_bottom 4
#define KTextViewTextContainerInset_right 4

#define KTextViewCornerRadius 5
#define KTextViewFont 15


@interface KMInputView () < YYTextViewDelegate ,
                            KMSegmentedControlDelegate >

@property (nonatomic, strong, readwrite) YYTextView *textView;
@property (nonatomic, strong) UIView *textViewBackground;
@property (nonatomic, strong) KMInputMenuView *menuView;

@end


@implementation KMInputView{
    CGFloat _originHeight;
}

#pragma mark - Life cycle

+ (instancetype)sharedView{
    static KMInputView *v;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [self new];
    });
    return v;
}

- (instancetype)init {
    if (self = [super init]){
        [self setup];
    }
    return self;
}

- (void)dealloc{
    [_textView removeObserver:self forKeyPath:@"text"];
}

- (void)setup{

    [self setClipsToBounds:YES];
    //setup self
    self.frame = CGRectMake(0, 0, kScreenWidth, kInputViewHeight);
    self.backgroundColor = UIColorHex(FFFFFF);
    
    //setup subViews
    [self addSubview:self.textViewBackground];
    [self addSubview:self.textView];
    [self addSubview:self.menuView];
}

#pragma mark - Setter & Getter

- (UIView *)textViewBackground{
    if (!_textViewBackground) {
        _textViewBackground = [UIView new];
        _textViewBackground.backgroundColor = UIColorHex(EDEEF1);
        _textViewBackground.size = CGSizeMake(self.width, KTextViewHeight + KTextViewMarginTop + KTextViewMarginBottom);
        _textViewBackground.top = 0;
    }
    return _textViewBackground;
}

- (YYTextView *)textView{
    if (!_textView){
        _textView = [YYTextView new];
        _textView.size = CGSizeMake(self.width - KTextViewMarginLeft - KTextViewMarginRight, KTextViewHeight);
        _textView.centerX = self.centerX;
        _textView.top = KTextViewMarginTop;
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = KTextViewCornerRadius;
        _textView.backgroundColor = UIColorHex(FFFFFF);
        _textView.textContainerInset = UIEdgeInsetsMake(KTextViewTextContainerInset_top,
                                                        KTextViewTextContainerInset_left,
                                                        KTextViewTextContainerInset_bottom,
                                                        KTextViewTextContainerInset_right);
        _textView.showsVerticalScrollIndicator = YES;
        _textView.alwaysBounceVertical = YES;
        _textView.allowsCopyAttributedString = NO;
        _textView.allowsUndoAndRedo = NO;
        _textView.font = [UIFont systemFontOfSize:KTextViewFont];
        _textView.textParser = [KMStatusComposeTextParser new];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        KMTextLinePositionModifier *modifier = [KMTextLinePositionModifier new];
        modifier.font = [UIFont systemFontOfSize:KTextViewFont];
        modifier.paddingTop = 10;
        modifier.paddingBottom = 10;
        modifier.lineHeightMultiple = 1.3;
        _textView.linePositionModifier = modifier;
        
        NSString *placeholderPlainText = @"请输入聊天内容";
        if (placeholderPlainText) {
            NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
            atr.color = UIColorHex(ACB3BF);
            atr.font = [UIFont systemFontOfSize:KTextViewFont];
            _textView.placeholderAttributedText = atr;
        }
        [_textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _textView;
}


- (KMInputMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[KMInputMenuView alloc] initWithFrame:CGRectMake(0, 0, self.width, kToolBarHeight)];
        _menuView.backgroundColor = UIColorHex(EDEEF1);
        _menuView.delegate = self;
    }
    return _menuView;
}


#pragma mark - YYTextViewDelegate Methods

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    
    self.menuView.segmentedView.currentSelectedIndex = -1;
    
    if ([self.delegate respondsToSelector:@selector(inputViewShouldBeginEditing:)]){
        [self.delegate inputViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(YYTextView *)textView{
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([self.delegate respondsToSelector:@selector(inputView:shouldChangeTextInRange:replacementText:)]){
        return [self.delegate inputView:self shouldChangeTextInRange:range replacementText:text];
    }
    return NO;
}

- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange{
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange{
    return YES;
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self endEditing:YES];
}

#pragma mark - KMSegmentedControlDelegate Methods

- (void)segmentedControlSelectionDidChanged:(KMSegmentedItem *)segmentedItem {
    KMInputViewType type = (KMInputViewType) [segmentedItem.data.value intValue];

    if ([self.delegate respondsToSelector:@selector(inputViewDidSelectMenuItem:)]) {
        [self.delegate inputViewDidSelectMenuItem:type];
    }
}


#pragma mark - Event methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!keyPath || ![keyPath isEqualToString:@"text"]) {
        return;
    }

    [self _updateLayout];

    if ([self.delegate respondsToSelector:@selector(inputView:didChangeText:)]) {
        [self.delegate inputView:self didChangeText:_textView.text];
    }
}

- (void)_updateLayout{
    
    CGFloat height = [self heightOfTextView];
    
    CGFloat txtViewHeight;
    if (height <= KTextViewMinimumHeight) {
        
        txtViewHeight = KTextViewMinimumHeight;
        _textView.scrollEnabled = NO;
        
    }else if (height <= KTextViewMaximumHeight){
        
        txtViewHeight = height;
        _textView.scrollEnabled = NO;
        
    }else{
        
        txtViewHeight = KTextViewMaximumHeight;
        _textView.scrollEnabled = YES;
        [_textView scrollRangeToVisible:_textView.selectedRange];
    }
    
    
    CGFloat textViewBackgroundHeight = [self heightOfTextViewBackground];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         _textView.height = txtViewHeight;
                         _textView.top = KTextViewMarginTop;
                         
                         _textViewBackground.height = textViewBackgroundHeight;
                         _textViewBackground.top = 0;
                         
                         _menuView.top = textViewBackgroundHeight;
                         self.height = self.menuView.bottom;
                         
                     } completion:^(BOOL finished) {
                         
                         if (!_originHeight) {
                             _originHeight = [self heightOfInputView];
                         }else{
                             CGFloat newHeight = [self heightOfInputView];
                             CGFloat changeHeight = newHeight - _originHeight;
                             if (ABS(changeHeight) != 0) {
                                 if ([self.delegate respondsToSelector:@selector(inputView:didChangeHeight:)]) {
                                     [self.delegate inputView:self didChangeHeight:changeHeight];
                                 }
                             }
                             _originHeight = newHeight;
                         }
                     }];
}


#pragma mark - Interface Methods

- (void)reset{
    self.menuView.segmentedView.currentSelectedIndex = -1;
    [self setText:@""];
}

- (void)setText:(NSString *)txt withRange:(NSRange)range{

    YYTextRange *r = [YYTextRange rangeWithStart:[YYTextPosition positionWithOffset:range.location]
                                             end:[YYTextPosition positionWithOffset:MAX(range.location+range.length, 0)]];

    [self.textView replaceRange:r withText:txt];
    [self _updateLayout];
}

- (void)setText:(NSString *)txt {
    [self setText:txt withRange:NSMakeRange(0, [self.textView.text length]) ];
}

- (CGFloat)heightOfTextView{
    if (!_textView.text.length) {
        return KTextViewMinimumHeight;
    }else{
        return _textView.textLayout.textBoundingSize.height;
    }
}

- (CGFloat)heightOfTextViewBackground{
    if (!_textView.text.length) {
        return KTextViewMinimumHeight + KTextViewMarginTop + KTextViewMarginBottom;
    }else{
        CGFloat textViewHeight = [self heightOfTextView];
        if (textViewHeight <= KTextViewMinimumHeight) {
            return KTextViewMinimumHeight + KTextViewMarginTop + KTextViewMarginBottom;
        }else if (textViewHeight <= KTextViewMaximumHeight){
            return textViewHeight + KTextViewMarginTop + KTextViewMarginBottom;
        }else{
            return KTextViewMaximumHeight + KTextViewMarginTop + KTextViewMarginBottom;
        }
    }
}

- (CGFloat)heightOfInputView{
    return [self heightOfTextViewBackground] + self.menuView.height;
}


@end
