//
//  KMSegmentedData.h
//  KMKitDemo
//
//  Created by kevinma on 16/3/2.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface KMSegmentedData : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *value;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSObject *attachedObject;

@end
