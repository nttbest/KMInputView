//
//  KMVideoInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/23.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMVideoInputViewDelegate <NSObject>
@optional
- (void)videoInputDidTapText:(NSString *)text;
@end

@interface KMVideoInputView : UIView

@property (nonatomic, weak) id<KMVideoInputViewDelegate> delegate;
+ (instancetype)sharedView;

@end
