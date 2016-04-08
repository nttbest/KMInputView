//
//  KMGifCollectionViewCell.h
//  Toon
//
//  Created by kevinma on 16/1/7.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMModel.h"

@interface KMGifCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) KMEmoticon *emoticon;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end
