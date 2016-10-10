//
//  LDNetworking.m
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import "LDNetworking.h"
#import "AFNetworking.h"
#import "LDCache.h"

/**
 *  请求服务器接口设计逻辑
 请求返回上次缓存json数据，用于界面展示，然后调用异步网络请求
 */

@implementation LDNetworking

static LDNetworking* _instance = nil;

/**
 *  单例
 *
 *  @return return value description
 */
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

#pragma mark GET 数据请求
+ (void)reqGet:(NSString *)url
    parameters:(id)parameters
responseComplete:(ResponseCompleteBlock)responseComplete {
    LOG(@"GET url = %@ \ndata: %@",url, parameters);

    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResResult *result = [ResResult yy_modelWithJSON:responseObject];
        
        if (responseComplete) {
            responseComplete([responseObject objectForKey:@"data"], result, nil);
        }
        LOG(@"response success = %@", responseObject);

        if (result.errcode == RES_SERVER_SUCCESS) {
            [LDCache setCache:[responseObject objectForKey:@"data"] key:url];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /**
         *  服务器响应失败
         */
        LOG(@"error = %@", task.response.description);
        if (responseComplete) {
            responseComplete([LDCache getCacheWithKey:url], nil, error);
        }
    }];
}

#pragma mark POST 数据请求
+ (id)reqPost:(NSString *)url
     parameters:(id)parameters
responseComplete:(ResponseCompleteBlock)responseComplete {
    NSMutableString *cacheKey = [NSMutableString string];
    [cacheKey appendString:url];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cacheKey appendFormat:@"&%@=%@", obj, [parameters objectForKey:obj]];
    }];
    
    LOG(@"POST url = %@ \ndata: %@",url, parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResResult *result = [ResResult yy_modelWithJSON:responseObject];

        if (responseComplete) {
            responseComplete([responseObject objectForKey:@"data"], result, nil);
        }
        LOG(@"errcode = %ld, msg = %@", (long)result.errcode, result.errmsg);
        LOG(@"response success = %@", responseObject);

        if (result.errcode == RES_SERVER_SUCCESS) {
            [LDCache setCache:[responseObject objectForKey:@"data"] key:cacheKey];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /**
         *  服务器响应失败
         */
        LOG(@"error = %@", task.response.description);
        if (responseComplete) {
            responseComplete([LDCache getCacheWithKey:cacheKey], nil, error);
        }
    }];
    
    return [LDCache getCacheWithKey:cacheKey];
}

#pragma mark 下载文件
+ (void)downloadFileURL:(NSString *)url
             targetPath:(NSString *)path
       downloadProgress:(DownloadProgressBlock)progress
               complete:(ResponseCompleteBlock)complete {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [[NSURL fileURLWithPath:path] URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        LOG(@"File downloaded to: %@", filePath);
        complete(filePath, nil, error);
    }];
    [downloadTask resume];
}

@end
