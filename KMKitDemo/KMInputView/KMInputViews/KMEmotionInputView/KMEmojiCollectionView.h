//
//  KMEmojiCollectionView.h
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KMEmojiCollectionViewCell,KMGifCollectionViewCell;

@protocol KMEmojiCollectionViewDelegate <UICollectionViewDelegate>
- (void)emojiCollectionViewDidTapEmojiCell:(KMEmojiCollectionViewCell *)cell;
- (void)emojiCollectionViewDidTapGifCell:(KMGifCollectionViewCell *)cell;
@end

@interface KMEmojiCollectionView : UICollectionView

@property (nonatomic) NSInteger emojiSectionNumber;

@end
