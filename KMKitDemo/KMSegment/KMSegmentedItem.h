//
//  KMSegmentedItem.h
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@class KMSegmentedControl;
@class KMSegmentedData;

@interface KMSegmentedItem : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) UIImage *itemSelectedImage;
@property (nonatomic, strong) NSObject *attachObject;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) KMSegmentedData *data;
@property (nonatomic, strong) KMSegmentedControl *segmentedControl;

@property (nonatomic, copy)   NSString *itemTitle;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL isSelected;

@end
