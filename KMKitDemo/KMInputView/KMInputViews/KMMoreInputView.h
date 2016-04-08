//
//  KMMoreInputView.h
//  KMInputDemo
//
//  Created by kevinma on 15/12/23.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMMoreInputViewDelegate <NSObject>
@optional
- (void)moreInputDidTapText:(NSString *)text;
@end

@interface KMMoreInputView : UIView

@property (nonatomic, weak) id<KMMoreInputViewDelegate> delegate;
+ (instancetype)sharedView;

@end
