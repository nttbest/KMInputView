//
//  KMInputViewController.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMInputViewController.h"
#import "YYKit.h"
#import <AVFoundation/AVFoundation.h>

#define KInputViewHeight 96
#define KInputView_PictureHeight 1024

@interface KMInputViewController () <   YYTextKeyboardObserver,
                                        KMInputViewDelegate,
                                        KMVoiceInputViewDelegate,
                                        KMVideoInputViewDelegate,
                                        KMPictureInputViewDelegate,
                                        KMEmoticonInputViewDelegate,
                                        KMMoreInputViewDelegate,
                                        UIImagePickerControllerDelegate,
                                        UIInputViewAudioFeedback,
                                        UIAlertViewDelegate>

@property (nonatomic, readwrite, weak) KMInputView *kmInputView;
@property (nonatomic, readwrite, weak) KMVoiceInputView *voiceInputView;
@property (nonatomic, readwrite, weak) KMVideoInputView *videoInputView;
@property (nonatomic, readwrite, weak) KMPictureInputView *pictureInputView;
@property (nonatomic, readwrite, weak) KMEmoticonInputView *emotionInputView;
@property (nonatomic, readwrite, weak) KMMoreInputView *moreInputView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation KMInputViewController

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup{
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    _currentInputViewType = KMInputViewTypeNull;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(EDEEF1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;

    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self addInputView];
    [self _reset];
}


#pragma mark - YYTextKeyboardObserver methods

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    _keyboardHeight = CGRectGetHeight(toFrame);
    if (transition.animationDuration == 0) {
        _kmInputView.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _kmInputView.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}


#pragma mark - KMInputViewDelegate methods

- (BOOL)inputViewShouldBeginEditing:(KMInputView *)inputView{

    if (_currentInputViewType != KMInputViewTypeNull &&
            _currentInputViewType != KMInputViewTypeText ) {
        [self _inputViewDown];
    }
    _currentInputViewType = KMInputViewTypeText;
    return YES;
}

- (void)inputView:(KMInputView *)inputView didChangeText:(NSString *)text{
}

- (void)inputView:(KMInputView *)inputView didChangeHeight:(CGFloat)height{
    [UIView animateWithDuration:KAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        _kmInputView.bottom -= height;
    } completion:NULL];
}

- (void)inputViewDidSelectMenuItem:(KMInputViewType)type {
    bool isSelected = self.currentInputViewType != type;
    [self _updateInputViewLayout:type selected:isSelected];
}

- (BOOL)inputView:(KMInputView *)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}


#pragma mark - KMEmoticonInputViewDelegate methods

- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_kmInputView setText:text withRange:self.kmInputView.textView.selectedRange];
    }
}

- (void)emoticonInputDidTapGif:(KMEmoticon *)emotion{
}

- (void)emoticonInputDidTapBackspace {
    [_kmInputView.textView deleteBackward];
}

- (void)emoticonInputDidTapSend {
}

- (void)emoticonInputDidTapAdd{
}


#pragma mark - KMPictureInputViewDelegate methods

- (void)pictureInputDidTapAlbum{
}

- (void)pictureInputDidTapCamera{
}


#pragma mark - KMMoreInputViewDelegate methods

- (void)moreInputDidTapText:(NSString *)text{
}


#pragma mark - KMVoiceInputViewDelegate methods

- (void)voiceInputDidTapText:(NSString *)text{
}


#pragma mark - MMRecoringViewDelegate methods

- (void)videoInputDidTapText:(NSString *)text{
}


#pragma mark - Private methods

- (CGFloat)_viewHeight{
    return kScreenHeight - 44 -20;
}

- (void)_reset{
    _currentInputViewType = KMInputViewTypeNull;
    [self _updateKMInputViewLayout];
    [self.kmInputView reset];
}

- (void)_inputViewUp{
    switch (_currentInputViewType) {
        case KMInputViewTypeVoiceInputView:{
            [self.view bringSubviewToFront:_voiceInputView];

            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _voiceInputView.bottom = [self _viewHeight];
                             } completion:NULL];
        }
            break;
            
        case KMInputViewTypeVideoInputView:{
            
            [self.view bringSubviewToFront:_videoInputView];
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
             
                             animations:^{
                                 _videoInputView.bottom = [self _viewHeight];
                             } completion:NULL];
        }
            break;
            
        case KMInputViewTypePictureInputView:{
            
            [self.view bringSubviewToFront:_pictureInputView];
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _pictureInputView.bottom = [self _viewHeight];
                             } completion:NULL];
        }
            break;
            
        case KMInputViewTypeEmotionInputView:{
            
            [self.view bringSubviewToFront:_emotionInputView];
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _emotionInputView.bottom = [self _viewHeight];
                             } completion:NULL];

        }
            break;
            
        case KMInputViewTypeMoreInputView:{
            [self.view bringSubviewToFront:_moreInputView];
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _moreInputView.bottom = [self _viewHeight];
                             } completion:NULL];

        }
            break;
            
        default:
            break;
    }
}

- (void)_inputViewDown{
    switch (_currentInputViewType) {
        case KMInputViewTypeVoiceInputView:{
            
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _voiceInputView.top = [self _viewHeight];
                             } completion:NULL];
            
        }
            break;
            
        case KMInputViewTypeVideoInputView:{
            
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _videoInputView.top = [self _viewHeight];
                             } completion:NULL];
            
        }
            break;
            
        case KMInputViewTypePictureInputView:{
            
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _pictureInputView.top = [self _viewHeight];
                             } completion:NULL];
            
        }
            break;
            
        case KMInputViewTypeEmotionInputView:{
            
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _emotionInputView.top = [self _viewHeight];
                             } completion:NULL];
            
        }
            break;
            
        case KMInputViewTypeMoreInputView:{
            
            [UIView animateWithDuration:KAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _moreInputView.top = [self _viewHeight];
                             } completion:NULL];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)_updateKMInputViewLayout {
    
    CGFloat keyboardHeight = 0;
    if (self.currentInputViewType == KMInputViewTypeText) {
        keyboardHeight = _keyboardHeight;
    } else if (self.currentInputViewType != KMInputViewTypeNull) {
        keyboardHeight = KKeyboardHeight;
    }
    
    [UIView animateWithDuration:KAnimationDuration animations:^(void) {
        self.kmInputView.bottom = [self _viewHeight] - keyboardHeight;
    }];
}

- (void)_updateInputViewLayout:(KMInputViewType)type selected:(BOOL)selected{
    
    if ([_kmInputView.textView isFirstResponder]) {
        /*!
         *  state:输入框是焦点
         *  method:textView下,KMInputView上,inputView上
         */
        _currentInputViewType = type;
        [_kmInputView.textView resignFirstResponder];

        [self _updateKMInputViewLayout];
        [self _inputViewUp];
        
    }else{
        
        if (selected) {
            if (KMInputViewTypeNull == _currentInputViewType ||
                    KMInputViewTypeText == _currentInputViewType) {
                /*!
                 *  state:没有焦点
                 *  method:KMInputView上,inputView上
                 */
                _currentInputViewType = type;
                [self _updateKMInputViewLayout];
                [self _inputViewUp];

            }else{
                /*!
                 *  state:别的inputView是焦点
                 *  method:KMInputView不动,旧的inputView下,新的inputView上
                 */
                [self _inputViewDown];
                _currentInputViewType = type;
                [self _inputViewUp];
            }
            
        }else{
            /*!
             *  state:自己是焦点
             *  method:KMInputView下,inputView下
             */
            [self _inputViewDown];
            _currentInputViewType = KMInputViewTypeNull;
            [self _updateKMInputViewLayout];
            [self.kmInputView reset];
        }
    }
}


#pragma mark - setter & getter
- (KMInputView *)kmInputView{
    if (!_kmInputView) {
        _kmInputView = [KMInputView sharedView];
    }
    return _kmInputView;
}

- (KMVoiceInputView *)voiceInputView{
    if (!_voiceInputView) {
        _voiceInputView = [KMVoiceInputView sharedView];
    }
    return _voiceInputView;
}

- (KMVideoInputView *)videoInputView{
    if (!_videoInputView) {
        _videoInputView = [KMVideoInputView sharedView];
    }
    return _videoInputView;
}

- (KMPictureInputView *)pictureInputView{
    if (!_pictureInputView) {
        _pictureInputView = [KMPictureInputView sharedView];
    }
    return _pictureInputView;
}

- (KMEmoticonInputView *)emotionInputView{
    if (!_emotionInputView) {
        _emotionInputView = [KMEmoticonInputView sharedView];
    }
    return _emotionInputView;
}

- (KMMoreInputView *)moreInputView{
    if (!_moreInputView) {
        _moreInputView = [KMMoreInputView sharedView];
    }
    return _moreInputView;
}


#pragma mark - interface methods

- (void)addInputView{
    
    [self.view addSubview:self.kmInputView];
    [self.view addSubview:self.voiceInputView];
    [self.view addSubview:self.videoInputView];
    [self.view addSubview:self.pictureInputView];
    [self.view addSubview:self.emotionInputView];
    [self.view addSubview:self.moreInputView];
    
    [self.kmInputView.textView becomeFirstResponder];
    
    _kmInputView.bottom = [self _viewHeight];
    _kmInputView.delegate = self;
    
    _voiceInputView.top = [self _viewHeight];
    _voiceInputView.delegate = self;
    
    _videoInputView.top = [self _viewHeight];
    _videoInputView.delegate = self;
    
    _pictureInputView.top = [self _viewHeight];
    _pictureInputView.delegate = self;
    
    _emotionInputView.top = [self _viewHeight];
    _emotionInputView.delegate = self;
    
    _moreInputView.top = [self _viewHeight];
    _moreInputView.delegate = self;
    
}

- (void)removeInputView{
    [self.kmInputView removeFromSuperview];
    [self.voiceInputView removeFromSuperview];
    [self.videoInputView removeFromSuperview];
    [self.pictureInputView removeFromSuperview];
    [self.emotionInputView removeFromSuperview];
    [self.moreInputView removeFromSuperview];
}

@end



















