//
//  KMEmojiCollectionViewCell.h
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMModel.h"

@interface KMEmojiCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) KMEmoticon *emoticon;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) UIImageView *imageView;
@end
