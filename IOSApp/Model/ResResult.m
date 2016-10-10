//
//  ReqResult.m
//  App
//
//  Created by 林 on 16/8/6.
//  Copyright © 2016年 林. All rights reserved.
//

#import "ResResult.h"

@implementation ResResult

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"errcode" : @"result.errcode",
             @"errmsg" : @"result.errmsg"};
}

@end
