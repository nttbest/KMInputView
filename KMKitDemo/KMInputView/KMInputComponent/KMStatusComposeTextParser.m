//
//  KMStatusComposeTextParser.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMStatusComposeTextParser.h"
#import "KMStatusHelper.h"
#import "NSAttributedString+YYText.h"

@implementation KMStatusComposeTextParser{
    
}

- (instancetype)init {
    self = [super init];
    _font = [UIFont systemFontOfSize:15];
    _textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _highlightTextColor = UIColorHex(527ead);
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    text.color = _textColor;

    {
        NSArray *emoticonResults = [[KMStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imagePath = [KMStatusHelper emoticonDic][emoString];
            UIImage *image = [KMStatusHelper imageWithPath:imagePath];
            if (!image) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:_font.pointSize].mutableCopy;
            // original text, used for text copy
            [emoText setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
            [emoText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
            
            [text replaceCharactersInRange:range withAttributedString:emoText];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:emoText.length selectedRange:*selectedRange];
            }
            clipLength += range.length - emoText.length;
        }
    }
    
    {
        [[KMStatusHelper regexLink] enumerateMatchesInString:text.string options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired range:text.rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange r = result.range;
            @weakify(text);
            [text setTextHighlightRange:r
                                     color:_highlightTextColor
                           backgroundColor:[UIColor clearColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *txt, NSRange range, CGRect rect) {
                                     
                                     @strongify(text);
                                     if ([(NSObject *) self.delegate respondsToSelector:@selector(yyTextViewDidTapLink:type:)]) {
                                         [self.delegate yyTextViewDidTapLink:[text.string substringWithRange:r]type:KMTextParserLinkTypeURL ];
                                     }
                                     
                                 }];
            
        }];
        
    }
    {

        [[KMStatusHelper regexPhone] enumerateMatchesInString:text.string options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired range:text.rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

            NSRange r = result.range;
            @weakify(text);
            [text setTextHighlightRange:r
                                     color:_highlightTextColor
                           backgroundColor:[UIColor clearColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *txt, NSRange range, CGRect rect) {

                                     @strongify(text);
                                     if ([(NSObject *) self.delegate respondsToSelector:@selector(yyTextViewDidTapLink:type:)]) {
                                         [self.delegate yyTextViewDidTapLink:[text.string substringWithRange:r]type:KMTextParserLinkTypePhoneNumber ];
                                     }

                                 }];

        }];

        //增加英文字母与手机号间无空格时的检测
        [[KMStatusHelper regexPhone2] enumerateMatchesInString:text.string options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired range:text.rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange r = result.range;
            @weakify(text);
            [text setTextHighlightRange:r
                                     color:_highlightTextColor
                           backgroundColor:[UIColor clearColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *txt, NSRange range, CGRect rect) {
                                     
                                     @strongify(text);
                                     if ([(NSObject *) self.delegate respondsToSelector:@selector(yyTextViewDidTapLink:type:)]) {
                                         [self.delegate yyTextViewDidTapLink:[text.string substringWithRange:r]type:KMTextParserLinkTypePhoneNumber ];
                                     }

                                 }];
        }];

    }
    [text enumerateAttribute:YYTextBindingAttributeName inRange:text.rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && range.length > 1) {
            [text setColor:_highlightTextColor range:range];
        }
    }];
    
    text.font = _font;
    return YES;
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}


- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
    
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

@end
