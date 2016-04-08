//
//  KMSegmentedControl.m
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import "KMSegmentedControl.h"
#import "KMSegmentedView.h"
#import "KMSegmentedItem.h"
#import "KMSegmentedData.h"

@interface KMSegmentedControl () <KMSegmentedViewDelegate>
@property (nonatomic ,strong ,readwrite) KMSegmentedView *segmentedView;
@property (nonatomic ,strong) UIImageView *highLigntImageView;
@end

@implementation KMSegmentedControl

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
    [self initDataSource];
    [self addSubview:self.segmentedView];
    [self initSegmentedView:self.segmentedView];
    
    NSMutableArray *items = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KMSegmentedItem *item = [[KMSegmentedItem alloc] init];
        KMSegmentedData *data = obj;
        item.itemTitle = data.title;
        item.itemImage= data.image;
        item.itemSelectedImage = data.selectedImage;
        item.attachObject = data;
        item.data = data;
        item.segmentedControl = self;
        [items addObject:item];
    }];
    
    self.segmentedView.dataSource = items;
    [self setOriginSelectedIndex:0];
}

#pragma mark - interface Methods

- (void)initDataSource {
    //override me！！！！
    self.dataSource = [NSMutableArray array];
}

- (void)initSegmentedView:(KMSegmentedView *)segmentedView {
    //override me！！！！
    
}

#pragma mark - KMSegmentedViewDelegate Methods

- (void)segmentedViewSelectionDidChanged:(id)sender item:(KMSegmentedItem *)item {
    
    [self showHighLightImageForItem:item];
    
    if ([(NSObject *) self.delegate respondsToSelector:@selector(segmentedControlSelectionDidChanged:)]) {
        [(NSObject *)self.delegate performSelector:@selector(segmentedControlSelectionDidChanged:)
                                        withObject:item ];
    }
}

- (void)setOriginSelectedIndex:(NSUInteger)idx {
    _originSelectedIndex = idx;
    [self showHighLightImageForItem: self.segmentedView.dataSource[idx]];
}


- (void)showHighLightImageForItem:(KMSegmentedItem *)itemButton {
    if (!self.isEnableIndicator) {
        return;
    }
    [self.highLigntImageView removeFromSuperview];
    self.highLigntImageView.centerX = itemButton.width / 2;
    self.highLigntImageView.top = itemButton.height - self.highLigntImageView.height + 8;
    [itemButton addSubview:self.highLigntImageView];
}

- (void)setSelectedIndex:(NSUInteger)index {
    if (self.segmentedView.dataSource.count > index) {
        self.segmentedView.currentSelectedIndex = index;
        [self showHighLightImageForItem:self.segmentedView.dataSource[index]];
    }
}

#pragma mark - setter & getter

- (KMSegmentedView *)segmentedView{
    if (!_segmentedView) {
        KMSegmentedView *segmentedView = [[KMSegmentedView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        segmentedView.delegate = self;
        segmentedView.titleColor = kBFBColor1;
        segmentedView.selectedTitleColor = kBFBColor0;
        segmentedView.enablSelectCurrentItem = YES;
        _segmentedView = segmentedView;
    }
    return _segmentedView;
}

- (UIImageView *)highLigntImageView{
    if (!_highLigntImageView) {
        UIImageView *highLigntImageView = [UIImageView new];
        highLigntImageView.image = [UIImage imageNamed:@"-btn_xuanxiang_sel"];
        highLigntImageView.contentMode = UIViewContentModeTop;
        highLigntImageView.width = 15;
        highLigntImageView.height = 15;
        _highLigntImageView = highLigntImageView;
    }
    return _highLigntImageView;
}

@end
