//
//  KMGeneralAPI.h
//  KMNetworking
//
//  Created by kevinma on 16/3/8.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import "KMBaseAPI.h"
#import "KMAPIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMGeneralAPI : KMBaseAPI

/**
 *  KMAPI Protocol中的 requestMethod字段
 */
@property (nonatomic,   copy) NSString         *requestMethod;
/**
 *  安全协议设置
 */
@property (nonatomic, strong) KMSecurityPolicy *apiSecurityPolicy;

/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) KMRequestMethodType      apiRequestMethodType;

/**
 *  同BaseAPI apiRequestSerializerType
 */
@property (nonatomic, assign) KMRequestSerializerType  apiRequestSerializerType;

/**
 *  同BaseAPI apiResponseSerializerType
 */
@property (nonatomic, assign) KMResponseSerializerType apiResponseSerializerType;

/**
 *  同BaseAPI apiRequestCachePolicy
 */
@property (nonatomic, assign) NSURLRequestCachePolicy   apiRequestCachePolicy;

/**
 *  同BaseAPI apiRequestTimeoutInterval
 */
@property (nonatomic, assign) NSTimeInterval            apiRequestTimeoutInterval;

/**
 *  KMAPI Protocol中的 RequestParameters字段
 */
@property (nonatomic, strong, nullable) id           requestParameters;

/**
 *  同BaseAPI apiRequestHTTPHeaderField
 */
@property (nonatomic, strong, nullable) NSDictionary *apiRequestHTTPHeaderField;

/**
 *  同BaseAPI apiResponseAcceptableContentTypes
 */
@property (nonatomic, strong, nullable) NSSet        *apiResponseAcceptableContentTypes;

/**
 *  同BaseAPI apiAddtionalRPCParams
 */
@property (nonatomic, strong, nullable) NSDictionary *apiAddtionalRPCParams;

/**
 *  同BaseAPI customRequestUrl
 */
@property (nonatomic, copy,   nullable) NSString     *customRequestUrl;

/**
 *  同BaseAPI rpcDelegate
 */
@property (nonatomic, weak,   nullable) id<KMRPCProtocol> rpcDelegate;

/**
 *  同BaseAPI apiHttpHeaderDelegate
 */
@property (nonatomic, weak,   nullable) id<KMHttpHeaderDelegate> apiHttpHeaderDelegate;

/**
 *  同BaseAPI apiAddtionalRequestFunction
 */
@property (nonatomic, copy,   nullable) NSString     *apiAddtionalRequestFunction;

/**
 *  同BaseAPI apiRequestWillBeSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestWillBeSentBlock)();

/**
 *  同BaseAPI apiRequestDidSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestDidSentBlock)();

/**
 *  一般用来进行JSON -> Model 数据的转换工作
 *   返回的id，如果没有error，则为转换成功后的Model数据；
 *    如果有error， 则直接返回传参中的responseObject
 *
 *  注意：
 *   这里与KMAPI Protocol中的apiResponseObjReformer 有重合。
 *   这里的block 主要给 KMGeneralAPI 使用
 *
 *  @param responseObject 请求的返回
 *  @param error          请求的错误
 *
 *  @return 整理过后的请求数据
 */
@property (nonatomic, copy, nullable) id _Nullable (^apiResponseObjReformerBlock)(id responseObject, NSError * _Nullable error);

- (nullable instancetype)init;
- (nullable instancetype)initWithRequestMethod:(NSString *)requestMethod;

@end


NS_ASSUME_NONNULL_END



