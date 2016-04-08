//
//  KMSegmentedControl.h
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@class KMSegmentedItem;
@class KMSegmentedView;

@protocol KMSegmentedControlDelegate
- (void)segmentedControlSelectionDidChanged:(KMSegmentedItem *)segmentedItem;
@end

@interface KMSegmentedControl : UIView

@property (nonatomic, weak) id<KMSegmentedControlDelegate> delegate;
@property (nonatomic, strong, readonly) KMSegmentedView *segmentedView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isEnableIndicator;
@property (nonatomic, assign) NSUInteger originSelectedIndex;

- (void)initDataSource;
- (void)initSegmentedView:(KMSegmentedView *)segmentedView;
- (void)setSelectedIndex:(NSUInteger)index;

@end
