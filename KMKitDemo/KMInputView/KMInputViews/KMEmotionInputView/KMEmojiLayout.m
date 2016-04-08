//
//  KMEmojiLayout.m
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "KMEmojiLayout.h"

@implementation KMEmojiLayout{
    NSMutableArray *_array;
}

- (instancetype)init{
    if (self = [super init]){
        _array = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    [_array removeAllObjects];

    NSInteger sectionsNumber = [self.collectionView numberOfSections];
    NSMutableArray *attributes = [NSMutableArray array];
    for (int j = 0; j < sectionsNumber; j++) {
        for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:j ]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    _array = [attributes mutableCopy];
}

- (CGSize)collectionViewContentSize{
    NSInteger numberInPage = [self.collectionView numberOfSections];
    CGFloat contentHeight = self.collectionView.bounds.size.height;
    CGFloat contentWidth = self.collectionView.bounds.size.width * numberInPage;
    return CGSizeMake(contentWidth, contentHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeZero;
    int columnCount = 0;
    if (indexPath.section < [[self.emoticonGroupPageCounts firstObject] integerValue]){
        itemSize = self.emojiItemSize;
        columnCount = 7;
    }else{
        itemSize = self.gifItemSize;
        columnCount = 4;
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger pageCount = indexPath.section;
    //每页的x基坐标
    CGFloat baseX = (pageCount * self.collectionView.frame.size.width);
    // 行数和列数
    NSInteger row = (indexPath.item / columnCount);
    NSInteger col = (indexPath.item % columnCount);

    //在对应页中的x坐标
    CGFloat xInPage = (itemSize.width / 2) + ((col == 0) ? 0 : col * itemSize.width);

    /**
     *  @author kevinma, 16-01-07 14:01:26
     *
     *  @brief calculate position x
     */
    CGFloat x = 0;
    if (indexPath.section < [[self.emoticonGroupPageCounts firstObject] integerValue]) {
        x = baseX + xInPage + self.emojiSectionInset.left;
    }else{
        x = baseX + xInPage + self.gifSectionInset.left;
    }

    /**
     *  @author kevinma, 16-01-07 14:01:45
     *
     *  @brief calculate position y
     */
    CGFloat y = 0;
    if (indexPath.section < [[self.emoticonGroupPageCounts firstObject] integerValue]) {
        y = (itemSize.height / 2) + (row == 0 ? 0 : row * itemSize.height) + self.emojiSectionInset.top;
    }else{
        y = (itemSize.height / 2) + (row == 0 ? 0 : row * itemSize.height) + self.gifSectionInset.top;
    }
    
    attributes.center = CGPointMake(x, y);
    attributes.size = itemSize;
    attributes.zIndex = indexPath.item;
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
