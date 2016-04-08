//
//  KMEmoticonInputView.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/17.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMEmoticonInputView.h"
#import "KMStatusHelper.h"
#import "KMModel.h"
#import "YYKit.h"
#import "TNEUtil.h"
#import "KMEmojiCollectionViewCell.h"
#import "KMGifCollectionViewCell.h"
#import "KMEmojiCollectionView.h"
#import "KMEmojiLayout.h"

#define kViewHeight 216
#define kToolbarHeight 40
#define KToolbarButtonWidth 65

#define kOneEmojiHeight 50
#define kOneGifHeight 80

#define kOnePageEmojiCount 20
#define KOnePageGifCount 8


@interface KMEmoticonInputView () < UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UIInputViewAudioFeedback,
                                    KMEmojiCollectionViewDelegate>

@property (nonatomic, strong) KMEmojiCollectionView *emojiCollectionView;
@property (nonatomic, strong) UIView *pageControl;

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSArray *toolbarButtons;

@property (nonatomic, strong) NSMutableArray *emoticonGroups; ///< Array<WBEmoticonGroup>
@property (nonatomic, strong) NSMutableArray *emoticonGroupPageIndexs; ///< Array<NSNumber>
@property (nonatomic, strong) NSMutableArray *emoticonGroupPageCounts; ///< Array<NSNumber>
@property (nonatomic, assign) NSInteger emoticonGroupTotalPageCount;

@property (nonatomic, strong) NSArray *emojiGroups; ///< Array<WBEmoticonGroup>
@property (nonatomic, strong) NSArray *emojiGroupPageIndexs; ///< Array<NSNumber>
@property (nonatomic, strong) NSArray *emojiGroupPageCounts; ///< Array<NSNumber>
@property (nonatomic, assign) NSInteger emojiGroupTotalPageCount;

@property (nonatomic, strong) NSArray *gifGroups; ///< Array<WBEmoticonGroup>
@property (nonatomic, strong) NSArray *gifGroupPageIndexs; ///< Array<NSNumber>
@property (nonatomic, strong) NSArray *gifGroupPageCounts; ///< Array<NSNumber>
@property (nonatomic, assign) NSInteger gifGroupTotalPageCount;

@property (nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation KMEmoticonInputView

#pragma mark - life cycle
+ (instancetype)sharedView {
    static KMEmoticonInputView *v;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [self new];
    });
    return v;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KTNEFaceBagDidChangeNotification
                                                  object:nil];
}

- (void)setup{
    self.frame = CGRectMake(0, 0, kScreenWidth, kViewHeight);
    self.backgroundColor = UIColorHex(FFFFFF);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(faceBagDidChangeAction:)
                                                 name:KTNEFaceBagDidChangeNotification
                                               object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self _refreshEmotionData];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self addSubview:self.emojiCollectionView];
            self.emojiCollectionView.emojiSectionNumber = [[self.emoticonGroupPageCounts firstObject] integerValue];
            [self addSubview:self.pageControl];
            [self addSubview:self.toolbar];
            [self.toolbar addSubview:self.scrollView];
            [self.toolbar addSubview:self.sendButton];

            self.toolbar.bottom = self.height;
            [self _refreshToolbarButtons];
            _currentPageIndex = NSNotFound;
            [self toolbarButtonDidTapped:_toolbarButtons.firstObject];
        });
    });
}


#pragma mark - setter & getter

- (KMEmojiLayout *)calculateEmojiLayout{
    
    CGFloat emojiItemWidth = (kScreenWidth - 10 * 2) / 7.0;
    emojiItemWidth = CGFloatPixelRound(emojiItemWidth);
    CGFloat emojiPadding = (kScreenWidth - 7 * emojiItemWidth) / 2.0;
    CGFloat emojiPaddingLeft = CGFloatPixelRound(emojiPadding);
    CGFloat emojiPaddingRight = kScreenWidth - emojiPaddingLeft - emojiItemWidth * 7;
    
    CGFloat gifItemWidth = (kScreenWidth - 20 * 2) / 4.0;
    gifItemWidth = CGFloatPixelRound(gifItemWidth);
    CGFloat gifPadding = (kScreenWidth - 4 * gifItemWidth) / 2.0;
    CGFloat gifPaddingLeft = CGFloatPixelRound(gifPadding);
    CGFloat gifPaddingRight = kScreenWidth - gifPaddingLeft - gifItemWidth * 4;
    
    CGFloat minimumLineSpacing = 0;
    CGFloat minimumInteritemSpacing = 0;
    UIEdgeInsets emojiSectionInset = UIEdgeInsetsMake(0, emojiPaddingLeft, 0, emojiPaddingRight);
    UIEdgeInsets gifSectionInset = UIEdgeInsetsMake(0, gifPaddingLeft, 0, gifPaddingRight);

    KMEmojiLayout *layout = [KMEmojiLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.emojiItemSize = CGSizeMake(emojiItemWidth, kOneEmojiHeight);
    layout.gifItemSize = CGSizeMake(gifItemWidth, kOneGifHeight);
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    layout.emojiSectionInset = emojiSectionInset;
    layout.gifSectionInset = gifSectionInset;
    
    layout.emoticonGroupPageIndexs = self.emoticonGroupPageIndexs;
    layout.emoticonGroupPageCounts = self.emoticonGroupPageCounts;
    layout.emoticonGroupTotalPageCount = self.emoticonGroupTotalPageCount;
    
    return layout;
}

- (KMEmojiCollectionView *)emojiCollectionView{
    if (!_emojiCollectionView) {
        KMEmojiCollectionView *collectionView = [[KMEmojiCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kViewHeight - kToolbarHeight) collectionViewLayout:[self calculateEmojiLayout]];
        [collectionView registerClass:[KMEmojiCollectionViewCell class] forCellWithReuseIdentifier:@"emojiCell"];
        [collectionView registerClass:[KMGifCollectionViewCell class] forCellWithReuseIdentifier:@"gifCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.top = 5;
        _emojiCollectionView = collectionView;
    }
    return _emojiCollectionView;
}


- (UIView *)pageControl{
    if (!_pageControl) {
        UIView *pageControl = [UIView new];
        pageControl.size = CGSizeMake(kScreenWidth, 20);
        pageControl.bottom = _emojiCollectionView.bottom - 10;
        pageControl.userInteractionEnabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIView *)toolbar{
    if (!_toolbar) {
        UIView *toolbar = [UIView new];
        toolbar.size = CGSizeMake(kScreenWidth, kToolbarHeight);
        _toolbar = toolbar;
    }
    return _toolbar;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.size = CGSizeMake(kScreenWidth - KToolbarButtonWidth, kToolbarHeight);
        scrollView.contentSize = CGSizeMake(kScreenWidth, kToolbarHeight);
        [scrollView setBackgroundColor:UIColorHex(F8F8F8)];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.size = CGSizeMake( 65, kToolbarHeight);
        sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(007AFF) size:sendButton.size] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(FFFFFF) size:sendButton.size] forState:UIControlStateSelected];
        [sendButton addTarget:self action:@selector(toolbarSendBtnDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        sendButton.bottom = self.toolbar.bottom;
        sendButton.right = self.toolbar.right;
        _sendButton = sendButton;
    }
    return _sendButton;
}

- (NSMutableArray *)emoticonGroups{
    if (!_emoticonGroups) {
        _emoticonGroups = [NSMutableArray array];
    }
    return _emoticonGroups;
}

- (NSMutableArray *)emoticonGroupPageIndexs{
    if (!_emoticonGroupPageIndexs) {
        _emoticonGroupPageIndexs = [NSMutableArray array];
    }
    return _emoticonGroupPageIndexs;
}

- (NSMutableArray *)emoticonGroupPageCounts{
    if (!_emoticonGroupPageCounts) {
        _emoticonGroupPageCounts = [NSMutableArray array];
    }
    return _emoticonGroupPageCounts;
}


#pragma mark - private methods
#pragma mark deal with data
- (void)_refreshEmotionData{
    //重置数据源
    [self _resetDataSource];
    
    //刷新emoji,gif数据
    [self _refreshEmojiData];
    [self _refreshGifData];
    
    //生成新的数据源
    self.emoticonGroupTotalPageCount = self.emojiGroupTotalPageCount + self.gifGroupTotalPageCount;
    [self.emoticonGroups addObjectsFromArray:self.emojiGroups];
    [self.emoticonGroups addObjectsFromArray:self.gifGroups];
    [self.emoticonGroupPageCounts addObjectsFromArray:self.emojiGroupPageCounts];
    [self.emoticonGroupPageCounts addObjectsFromArray:self.gifGroupPageCounts];
    [self.emoticonGroupPageIndexs addObjectsFromArray:self.emojiGroupPageIndexs];
    NSMutableArray *tempArray = [self.gifGroupPageIndexs mutableCopy];
    for (int i = 0; i < self.emojiGroupPageIndexs.count; i++) {
        NSNumber *number = [self.emojiGroupPageCounts objectAtIndex:i];
        NSInteger integer = [number integerValue];
        for (int j = 0; j < tempArray.count; j++) {
            NSNumber *gifNumber = [tempArray objectAtIndex:j];
            NSInteger gifInteger = [gifNumber integerValue];
            gifInteger += integer;
            [tempArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:gifInteger]];
        }
    }
    [self.emoticonGroupPageIndexs addObjectsFromArray:tempArray];
}

- (void)_resetDataSource{
    //清空数据源
    if (self.emoticonGroups.count > 0) {
        [self.emoticonGroups removeAllObjects];
    }
    if (self.emoticonGroupPageIndexs.count > 0) {
        [self.emoticonGroupPageIndexs removeAllObjects];
    }
    if (self.emoticonGroupPageCounts.count > 0) {
        [self.emoticonGroupPageCounts removeAllObjects];
    }
    
    if (self.gifGroups.count > 0) {
        self.gifGroups = nil;
    }
    if (self.gifGroupPageIndexs.count > 0) {
        self.gifGroupPageIndexs = nil;
    }
    if (self.gifGroupPageCounts.count > 0) {
        self.gifGroupPageCounts = nil;
    }
    
    self.emoticonGroupTotalPageCount = 0;
    self.gifGroupTotalPageCount = 0;
    self.currentPageIndex = NSNotFound;
}


- (void)_refreshEmojiData{
    
    _emojiGroups = [KMStatusHelper emojiGroups];
    
    if (_emojiGroups.count < 1)  return;
    
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    for (KMEmoticonGroup *group in _emojiGroups) {
        [indexs addObject:@(index)];
        NSUInteger count = ceil(group.emotions.count / (float)kOnePageEmojiCount);
        if (count == 0) count = 1;
        index += count;
    }
    _emojiGroupPageIndexs = indexs;
    
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emojiGroupTotalPageCount = 0;
    for (KMEmoticonGroup *group in _emojiGroups) {
        NSUInteger pageCount = ceil(group.emotions.count / (float)kOnePageEmojiCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _emojiGroupTotalPageCount += pageCount;
    }
    _emojiGroupPageCounts = pageCounts;
}

- (void)_refreshGifData{
    
    _gifGroups = [KMStatusHelper gifGroups];
    if (!_gifGroups || _gifGroups.count < 1){
        return;
    }
    
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    for (KMEmoticonGroup *group in _gifGroups) {
        [indexs addObject:@(index)];
        NSUInteger count = ceil(group.emotions.count / (float)KOnePageGifCount);
        if (count == 0) count = 1;
        index += count;
    }
    _gifGroupPageIndexs = indexs;
    
    NSMutableArray *pageCounts = [NSMutableArray new];
    _gifGroupTotalPageCount = 0;
    for (KMEmoticonGroup *group in _gifGroups) {
        NSUInteger pageCount = ceil(group.emotions.count / (float)KOnePageGifCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _gifGroupTotalPageCount += pageCount;
    }
    _gifGroupPageCounts = pageCounts;
}

#pragma mark private method
- (void)_refreshToolbarButtons{
    
    //清空srcollView上所有button
    [self.scrollView removeAllSubviews];
    self.scrollView.contentSize = CGSizeMake(KToolbarButtonWidth * (_emoticonGroups.count + 1), kToolbarHeight);
    
    NSMutableArray *btns = [NSMutableArray new];
    UIButton *btn;
    for (NSUInteger i = 0; i < _emoticonGroups.count; i++) {
        KMEmoticonGroup *group = _emoticonGroups[i];
        btn = [self _createToolbarButton];
        
        UIImageView *imageView = [UIImageView new];
        imageView.size = CGSizeMake(28, 28);
        imageView.backgroundColor = [UIColor clearColor];
        imageView.center = btn.center;
        [btn addSubview:imageView];
        
        if (i == 0) {
            KMEmoticon *emotion = [group.emotions firstObject];
            //emoji表情,直接从bundle文件中读取
            NSString *pngPath = [[KMStatusHelper emojiBundle] pathForScaledResource:emotion.png ofType:nil inDirectory:emotion.group.groupID];
            
            if (pngPath) {
                [imageView setImageWithURL:[NSURL fileURLWithPath:pngPath] options:YYWebImageOptionIgnoreDiskCache];
            }
        }else {
            if (group.logoUrl) {
                
                NSString *decodeUrl = [group.logoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [imageView setImageWithURL:[NSURL URLWithString:decodeUrl] options:YYWebImageOptionIgnorePlaceHolder];
            }
        }
        
        btn.left =  KToolbarButtonWidth * i;
        btn.tag = i;
        [self.scrollView addSubview:btn];
        [btns addObject:btn];
    }

    btn = [self _createAddButton];
    btn.left = KToolbarButtonWidth * _emoticonGroups.count;
    [self.scrollView addSubview:btn];
    
    
    _toolbarButtons = btns;
    
}

- (UIButton *)_createToolbarButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake( KToolbarButtonWidth, kToolbarHeight );

    UIImage *img;
    img = [KMStatusHelper imageNamed:@"compose_emotion_table_left_normal"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    img = [KMStatusHelper imageNamed:@"compose_emotion_table_left_selected"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(toolbarButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)_createAddButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake( KToolbarButtonWidth, kToolbarHeight );
    
    UIImage *image = [KMStatusHelper imageNamed:@"compose_emotion_table_left_normal"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    [btn setImage:[KMStatusHelper imageNamed:@"EmotionsBagAdd"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toolbarAddBtnDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (KMEmoticon *)_emoticonForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        
        if (i > 0) {
            NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
            if (section >= pageIndex.unsignedIntegerValue) {
                KMEmoticonGroup *group = _emoticonGroups[i];
                NSUInteger page = section - pageIndex.unsignedIntegerValue;
                NSUInteger index = page * KOnePageGifCount + indexPath.row;
                
                if (index < group.emotions.count) {
                    return group.emotions[index];
                } else {
                    return nil;
                }
            }
        }else if (i == 0) {

            NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
            if (section >= pageIndex.unsignedIntegerValue) {
                KMEmoticonGroup *group = _emoticonGroups[i];
                NSUInteger page = section - pageIndex.unsignedIntegerValue;
                NSUInteger index = page * kOnePageEmojiCount + indexPath.row;

                if (index < group.emotions.count) {
                    return group.emotions[index];
                } else {
                    return nil;
                }
            }
        }
        
    }
    return nil;
}


#pragma mark - event methods
- (void)faceBagDidChangeAction:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self _refreshEmotionData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.emojiCollectionView.emojiSectionNumber = [[self.emoticonGroupPageCounts firstObject] integerValue];

            [self.emojiCollectionView reloadData];
            @weakify(self)
            [self.emojiCollectionView performBatchUpdates:^{
                @strongify(self)
                [self.emojiCollectionView.collectionViewLayout invalidateLayout];
                [self.emojiCollectionView setCollectionViewLayout:[self calculateEmojiLayout] animated:YES];
            } completion:^(BOOL finished) {
            }];
            
            [self _refreshToolbarButtons];
            [self toolbarButtonDidTapped:_toolbarButtons.firstObject];
        });
    });
}

- (void)toolbarButtonDidTapped:(UIButton *)button {
    NSInteger groupIndex = button.tag;
    NSInteger page = ((NSNumber *)_emoticonGroupPageIndexs[groupIndex]).integerValue;
    CGRect rect = CGRectMake(page * _emojiCollectionView.width, 0, _emojiCollectionView.width, _emojiCollectionView.height);
    [_emojiCollectionView scrollRectToVisible:rect animated:NO];
    [self scrollViewDidScroll:_emojiCollectionView];
}

- (void)toolbarSendBtnDidTapped:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapSend)]) {
        [self.delegate emoticonInputDidTapSend];
    }
}

- (void)toolbarAddBtnDidTapped:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapAdd)]){
        [self.delegate emoticonInputDidTapAdd];
    }
}




#pragma mark - KMEmojiCollectionViewDelegate

- (void)emojiCollectionViewDidTapEmojiCell:(KMEmojiCollectionViewCell *)cell {
    if (!cell) {
        return;
    }
    if (cell.isDelete) {
        if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapBackspace)]) {
            [[UIDevice currentDevice] playInputClick];
            [self.delegate emoticonInputDidTapBackspace];
        }
    } else if (cell.emoticon) {
        NSString *text = nil;
        switch (cell.emoticon.type) {
            case KMEmoticonTypeGif: {
                //TODO:点击gif动画,直接发送
            } break;
            case KMEmoticonTypeEmoji: {
                text = cell.emoticon.chs;
            } break;
            default:break;
        }
        if (text && [self.delegate respondsToSelector:@selector(emoticonInputDidTapText:)]) {
            [self.delegate emoticonInputDidTapText:text];
        }
    }
}

- (void)emojiCollectionViewDidTapGifCell:(KMEmojiCollectionViewCell *)cell{
    if (cell) {
        if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapGif:)]) {
            [self.delegate emoticonInputDidTapGif:cell.emoticon];
        }
    }
}



#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    if (page < 0) page = 0;
    else if (page >= _emoticonGroupTotalPageCount) page = _emoticonGroupTotalPageCount - 1;
    if (page == _currentPageIndex) return;
    _currentPageIndex = page;
    NSInteger curGroupIndex = 0, curGroupPageIndex = 0, curGroupPageCount = 0;
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (page >= pageIndex.unsignedIntegerValue) {
            curGroupIndex = i;
            curGroupPageIndex = ((NSNumber *)_emoticonGroupPageIndexs[i]).integerValue;
            curGroupPageCount = ((NSNumber *)_emoticonGroupPageCounts[i]).integerValue;
            break;
        }
    }
    [_pageControl.layer removeAllSublayers];
    CGFloat padding = 5, width = 6, height = 6;
    CGFloat pageControlWidth = (width + 2 * padding) * curGroupPageCount;
    for (NSInteger i = 0; i < curGroupPageCount; i++) {
        CALayer *layer = [CALayer layer];
        layer.size = CGSizeMake(width, height);
        layer.cornerRadius = 3;
        if (page - curGroupPageIndex == i) {
            layer.backgroundColor = UIColorHex(777e8c).CGColor;
        } else {
            layer.backgroundColor = UIColorHex(dddee3).CGColor;
        }
        layer.centerY = _pageControl.height - 5;
        layer.left = (_pageControl.width - pageControlWidth) / 2 + i * (width + 2 * padding) + padding;
        [_pageControl.layer addSublayer:layer];
    }
    [_toolbarButtons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.selected = (idx == curGroupIndex);
        if (0 == curGroupIndex){
            [UIView animateWithDuration:.25
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.sendButton.right = kScreenWidth;
                                 self.scrollView.size = CGSizeMake(kScreenWidth - KToolbarButtonWidth, kToolbarHeight);
                             } completion:NULL];
            
        }else{
            [UIView animateWithDuration:.25
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.sendButton.left = kScreenWidth;
                                 self.scrollView.size = CGSizeMake(kScreenWidth, kToolbarHeight);
                             } completion:NULL];
        }
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _emoticonGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < [[self.emoticonGroupPageCounts firstObject] integerValue]) {
        return kOnePageEmojiCount + 1;
    }else{
        return KOnePageGifCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KMEmojiCollectionViewCell *emojiCell = nil;
    KMGifCollectionViewCell *gifCell = nil;
    
    if (indexPath.section < [[self.emoticonGroupPageCounts firstObject] integerValue]) {
        
        emojiCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCell" forIndexPath:indexPath];
        if (indexPath.row == kOnePageEmojiCount) {
            emojiCell.isDelete = YES;
            emojiCell.emoticon = nil;
        } else {
            emojiCell.isDelete = NO;
            emojiCell.emoticon = [self _emoticonForIndexPath:indexPath];
        }
        return emojiCell;
        
    }else{
        
        gifCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gifCell" forIndexPath:indexPath];
        gifCell.emoticon = [self _emoticonForIndexPath:indexPath];
        return gifCell;
    }
    
    return nil;
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

@end
