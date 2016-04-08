//
//  KMSegmentedView.m
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import "KMSegmentedView.h"
#import "KMSegmentedItem.h"

@interface KMSegmentedView (){
    UIScrollView *_scrollView;
}
@end

@implementation KMSegmentedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = self.backgroundColor;
        [self addSubview:_scrollView];
        
        _dataSource = [NSMutableArray array];
        _selectedTitleColor = [UIColor whiteColor];
        _titleColor = [UIColor blackColor];
        _itemBackgroundColor = [UIColor whiteColor];
        _selectedItemBackgroundColor = [UIColor whiteColor];
        
        _borderWidth = 1;
        _borderColor = kBFBColor0;
        _cornerRadius = 5;
        
        _itemBorderColor = kBFBColor0;
        _itemBorderWidth = 1;
        _itemCornerRadius = 0;
        
        _titleFont = [UIFont systemFontOfSize:12];
        
        _splitColor = kBFBColor0;
        _splitBorderWidth = 1;
        
        _isShowBorder = NO;
        _isShowItemBorderWhenHilight = NO;
        _isShowSplitBorder = NO;
        
        _bottomLineHeight = 2;
        _bottomLineColor = kBFBColor1;
        _selectedBottomLineColor = kBFBColor0;
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)initItemControl:(KMSegmentedItem *)btn {
    
    if (_itemBackgroundImage) {
        btn.itemImage = _itemBackgroundImage;
    }
    
    if (_selectedItemBackgroundImage) {
        btn.itemSelectedImage = _itemBackgroundImage;
    }
    
    if(_itemBackgroundColor)
    {
        [btn setBackgroundColor:_itemBackgroundColor];
    }
    
    btn.textLabel.font = _titleFont;
    if ([btn.itemTitle length] > 0) {
        btn.textLabel.numberOfLines = 0;
    }
    
    if (_bottomLineHeight > 0) {
        btn.bottomLine.height = _bottomLineHeight;
    }

    btn.layer.cornerRadius = _itemCornerRadius;
}

- (void)refreshUI {
    if (_isShowBorder) {
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.cornerRadius = _cornerRadius;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) reloadData {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([_dataSource count] > 0) {
        
        __block CGRect fra = CGRectMake(
                                        0,
                                        0,
                                        _itemWidth > 0 ? _itemWidth : (CGFloat)(self.width-self.itemSpace*([_dataSource count]-1)) / [_dataSource count],
                                        self.height);
        
        CGFloat leftMargin = 0;
        __block CGFloat contentWidth = leftMargin;
        [self.dataSource enumerateObjectsUsingBlock:^(KMSegmentedItem *item, NSUInteger idx, BOOL *stop) {
            item.frame = fra;
            [self initItemControl:item];
            item.left = leftMargin + idx * (item.width+self.itemSpace);
            UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapped:)];
            [item setUserInteractionEnabled:YES];
            [item addGestureRecognizer:recognizer];
            
            item.index = idx;
            [_scrollView addSubview:item];
            
            if (_isShowSplitBorder && idx != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _splitBorderWidth, item.height)];
                line.backgroundColor = _splitColor;
                line.left = item.left;
                [_scrollView addSubview:line];
            }
            contentWidth = item.right;
        }];
        
        _scrollView.contentSize = CGSizeMake(contentWidth, _scrollView.height);
        
        [self setCurrentSelectedIndex:0];
        [self refreshUI];
    }
}

- (void) btnTapped:(UITapGestureRecognizer *) sender {
    KMSegmentedItem *btn = (KMSegmentedItem *)sender.view;
    if (!self.enablSelectCurrentItem && self.currentSelectedIndex == btn.index) {
        return;
    }
    
    [self setCurrentSelectedIndex:btn.index];
    
    if ([(NSObject *) (self.delegate) respondsToSelector:@selector(segmentedViewSelectionDidChanged:item:)]) {
        [self.delegate segmentedViewSelectionDidChanged:self item:self.dataSource[btn.index]];
    }
}

//此方法只更新UI效果,不可发出代理!!!!!!代理应该由按钮点击事件发出!!!!!!!!
- (void) setCurrentSelectedIndex:(NSUInteger) currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[KMSegmentedItem class]]) {
            KMSegmentedItem *view = obj;
            if (view.index == currentSelectedIndex) {
                //                    [view setSelected:YES];
                view.isSelected = YES;
                [view setBackgroundColor:_selectedItemBackgroundColor];
                view.textLabel.textColor = _selectedTitleColor;
                view.bottomLine.backgroundColor = _selectedBottomLineColor;
                //如果在屏幕外则需要移动到屏幕中
                if (view.right - _scrollView.width > 0) {
                    _scrollView.contentOffset = CGPointMake(view.right - _scrollView.width, 0);
                } else if (view.left - _scrollView.contentOffset.x < 0) {
                    _scrollView.contentOffset = CGPointMake(view.left, 0);
                }
                
                if (_isShowItemBorderWhenHilight) {
                    view.layer.borderWidth = _borderWidth;
                    view.layer.borderColor = _borderColor.CGColor;
                    view.layer.cornerRadius = _cornerRadius;
                }
                
            } else {
                view.isSelected = NO;
                [view setBackgroundColor:_itemBackgroundColor];
                view.textLabel.textColor = _titleColor;
                view.bottomLine.backgroundColor = _bottomLineColor;
                
                view.layer.borderWidth = 0;
            }
            if (view.attributedString) {
                if (view.isSelected) {
                    [view.attributedString addAttribute:NSForegroundColorAttributeName
                                                  value:_selectedTitleColor
                                                  range:NSMakeRange(0, view.attributedString.length)];
                } else {
                    [view.attributedString addAttribute:NSForegroundColorAttributeName
                                                  value:_titleColor
                                                  range:NSMakeRange(0, view.attributedString.length)];
                }
            }
            
            
        }
        
    }];
}


- (void)setTitle:(NSString *)title forIndex:(NSUInteger)idx {
    if ([self.dataSource count] > idx) {
        KMSegmentedItem* btn = self.dataSource[idx];
        btn.itemTitle = title;
    }
}

- (void)setAttributedTitle:(NSMutableAttributedString *)title forIndex:(NSUInteger)idx {
    if ([self.dataSource count] > idx) {
        KMSegmentedItem* btn = self.dataSource[idx];
        if (btn.isSelected) {
            [title addAttribute:NSForegroundColorAttributeName
                          value:_selectedTitleColor
                          range:NSMakeRange(0, title.length)];
        } else {
            [title addAttribute:NSForegroundColorAttributeName
                          value:_titleColor
                          range:NSMakeRange(0, title.length)];
        }
        btn.attributedString = title;
    }
}

@end
