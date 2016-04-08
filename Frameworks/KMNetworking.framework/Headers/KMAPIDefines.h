//
//  KMAPIDefines.h
//  KMNetworking
//
//  Created by kevinma on 16/3/8.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#ifndef KMAPIDefines_h
#define KMAPIDefines_h

// 网络请求类型
typedef NS_ENUM(NSUInteger, KMRequestMethodType) {
    KMRequestMethodTypeGET     = 0,
    KMRequestMethodTypePOST    = 1,
    KMRequestMethodTypeHEAD    = 2,
    KMRequestMethodTypePUT     = 3,
    KMRequestMethodTypePATCH   = 4,
    KMRequestMethodTypeDELETE  = 5
};

// 请求的序列化格式
typedef NS_ENUM(NSUInteger, KMRequestSerializerType) {
    KMRequestSerializerTypeHTTP    = 0,
    KMRequestSerializerTypeJSON    = 1
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, KMResponseSerializerType) {
    KMResponseSerializerTypeHTTP    = 0,
    KMResponseSerializerTypeJSON    = 1
};

/**
 *  SSL Pinning
 */
typedef NS_ENUM(NSUInteger, KMSSLPinningMode) {
    /**
     *  不校验Pinning证书
     */
    KMSSLPinningModeNone,
    /**
     *  校验Pinning证书中的PublicKey.
     *  知识点可以参考
     *  https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
     */
    KMSSLPinningModePublicKey,
    /**
     *  校验整个Pinning证书
     */
    KMSSLPinningModeCertificate,
};

// KM 默认的请求超时时间
#define KM_API_REQUEST_TIME_OUT     15
#define MAX_HTTP_CONNECTION_PER_HOST 5

#endif /* KMAPIDefines_h */
