//
//  LDNetworking.h
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  请求响应成功block
 *
 *  @param response 响应json 对象
 *  @param result    ResResult
 */
typedef void (^ResponseCompleteBlock)(id response, ResResult *result, NSError *error);

/**
 *  下载进度block
 *
 *  @param progress progress description
 */
typedef void (^DownloadProgressBlock)(float progress);

@interface LDNetworking : NSObject

/**
 *  GET 数据请求
 *
 *  1、请求服务器先判断errcode 状态码，
 *  2、状态码正常则调用success block，输出json中的data信息
 *  3、状态码失败则输出缓存json，errcode、errmesg
 *
 *  @param url        url description
 *  @param parameters parameters description
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)reqGet:(NSString *)url
    parameters:(id)parameters
responseComplete:(ResponseCompleteBlock)responseComplete;

/**
 *   POST 数据请求
 *
 *  @param url              url description
 *  @param parameters       parameters description
 *  @param responseComplete responseComplete description
 *
 *  @return 缓存的数据
 */
+ (id)reqPost:(NSString *)url
     parameters:(id)parameters
responseComplete:(ResponseCompleteBlock)responseComplete;

/**
 *  下载文件
 *
 *  @param url      下载url
 *  @param path     存放路径
 *  @param complete complete description
 */
+ (void)downloadFileURL:(NSString *)url
             targetPath:(NSString *)path
       downloadProgress:(DownloadProgressBlock)progress
               complete:(ResponseCompleteBlock)complete;
@end
