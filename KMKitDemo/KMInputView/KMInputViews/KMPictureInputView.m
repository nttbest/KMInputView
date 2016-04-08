//
//  KMPictureInputView.m
//  KMInputDemo
//
//  Created by kevinma on 15/12/23.
//  Copyright © 2015年 kevinma. All rights reserved.
//

#import "KMPictureInputView.h"
#import "YYKit.h"

#define kViewHeight 216

@implementation KMPictureInputView

+ (instancetype)sharedView {
    static KMPictureInputView *v;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [self new];
    });
    return v;
}

- (instancetype)init {
    self = [super init];
    self.frame = CGRectMake(0, 0, kScreenWidth, kViewHeight);
    self.backgroundColor = UIColorHex(FFFFFF);
    
    UIButton *button = [[UIButton alloc] init];
    button.width = self.width - 50;
    button.height = self.height - 30;
    button.center = self.center;
    [button setTitleColor:UIColorHex(939393) forState:UIControlStateNormal];
    [button setTitle:@"Picture" forState:UIControlStateNormal];
    [self addSubview:button];
    
    return self;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
