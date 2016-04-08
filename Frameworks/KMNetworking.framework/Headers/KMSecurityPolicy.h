//
//  KMSecurityPolicy.h
//  KMNetworking
//
//  Created by kevinma on 16/3/8.
//  Copyright © 2016年 com.kevinma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMAPIDefines.h"

@interface KMSecurityPolicy : NSObject

/**
 *  SSL Pinning证书的校验模式
 *  默认为 KMSSLPinningModeNone
 */
@property (readonly, nonatomic, assign) KMSSLPinningMode SSLPinningMode;

/**
 *  是否允许使用Invalid 证书
 *  默认为 NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 *  是否校验在证书 CN 字段中的 domain name
 *  默认为 YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 *  创建新的SecurityPolicy
 *
 *  @param pinningMode 证书校验模式
 *
 *  @return 新的SecurityPolicy
 */
+ (instancetype)policyWithPinningMode:(KMSSLPinningMode)pinningMode;

@end
