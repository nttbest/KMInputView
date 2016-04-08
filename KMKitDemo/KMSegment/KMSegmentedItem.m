//
//  KMSegmentedItem.m
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import "KMSegmentedItem.h"

@implementation KMSegmentedItem

#pragma mark - life cycle

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.imgView];
    [self addSubview:self.textLabel];
    [self addSubview:self.bottomLine];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.width = self.width;
    
    self.imgView.width = self.imgView.image.size.width;
    self.imgView.height = self.imgView.image.size.height;
    self.imgView.centerY = self.height/2-5;
    self.imgView.centerX = self.width/2;
    self.textLabel.centerX = self.imgView.centerX;
    if (self.imgView.height > 0) {
        self.textLabel.top = self.imgView.bottom + 2;
    } else {
        self.textLabel.centerY = self.height/2;
    }
    
    self.bottomLine.width = self.width;
    self.bottomLine.top = self.height - self.bottomLine.height;
}

#pragma mark - setter & getter 

- (void)setItemTitle:(NSString *)itemTitle {
    _itemTitle = [itemTitle mutableCopy];
    self.textLabel.text = itemTitle;
}

- (void)setItemImage:(UIImage *)itemImage {
    _itemImage = itemImage;
    self.imgView.image = itemImage;
}

- (void)setItemSelectedImage:(UIImage *)itemSelectedImage {
    _itemSelectedImage = itemSelectedImage;
    self.imgView.highlightedImage = itemSelectedImage;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.imgView.highlighted = isSelected;
    
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString {
    _attributedString = attributedString;
    self.textLabel.attributedText = attributedString;
}


- (UIImageView *)imgView{
    if (!_imgView) {
        UIImageView* imgView = [UIImageView new];
        imgView.frame = self.bounds;
        imgView.contentMode = UIViewContentModeTop;
        _imgView = imgView;
    }
    return _imgView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:titleLabel.font.fontName size:10];
        _textLabel = titleLabel;
    }
    return _textLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

@end
