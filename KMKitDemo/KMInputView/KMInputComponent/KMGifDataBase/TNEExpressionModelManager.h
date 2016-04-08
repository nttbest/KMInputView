//
//  TNEExpressionModelManager.h
//  Toon
//
//  Created by jinjinzhou on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

typedef void (^TNEExpressionDetailCallBack)(BOOL succeed, NSString* isDownload, id data);//获取表情详情专用
typedef void (^TNEExpressionCallBack)(BOOL succeed, NSString* message, id data);

typedef void (^DownloadProgressBlock)(CGFloat process);

@interface TNEExpressionModelManager : NSObject

+ (TNEExpressionModelManager *)sharedInstance;
/**
 *  查询表情商城列表
 */
- (void)getExpressionsListFromparams:(NSDictionary *)params
                             success:(TNEExpressionCallBack)successBlock
                               faild:(TNEExpressionCallBack)failBlock;


/**下载表情包
 
 */
- (void)getDownLoadFaceBagListFromparams:(NSDictionary *)params
                                progress:(DownloadProgressBlock)downloadBlock
                                 success:(TNEExpressionCallBack)successBlock
                                   faild:(TNEExpressionCallBack)failBlock;

/**移除我的表情包
 
 */
- (void)removeMyFaceBagFromparams:(NSDictionary *)params
                          success:(TNEExpressionCallBack)successBlock
                            faild:(TNEExpressionCallBack)failBlock;

/**更新我的表情包顺序
 
 */
- (void)sortMyFaceBagFromparams:(NSDictionary *)params
                        success:(TNEExpressionCallBack)successBlock
                          faild:(TNEExpressionCallBack)failBlock;

/**获得我的表情包列表
 
 */
- (void)getMyFaceBagListFromparams:(NSDictionary *)params
                           success:(TNEExpressionCallBack)successBlock
                             faild:(TNEExpressionCallBack)failBlock;

/**获得表情包详情列表
 
 */
- (void)getFaceBagDetailFromparams:(NSDictionary *)params
                           success:(TNEExpressionDetailCallBack)successBlock
                             faild:(TNEExpressionCallBack)failBlock;

/**
 *  将表情包缩略图缓冲到本地
 *
 */
- (void)cacheFaceBagImageWithUrl:(NSString *)imageURL;

@end
