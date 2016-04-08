//
//  TNEExpressionModelManager.m
//  Toon
//
//  Created by jinjinzhou on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "TNEExpressionModelManager.h"
//#import <ServiceLibrary/ServiceLibrary.h>
#import "TNEDBFaceBagModel.h"
#import "TNEDBEmojiModel.h"
#import "TNEUtil.h"

static const NSString *kNetworkErrorString = @"网络异常，请稍后重试";
static TNEExpressionModelManager *expressionModelManager = nil;

@interface TNEExpressionModelManager ()

@end

@implementation TNEExpressionModelManager
+ (TNEExpressionModelManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expressionModelManager = [[self alloc] init];
    });
    return expressionModelManager;
}

/**
 *  查询表情商城列表 
 */
- (void)getExpressionsListFromparams:(NSDictionary *)params success:(TNEExpressionCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
//    TNPFaceBagGetFaceBagListInputForm *inform = [[TNPFaceBagGetFaceBagListInputForm alloc] init];
//    inform.fetchBegin = params[@"fetchBegin"];
//    inform.fetchNum = params[@"fetchNum"];
//    
//    [[ServiceRequest sharedInstance] getFaceBagListWithTNP:inform succeed:^(NSArray *resultArray) {
//        NSMutableArray *dataArray = [NSMutableArray array];
//        
//        for (NSDictionary *resultDic in resultArray) {
//            TNEDBFaceBagModel *model = [TNEDBFaceBagModel new];
//            [model setValuesForKeysWithDictionary:resultDic];
//            [dataArray addObject:model];
//        }
//        successBlock(YES,nil,dataArray);
//        
//    } failure:^(NSError *error) {
//        if (failBlock) {
//            failBlock(NO,kNetworkErrorString,nil);
//        }
//    }];
}
/**下载表情包
 
 */
- (void)getDownLoadFaceBagListFromparams:(NSDictionary *)params progress:(DownloadProgressBlock)downloadProgressBlock success:(TNEExpressionCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
    
//    TNPFaceBagDownLoadFaceBagInputForm *inform = [[TNPFaceBagDownLoadFaceBagInputForm alloc] init];
//    inform.faceBagId = [NSString stringWithFormat:@"%@",params[@"faceBagId"]];
//    inform.userId = [NSString stringWithFormat:@"%@",params[@"userId"]];
//    inform.isDownloadZip = [NSString stringWithFormat:@"%@",params[@"isDownloadZip"]];
//    
//    [[ServiceRequest sharedInstance] downLoadFaceBagWithTNP:inform progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        // 下载进度
//        CGFloat progress = ((CGFloat)totalBytesRead) / (totalBytesExpectedToRead);
//        
//        downloadProgressBlock(progress);
//        
//    } succeed:^(NSDictionary *resultDic) {
//        
//        //下载成功，返回压缩包的存储路径 datapath
//        
//        NSString *dataPath = [[ServiceRequest sharedInstance] faceBagFilePath];
//        successBlock(YES,dataPath,resultDic);
//        
//    } failure:^(NSError *error) {
//        if (failBlock) {
//            failBlock(NO,kNetworkErrorString,nil);
//        }
//    }];
}
/**移除我的表情包
 
 */
- (void)removeMyFaceBagFromparams:(NSDictionary *)params success:(TNEExpressionCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
//    TNPFaceBagRemoveMyFaceBagInputForm *inform = [[TNPFaceBagRemoveMyFaceBagInputForm alloc] init];
//    inform.faceBagId = [NSString stringWithFormat:@"%@",params[@"faceBagId"]];
//    inform.userId = [NSString stringWithFormat:@"%@",params[@"userId"]];
//    [[ServiceRequest sharedInstance] removeMyFaceBagWithTNP:inform succeed:^(NSDictionary *resultDic) {
//        NSLog(@"---remove my face bag----%@",resultDic);
//        successBlock(YES,nil,resultDic);
//    } failure:^(NSError *error) {
//        if (failBlock) {
//            failBlock(NO,[error debugDescription],nil);
//        }
//    }];

}
/**更新我的表情包顺序
 
 */
- (void)sortMyFaceBagFromparams:(NSDictionary *)params success:(TNEExpressionCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
//    TNPFaceBagSortMyFaceBagInputForm *inform = [[TNPFaceBagSortMyFaceBagInputForm alloc] init];
//    inform.myFaceBagsList = params[@"myFaceBagsList"];
//    inform.userId = params[@"userId"];
//    [[ServiceRequest sharedInstance] sortMyFaceBagWithTNP:inform succeed:^(NSArray *resultArray) {
//        
//        successBlock(YES,nil,resultArray);
//        
//    } failure:^(NSError *error) {
//        if (failBlock) {
//            failBlock(NO,[error debugDescription],nil);
//        }
//    }];
}
/**获得我的表情包列表
 
 */
- (void)getMyFaceBagListFromparams:(NSDictionary *)params success:(TNEExpressionCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
//    TNPFaceBagGetMyFaceBagListInputForm *inform = [[TNPFaceBagGetMyFaceBagListInputForm alloc] init];
//    inform.userId = [NSString stringWithFormat:@"%@",params[@"userId"]];
//    [[ServiceRequest sharedInstance] getMyFaceBagListWithTNP:inform succeed:^(NSArray *resultArray) {
//        NSMutableArray *totalArray = [NSMutableArray array];        
//        
//        for (NSDictionary *resultDic in resultArray) {
//            /**
//             *  将显示未下载（移除过）的数据过滤掉
//             */
//            if ([[resultDic objectForKey:@"isDownload"] isEqualToString:@"1"]) {
//                TNEDBFaceBagModel *model = [TNEDBFaceBagModel new];
//                [model setValuesForKeysWithDictionary:resultDic];
//                [totalArray addObject:model];
//            }
//        }
//        successBlock(YES,nil,totalArray);
//    } failure:^(NSError *error) {
//        failBlock(YES,[error description],nil);
//    }];
}
/**获得表情包详情列表
 
 */
- (void)getFaceBagDetailFromparams:(NSDictionary *)params success:(TNEExpressionDetailCallBack)successBlock faild:(TNEExpressionCallBack)failBlock
{
//    TNPFaceBagGetFaceBagDetailInputForm *inform = [[TNPFaceBagGetFaceBagDetailInputForm alloc] init];
//    inform.faceBagId = params[@"faceBagId"];
//    inform.userId    = params[@"userId"];
//
//    [[ServiceRequest sharedInstance] getFaceBagDetailWithTNP:inform succeed:^(NSDictionary *resultDic) {
//        
//        NSMutableArray *totalArray = [NSMutableArray new];
//        NSArray *tempArr = [resultDic objectForKey:@"faceResultList"];
//        
//        for (NSDictionary *dict in tempArr) {
//            TNEDBEmojiModel *model = [TNEDBEmojiModel new];
//            [model setValuesForKeysWithDictionary:dict];
//            [totalArray addObject:model];
//        }
//        NSString *isDownload = [resultDic objectForKey:@"isDownload"];//是否下载
//        NSLog(@"_________服务端下载状态%@",isDownload);
//        successBlock(YES,isDownload,totalArray);
//        
//    } failure:^(NSError *error) {
//        failBlock(YES,kNetworkErrorString,nil);
//    }];

}

#pragma mark - 
- (void)cacheFaceBagImageWithUrl:(NSString *)imageURL
{
//    NSString *imagePath = [TNEUtil tne_faceBagImagePathWithUrl:imageURL];
//    if (imagePath == nil) {
//        return;
//    }
//    NSString *decodeString = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [ServiceRequest downloadDataWithURL:[NSURL URLWithString:decodeString] succeed:^(NSURL* url, NSData *imageData) {
//        
//        if (imageData != nil) {
//            
//            BOOL cacheStatus = [imageData writeToFile:imagePath atomically:YES];
//            NSLog(@"cache status = %d",cacheStatus);
//        }
//        
//    } failure:^(NSURL* url, NSString *error) {
//        NSLog(@"Download image failed:%@ %@", url, error);
//    }];
    

}


@end
