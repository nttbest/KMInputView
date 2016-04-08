//
//  KMEmojiCollectionView.m
//  Toon
//
//  Created by kevinma on 16/1/6.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "KMEmojiCollectionView.h"
#import "KMEmojiCollectionViewCell.h"
#import "KMGifCollectionViewCell.h"
#import "KMStatusHelper.h"
#import "UIImage+GIF.h"
#import "TNEUtil.h"

@implementation KMEmojiCollectionView{
    NSTimeInterval *_touchBeganTime;
    BOOL _touchMoved;
    UIImageView *_emojiMagnifier;
    UIImageView *_gifMagnifier;
    UIImageView *_emojiMagnifierContent;
    UIImageView *_gifMagnifierContent;
    __weak KMEmojiCollectionViewCell *_currentEmojiMagnifierCell;
    __weak KMGifCollectionViewCell *_currentGifMagnifierCell;
    NSTimer *_backspaceTimer;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [UIView new];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.canCancelContentTouches = NO;
    self.multipleTouchEnabled = NO;
    _emojiMagnifier = [[UIImageView alloc] initWithImage:[KMStatusHelper imageNamed:@"emoticon_keyboard_magnifier"]];
    _emojiMagnifierContent = [UIImageView new];
    _emojiMagnifierContent.size = CGSizeMake(40, 40);
    _emojiMagnifierContent.centerX = _emojiMagnifier.width / 2;
    [_emojiMagnifier addSubview:_emojiMagnifierContent];
    
    
    UIImage *image = [KMStatusHelper imageNamed:@"emotion_keyboard_gifMagnifier"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    _gifMagnifier = [[UIImageView alloc] initWithImage:image];
    _gifMagnifier.size = CGSizeMake(93, 93);
    _gifMagnifierContent = [UIImageView new];
    _gifMagnifierContent.size = CGSizeMake(73, 73);
    _gifMagnifierContent.centerX = _gifMagnifier.width / 2;
    [_gifMagnifier addSubview:_gifMagnifierContent];
    
    _emojiMagnifier.hidden = YES;
    [self addSubview:_emojiMagnifier];
    _gifMagnifier.hidden = YES;
    [self addSubview:_gifMagnifier];
    
    return self;
    
}

- (void)dealloc {
    [self endBackspaceTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMoved = NO;
    KMEmojiCollectionViewCell *emojiCell= nil;
    KMGifCollectionViewCell *gifCell = nil;
    
    NSIndexPath *indexPath = [self indexPathForTouches:touches];
    if (indexPath.section < _emojiSectionNumber) {
        emojiCell = (KMEmojiCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        _currentEmojiMagnifierCell = emojiCell;
        [self showMagnifierForEmojiCell:_currentEmojiMagnifierCell];
        
        if (emojiCell.imageView.image && !emojiCell.isDelete) {
            [[UIDevice currentDevice] playInputClick];
        }
        
        if (emojiCell.isDelete) {
            [self endBackspaceTimer];
            [self performSelector:@selector(startBackspaceTimer) afterDelay:0.5];
        }
        
    }else{
        gifCell = (KMGifCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        _currentGifMagnifierCell = gifCell;
        [self showMagnifierForGifCell:_currentGifMagnifierCell];
        
        if (gifCell.imageView.image) {
            [[UIDevice currentDevice] playInputClick];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMoved = YES;
    if (_currentEmojiMagnifierCell && _currentEmojiMagnifierCell.isDelete) return;
    
    KMEmojiCollectionViewCell *emojiCell= nil;
    KMGifCollectionViewCell *gifCell = nil;
    NSIndexPath *indexPath = [self indexPathForTouches:touches];
    if (indexPath.section < _emojiSectionNumber) {
        emojiCell = (KMEmojiCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        if (emojiCell != _currentEmojiMagnifierCell) {
            if (!_currentEmojiMagnifierCell.isDelete && !emojiCell.isDelete) {
                _currentEmojiMagnifierCell = emojiCell;
            }
            [self showMagnifierForEmojiCell:emojiCell];
        }
    }else{
        gifCell = (KMGifCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        if (gifCell != _currentGifMagnifierCell) {
                _currentGifMagnifierCell = gifCell;
            [self showMagnifierForGifCell:gifCell];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    KMEmojiCollectionViewCell *emojiCell= nil;
    KMGifCollectionViewCell *gifCell = nil;
    NSIndexPath *indexPath = [self indexPathForTouches:touches];
    if (indexPath.section < _emojiSectionNumber) {
        emojiCell = (KMEmojiCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        if ((!_currentEmojiMagnifierCell.isDelete && emojiCell.emoticon) || (!_touchMoved && emojiCell.isDelete)) {
            if ([self.delegate respondsToSelector:@selector(emojiCollectionViewDidTapEmojiCell:)]) {
                [((id<KMEmojiCollectionViewDelegate>) self.delegate) emojiCollectionViewDidTapEmojiCell:emojiCell];
            }
        }
    }else{
        gifCell = (KMGifCollectionViewCell *)[self cellForIndexPath:indexPath];
        
        if ((emojiCell.emoticon) || (!_touchMoved)) {
            if ([self.delegate respondsToSelector:@selector(emojiCollectionViewDidTapGifCell:)]) {
                [((id<KMEmojiCollectionViewDelegate>) self.delegate) emojiCollectionViewDidTapGifCell:gifCell];
            }
        }
    }
    
    [self hideMagnifier];
    [self endBackspaceTimer];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (NSIndexPath *)indexPathForTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    return indexPath;
}

- (UICollectionViewCell *)cellForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath) {
        if (indexPath.section < _emojiSectionNumber) {
            KMEmojiCollectionViewCell *cell = (id)[self cellForItemAtIndexPath:indexPath];
            return cell;
        }else{
            KMGifCollectionViewCell *cell = (id)[self cellForItemAtIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}

- (void)showMagnifierForEmojiCell:(KMEmojiCollectionViewCell *)cell {
    if (cell.isDelete || !cell.imageView.image) {
        [self hideMagnifier];
        return;
    }
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _emojiMagnifier.centerX = CGRectGetMidX(rect);
    _emojiMagnifier.bottom = CGRectGetMaxY(rect) - 9;
    _emojiMagnifier.hidden = NO;
    
    _emojiMagnifierContent.image = cell.imageView.image;
    _emojiMagnifierContent.top = 20;
    
    [_emojiMagnifierContent.layer removeAllAnimations];
    NSTimeInterval dur = 0.1;
    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _emojiMagnifierContent.top = 3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _emojiMagnifierContent.top = 6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _emojiMagnifierContent.top = 5;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

- (void)showMagnifierForGifCell:(KMGifCollectionViewCell *)cell {
    
    NSString *basePath = [TNEUtil tne_imageCachPath];//基础路径
    NSString *imagePath = [[basePath stringByAppendingPathComponent:cell.emoticon.group.groupID] stringByAppendingPathComponent:cell.emoticon.gif];
    NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
    if (!gifData) {
        [self hideMagnifier];
        return;
    }
    
    //如果有gif数据,加载gif
    UIImage *gifImage = [UIImage sd_animatedGIFWithData:gifData];
    
    
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _gifMagnifier.centerX = CGRectGetMidX(rect);
    _gifMagnifier.bottom = CGRectGetMinY(rect) + 10;
    _gifMagnifier.hidden = NO;
    
    [_gifMagnifierContent setImage:gifImage];
    _gifMagnifierContent.top = 20;
    
    NSTimeInterval dur = 0.1;
    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _gifMagnifierContent.top = 7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _gifMagnifierContent.top = 10;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _gifMagnifierContent.top = 9;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}


- (void)hideMagnifier {
    _emojiMagnifier.hidden = YES;
    _gifMagnifier.hidden = YES;
}

- (void)startBackspaceTimer {
    [self endBackspaceTimer];
    @weakify(self);
    _backspaceTimer = [NSTimer timerWithTimeInterval:0.1 block:^(NSTimer *timer) {
        @strongify(self);
        if (!self) return;
        KMEmojiCollectionViewCell *cell = self->_currentEmojiMagnifierCell;
        if (cell.isDelete) {
            if ([self.delegate respondsToSelector:@selector(emojiCollectionViewDidTapEmojiCell:)]) {
                [[UIDevice currentDevice] playInputClick];
                [((id<KMEmojiCollectionViewDelegate>) self.delegate) emojiCollectionViewDidTapEmojiCell:cell];
            }
        }
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_backspaceTimer forMode:NSRunLoopCommonModes];
}

- (void)endBackspaceTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBackspaceTimer) object:nil];
    [_backspaceTimer invalidate];
    _backspaceTimer = nil;
}

@end
