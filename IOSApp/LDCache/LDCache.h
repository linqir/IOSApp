//
//  LDCache.h
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类为App缓存管理类，对于第三方的缓存进行封装
 */
@interface LDCache : NSObject

/**
 *  设置缓存
 *
 *  @param obj 缓存 obj
 *  @param key 缓存 key
 */
+ (void)setCache:(id)obj key:(NSString *)key;

/**
 *  获取缓存信息
 *
 *  @param key 缓存 key
 *
 *  @return 缓存 obj
 */
+ (id)getCacheWithKey:(NSString *)key;

@end
