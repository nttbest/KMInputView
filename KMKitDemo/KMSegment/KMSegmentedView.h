//
//  KMSegmentedView.h
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

#define kBFBColor0 [UIColor colorWithHexString:@"#ff6600"]        //项目主色调橘黄色
#define kBFBColor1 [UIColor colorWithHexString:@"8d8d8d"]         //灰色
#define kBFBColor2 [UIColor colorWithHexString:@"#EFEFEF"]        //更淡的灰色,一般用作背景色
#define kBFBColor3 [UIColor colorWithHexString:@"#1d9437"]        //绿色
#define kBFBColor4 [UIColor colorWithHexString:@"#CCCCCC"]        //淡灰色
#define kBFBColor6 [UIColor colorWithHexString:@"#666666"]         //接近黑色

@class KMSegmentedItem;

@protocol KMSegmentedViewDelegate
- (void)segmentedViewSelectionDidChanged:(id)sender item:(KMSegmentedItem *)item;
@end

@interface KMSegmentedView : UIView

@property (nonatomic, strong)id <KMSegmentedViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign, setter=setCurrentSelectedIndex:) NSUInteger currentSelectedIndex;
//title
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
//font
@property (nonatomic, strong) UIFont *titleFont;
//item selectedBackground  Color;
@property (nonatomic, strong) UIColor *itemBackgroundColor;
@property (nonatomic, strong) UIColor *selectedItemBackgroundColor;
//item selectedBackground image;
@property (nonatomic, strong) UIImage *itemBackgroundImage;
@property (nonatomic, strong) UIImage *selectedItemBackgroundImage;
//item border
@property (nonatomic, strong) UIColor *itemBorderColor;
@property (nonatomic, assign) BOOL isShowItemBorderWhenHilight;
@property (nonatomic, assign) NSUInteger itemBorderWidth;
@property (nonatomic, assign) NSUInteger itemCornerRadius;
//item, 不设置则均分控件宽度
@property (nonatomic, assign) NSUInteger itemWidth;
@property (nonatomic, assign) NSUInteger itemSpace;
//允许触发当前已选项的点击事件
@property (nonatomic, assign) BOOL enablSelectCurrentItem;
//control border
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL isShowBorder;
@property (nonatomic, assign) NSUInteger borderWidth;
@property (nonatomic, assign) NSUInteger cornerRadius;
//分割线
@property (nonatomic, strong) UIColor *splitColor;
@property (nonatomic, assign) NSUInteger splitBorderWidth;
@property (nonatomic, assign) BOOL isShowSplitBorder;
//bottom line
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, strong) UIColor *selectedBottomLineColor;
@property (nonatomic, assign) CGFloat bottomLineHeight;

- (void)setTitle:(NSString *)title forIndex:(NSUInteger)idx;
- (void)setAttributedTitle:(NSMutableAttributedString *)title forIndex:(NSUInteger)idx;

@end
