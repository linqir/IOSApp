//
//  Util.h
//  App
//
//  Created by 林 on 16/8/8.
//  Copyright © 2016年 林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

/**
 *  获取视图中图片的size
 *
 *  @param text    文字
 *  @param fontSize 文字大小
 *  @param view     文字试图view
 *
 *  @return return value description
 */
+ (CGSize)getTextSize:(NSString *)text fontSize:(CGFloat)fontSize view:(UIView *)view;

/**
 *  <#Description#>
 *
 *  @param text     <#text description#>
 *  @param fontSize <#fontSize description#>
 *  @param maxWidth <#maxWidth description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)getTextSize:(NSString *)text fontSize:(CGFloat)fontSize maxWidth:(float)maxWidth;

/**
 *  RSA 数据加密
 *
 *  @param string string description
 *
 *  @return return value description
 */
+ (NSString *)RSAEncodeString:(NSString *)string;

/**
 *  RSA 数据加密
 *
 *  @param data data
 *
 *  @return return value description
 */
+ (NSString *)RSAEncodeData:(NSData *)data;

/**
 *  获取设备udid
 *
 *  @return return value description
 */
+ (NSString *)deviceUDID;

/**
 *  校验URL地址，服务端返回的地址有时候会是./开头，需要客户端将.替换为服务器地址http://。。。
 *
 *  @param url url description
 *
 *  @return return value description
 */
+ (NSString *)getRightUrl:(NSString *)url;

/**
 *  对url进行decode 解码
 *
 *  @param str str description
 *
 *  @return <#return value description#>
 */
+ (NSString *)URLDecodedString:(NSString *)urlString;

/**
 *  对url进行encode 编码
 *
 *  @param urlString urlString description
 *
 *  @return <#return value description#>
 */
+ (NSString *)URLEncodeString:(NSString *)urlString;

/**
 *  获取每一行的字符串
 *
 *  @param label label description
 *
 *  @return return value description
 */
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

/**
 *   VIEW 转 uiimage
 *
 *  @param view view description
 *
 *  @return uiimage 对象
 */
+ (UIImage*) imageWithUIView:(UIView*) view;

#pragma mark layer 动画 暂停 & 重启
/**
 *  暂停layer上的动画
 *
 *  @param layer <#layer description#>
 */
+ (void)pauseAnimateLayer:(CALayer*)layer;

/**
 *  继续layer上面的动画
 *
 *  @param layer layer description
 */
+ (void)resumeAnimateLayer:(CALayer*)layer;

/**
 *  图层旋转动画
 *
 *  @return return value description
 */
+ (CABasicAnimation *)rotationAnimation;

/**
 *  图层缩放动画
 *
 *  @param fromValue fromValue description
 *
 *  @return return value description
 */
+ (CABasicAnimation *)scaleAnimation:(float)fromValue;

/**
 *  检测手机号码正则表达式
 *
 *  @param mobileNum 手机号码
 *
 *  @return return value description
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  格式化手机号码 如 138-8888-8888 
 *  显示格式 3-4-4-4-4-...  （支持多位）
 *
 *  @param phone 手机号码
 *
 *  @return return value description
 */
+ (NSString *)fotmatPhone:(NSString *)phone;

/**
 *  字符串md5加密
 *
 *  @param string 字符串
 *
 *  @return return value description
 */
+ (NSString *)MD5String:(NSString *)string;

@end
