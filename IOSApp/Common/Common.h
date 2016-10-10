//
//  Common.h
//  App
//
//  Created by 林 on 16/7/27.
//  Copyright © 2016年 林. All rights reserved.
//

#ifndef Common_h
#define Common_h

#endif /* Common_h */

//#ifdef DEBUG
//#define LOG(...) NSLog(__VA_ARGS__);
//#define LOG_METHOD NSLog(@"%s", __func__);
//#else
//#define LOG(...); #define LOG_METHOD;
//#endif

#ifdef DEBUG
#define LOG(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define LOG(FORMAT, ...) nil
#endif

typedef void(^Block)();

#pragma mark 网易云信
//#define NetEasyAppkey @"a5d9e5174277f0ea96eb826f7ba55671"   //twocats appkey
#define NetEasyAppkey @"45c6af3c98409b18a84451215d0bdd6e"   //twocats appkey

#pragma mark 网易云信 推送配置证书
#define NIMCer @"ENTERPRISE"

//#if DEBUG
//#define NIMCer @"twocatsTest"
//#else
//#define NIMCer @"twocats";
//#endif

#pragma mark 网易云信测试账号 
#pragma mark（官方demo app key 注册的账号）
#define NIMTestCaller   @"tt123456"
#define NIMTestCallee   @"pp123456"

#pragma mark RSA公钥
#define kRSAPublicKey \
        @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCg4CLBjN+9KhAFyyFHEqffJu3pW/+   \
        F2pPEf6zRTryFxVWY5CC6PIy/piO6p+7NoDPXJUO1LzLIMyAKZZDgd/Yd6OyprtRK7VwsXj \
        GEgr9S0lUjvJKwcoHC/T1lZO9zJweU1qJJg9MT5Nn/7YfLxf5vypRC32EfZnS2D8NQabJjYwIDAQAB"

#pragma mark Color Common  颜色值
#define kBackgroudColor RGBColor(238, 238, 240)
#define kNavBgColor     RGBColor(41, 40, 45)
#define kDefaultGrayColor RGBColor(233, 233, 233)
#define kPinkColor RGBColor(244.0, 45.0, 161.0)//粉红

#pragma mark 公用的一些方法 宏定义 方便使用
#define RGBColor(__RED, __GREEN, __BLUE) [UIColor colorWithRed:__RED / 255.0 green:__GREEN / 255.0 blue:__BLUE / 255.0 alpha:1]
#define IMG(__NAME)         [UIImage imageNamed:__NAME]
#define URL(__URL)          [NSURL URLWithString:__URL]

//生成服务器接口地址
#define ServerUrl(__URL)    [NSString stringWithFormat:@"%@/%@", SERVER_URL, __URL]
#define Int2Str(__INT)      [NSString stringWithFormat:@"%d", __INT]

#define WeakSelf __weak typeof(self) weakSelf = self

#pragma mark cache key 定义
#define kDeviceUDID @"devicceUDID"
#define kMemberID   @"memberID"
#define kToken      @"token"

#pragma mark 定义一些函数调用宏，方便使用
#define MemberID [LDCache getCacheWithKey:kMemberID]
#define UDID    [Util deviceUDID]
#define RSAEncode(__STR) [Util RSAEncodeString:__STR]

#pragma mark  目录 存储文件相关定义
#define Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DirectoryContentJS [NSString stringWithFormat:@"%@/ContentJS", Document]
#define DirectoryTempContentJS [NSString stringWithFormat:@"%@/TempContentJS", Document]
#define kJqueryJs   @"jquery.min.js"
#define kBootstrapCss @"bootstrap.min.css"
#define kBootstrapJs @"bootstrap.min.js"
#define kAppstyleHtm @"appstyle.htm"


#pragma mark 消息通知 key (KVO)
//contentList cell中弹出视图消失(当界面滑动的时候...)
#define kNotiDismissCellShow    @"kNotiDismissCellShow"

