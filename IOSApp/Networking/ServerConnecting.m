//
//  ServerConnecting.m
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import "ServerConnecting.h"
#import <YYModel.h>
#import "LDCache.h"
#import <AFURLSessionManager.h>

/**
 *
 *  以下为示例代码，实际工程中根据需要自己定义
 *
 */
//获取 首页所有数据
#define GetMainPage @"api/member/firstpageall"



@implementation ServerConnecting
/**
 *
 *  以下为示例代码，实际工程中根据需要自己定义
 *
 */
#pragma mark 获取首页
+ (id)requestGetMainPageComplete:(ResponseCompleteBlock)complete {
    NSDictionary *param = @{@"member_id":MemberID};
    
    return [LDNetworking reqPost:ServerUrl(GetMainPage) parameters:param  responseComplete:complete];
}



@end
