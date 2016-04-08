//
//  KMAPIBatchAPIRequests.h
//  KMNetworking
//
//  Created by kevinma on 16/3/8.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMBaseAPI;
@class KMAPIBatchAPIRequests;

@protocol KMAPIBatchAPIRequestsProtocol <NSObject>

/**
 *  Batch Requests 全部调用完成之后调用
 *
 *  @param batchApis batchApis
 */
- (void)batchAPIRequestsDidFinished:(nonnull KMAPIBatchAPIRequests *)batchApis;

@end

@interface KMAPIBatchAPIRequests : NSObject

/**
 *  Batch 执行的API Requests 集合
 */
@property (nonatomic, strong, readonly, nullable) NSMutableSet *apiRequestsSet;

/**
 *  Batch Requests 执行完成之后调用的delegate
 */
@property (nonatomic, weak, nullable) id<KMAPIBatchAPIRequestsProtocol> delegate;

/**
 *  将API 加入到BatchRequest Set 集合中
 *
 *  @param api
 */
- (void)addAPIRequest:(nonnull KMBaseAPI *)api;

/**
 *  将带有API集合的Sets 赋值
 *
 *  @param apis
 */
- (void)addBatchAPIRequests:(nonnull NSSet *)apis;

/**
 *  开启API 请求
 */
- (void)start;

@end
