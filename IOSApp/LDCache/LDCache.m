//
//  LDCache.m
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import "LDCache.h"
#import "TMCache.h"

@implementation LDCache

static LDCache *_instance = nil;
+ (instancetype) cache {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;

    return _instance ;
}

+ (void)setCache:(id)obj key:(NSString *)key {
    [[TMCache sharedCache] setObject:obj forKey:key];
}

+ (id)getCacheWithKey:(NSString *)key {
    return [[TMCache sharedCache] objectForKey:key];
}

@end
