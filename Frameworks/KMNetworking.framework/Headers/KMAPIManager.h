//
//  KMAPIManager.h
//  KMNetworking
//
//  Created by kevinma on 16/3/8.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMBaseAPI;
@class KMConfig;
@class KMAPIBatchAPIRequests;
@protocol KMAPI;

@interface KMAPIManager : NSObject

@property (nonatomic, strong, nonnull) KMConfig *configuration;

// 单例
+ (nullable KMAPIManager *)sharedKMAPIManager;

/**
 *  发送API请求
 *
 *  @param api 要发送的api
 */
- (void)sendAPIRequest:(nonnull KMBaseAPI  *)api;

/**
 *  取消API请求
 *
 *  @description
 *      如果该请求已经发送或者正在发送，则无法取消
 *
 *  @param api 要取消的api
 */
- (void)cancelAPIRequest:(nonnull KMBaseAPI  *)api;

/**
 *  发送一系列API请求
 *
 *  @param apis 待发送的API请求集合
 */
- (void)sendBatchAPIRequests:(nonnull KMAPIBatchAPIRequests *)apis;

@end
