//
//  ServerConnecting.h
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDNetworking.h"

@interface ServerConnecting : NSObject

/**
 *
 *  以下为示例代码，实际工程中根据需要自己定义
 *
 */

/**
 *  获取首页信息
 *
 *  @param complete complete description
 *
 *  @return 缓存信息
 */
+ (id)requestGetMainPageComplete:(ResponseCompleteBlock)complete;


@end
