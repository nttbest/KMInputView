//
//  KMEmojiLayout.h
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMEmojiLayout : UICollectionViewLayout

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGSize emojiItemSize;
@property (nonatomic) CGSize gifItemSize;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) UIEdgeInsets emojiSectionInset;
@property (nonatomic) UIEdgeInsets gifSectionInset;

@property (nonatomic) CGFloat horizontalMargin;
@property (nonatomic) CGFloat virtualMargin;

@property (nonatomic, strong) NSArray *emoticonGroupPageIndexs;
@property (nonatomic, strong) NSArray *emoticonGroupPageCounts;
@property (nonatomic, assign) NSInteger emoticonGroupTotalPageCount;

@end
