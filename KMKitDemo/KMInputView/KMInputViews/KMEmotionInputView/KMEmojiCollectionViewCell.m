//
//  KMEmojiCollectionViewCell.m
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "KMEmojiCollectionViewCell.h"
#import "YYKit.h"
#import "KMStatusHelper.h"
#import "TNEUtil.h"

@implementation KMEmojiCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(32, 32);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    return self;
}

- (void)setEmoticon:(KMEmoticon *)emoticon {
    if (_emoticon == emoticon) return;
    _emoticon = emoticon;
    [self updateContent];
}

- (void)setIsDelete:(BOOL)isDelete {
    if (_isDelete == isDelete) return;
    _isDelete = isDelete;
    [self updateContent];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateContent {
    [_imageView cancelCurrentImageRequest];
    _imageView.image = nil;
    
    if (_isDelete) {
        _imageView.image = [KMStatusHelper imageNamed:@"compose_emotion_delete"];
    } else if (_emoticon) {
        if (_emoticon.type == KMEmoticonTypeEmoji) {
            //emoji表情,直接从bundle文件中读取
            NSString *pngPath = [[KMStatusHelper emojiBundle] pathForScaledResource:_emoticon.png ofType:nil inDirectory:_emoticon.group.groupID];
            
            if (pngPath) {
                [_imageView setImageWithURL:[NSURL fileURLWithPath:pngPath] options:YYWebImageOptionIgnoreDiskCache];
            }
        }
    }
}

- (void)updateLayout {
    _imageView.center = CGPointMake(self.width / 2, self.height / 2);
}
@end
