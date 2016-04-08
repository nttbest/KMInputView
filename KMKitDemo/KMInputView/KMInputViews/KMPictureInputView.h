//
//  KMPictureInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/23.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMPictureInputViewDelegate <NSObject>
@optional
- (void)pictureInputDidTapCamera;
- (void)pictureInputDidTapAlbum;

@end

@interface KMPictureInputView : UIView

@property (nonatomic, weak) id<KMPictureInputViewDelegate> delegate;
+ (instancetype)sharedView;

@end
