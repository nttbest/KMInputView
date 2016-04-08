//
//  KMGifCollectionViewCell.m
//  Toon
//
//  Created by kevinma on 16/1/7.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "KMGifCollectionViewCell.h"
#import "YYKit.h"
#import "KMStatusHelper.h"
#import "TNEUtil.h"

@implementation KMGifCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup{
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(50, 50);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    
    _label = [UILabel new];
    _label.size = CGSizeMake(_imageView.width, 20);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = UIColorHex(6F7680);
    _label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_label];
}

- (void)setEmoticon:(KMEmoticon *)emoticon {
    if (_emoticon == emoticon) return;
    _emoticon = emoticon;
    [self updateContent];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateContent {
    [_imageView cancelCurrentImageRequest];
    _imageView.image = nil;
    _label.text = @"";
    
   if (_emoticon) {
       if (_emoticon.type == KMEmoticonTypeGif) {
            //jif动画,从数据库指定路径读取
            NSString *emoji_decompressPath = [TNEUtil tne_imageCachPath];
            NSString *emojiPath = [[emoji_decompressPath stringByAppendingPathComponent:_emoticon.group.groupID] stringByAppendingPathComponent:_emoticon.gif];
            
            if (emojiPath){
                [_imageView setImageWithURL:[NSURL fileURLWithPath:emojiPath] options:YYWebImageOptionIgnoreDiskCache];
            }
           _label.text = _emoticon.name;
        }
    }
}

- (void)updateLayout {
    _imageView.top = 5;
    _imageView.centerX = self.width / 2.0;
    
    _label.centerX = _imageView.centerX;
    _label.top = _imageView.bottom + 2;
}

@end
