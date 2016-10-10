//
//  NetworkStatusCode.h
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#ifndef NetworkStatusCode_h
#define NetworkStatusCode_h

#pragma mark 服务器定义返回状态码（以下状态码为服务端约定）

/**
 *
 *  以下为示例代码，实际工程中根据需要自己定义
 *
 */
#define RES_SERVER_SUCCESS  100000   //正常
#define RES_SERVER_ILLEGAL  100001   //非法请求


#pragma mark 客户端（本地）定义返回码
/**
 *
 *  以下为示例代码，实际工程中根据需要自己定义
 *
 */
#define REQ_SERVER_FAILURE_ERROR -10000 //请求服务器 失败 失败则读取AFNetworking返回码

#endif /* NetworkStatusCode_h */
