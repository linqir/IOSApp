//
//  Util.m
//  App
//
//  Created by 林 on 16/8/8.
//  Copyright © 2016年 林. All rights reserved.
//

#import "Util.h"
#import <BBRSACryptor.h>
#import <GTMBase64.h>
#import <ZKUDIDManager.h>
#import "LDCache.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Util
#pragma mark 获取视图中图片的size
+ (CGSize)getTextSize:(NSString *)text fontSize:(CGFloat)fontSize view:(UIView *)view {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    return [text boundingRectWithSize:CGSizeMake(view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}

+ (CGSize)getTextSize:(NSString *)text fontSize:(CGFloat)fontSize maxWidth:(float)maxWidth {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    return [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}

#pragma mark RSA 数据加密
+ (NSString *)RSAEncodeString:(NSString *)string {
    return [Util RSAEncodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark RSA 数据加密
+ (NSString *)RSAEncodeData:(NSData *)data {
    BBRSACryptor *rsaCryptor = [[BBRSACryptor alloc] init];
    [rsaCryptor importRSAPublicKeyPEMData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"pem"]]];
    NSData *encodingData = [rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PADDING_TYPE_PKCS1 plainData:data];
   
    return [GTMBase64 stringByEncodingData:encodingData];
}

#pragma mark 获取设备 UDID
+ (NSString *)deviceUDID {
    if (![LDCache getCacheWithKey:kDeviceUDID]) {
        [LDCache setCache:[ZKUDIDManager value] key:kDeviceUDID];
    }
    
    return [LDCache getCacheWithKey:kDeviceUDID];
}

#pragma mark 校验URL地址，服务端返回的地址有时候会是./开头，需要客户端将.替换为服务器地址http://...
+ (NSString *)getRightUrl:(NSString *)url {
    if (!url.length)
        return url;
    
    NSRange range = [url rangeOfString:@"http://"];
    if (range.location != NSNotFound) {
        return url;
    }
    else {
        if([[url substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"./"]) {
            return [NSString stringWithFormat:@"%@%@", SERVER_URL, [url substringFromIndex:1]];
        }
        
        if([[url substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
            return [NSString stringWithFormat:@"%@%@", SERVER_URL, [url substringFromIndex:0]];
        }
    }
    
    return url;
}

#pragma mark 对url进行decode 解码
+ (NSString *)URLDecodedString:(NSString *)urlString {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)urlString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark 对url进行encode 编码
+ (NSString *)URLEncodeString:(NSString *)urlString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                                                                                                    NULL,  (CFStringRef)urlString, NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8));
}

#pragma mark 获取每一行的字符串
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    if (!text) {
        return nil;
    }
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}

#pragma mark View 转 UIImage
+ (UIImage*)imageWithUIView:(UIView*) view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return tImage;
}

#pragma mark layer 动画 暂停 & 开始
+ (void)pauseAnimateLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

#pragma mark 继续layer上面的动画
+ (void)resumeAnimateLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark 图层旋转动画
+ (CABasicAnimation *)rotationAnimation {
    //旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animation];
    rotationAnimation.keyPath = @"transform.rotation";//转圈
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];    //动画速度设置
    return rotationAnimation;
}

#pragma mark 图层缩放动画
+ (CABasicAnimation *)scaleAnimation:(float)fromValue {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    //设置抖动幅度
    animation.fromValue=[NSNumber numberWithFloat:fromValue];
    animation.toValue=[NSNumber numberWithFloat:1];
    animation.duration=0.3;
    animation.autoreverses=NO;
    animation.repeatCount=1;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

#pragma mark 检测手机号码正则表达式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

#pragma mark 格式化手机号码
+ (NSString *)fotmatPhone:(NSString *)phone {
    if (phone == nil) {
        return @"";
    }
    
    NSMutableString *fotmatPhone = [NSMutableString string];
    if (phone.length <= 3) {
        return phone;
    }
    
    [fotmatPhone appendString:[phone substringToIndex:3]];
    [fotmatPhone appendString:@"-"];
    
    NSInteger lastLenght = 3;
    
    while (phone.length >= lastLenght + 4) {
        [fotmatPhone appendString:[phone substringWithRange:NSMakeRange(lastLenght, 4)]];
        [fotmatPhone appendString:@"-"];
        lastLenght += 4;
    }
    
    if (phone.length > lastLenght) {
        [fotmatPhone appendString:[phone substringFromIndex:lastLenght]];
    }
    else {
        fotmatPhone = (NSMutableString *)[fotmatPhone substringToIndex:fotmatPhone.length - 1];
    }

    return fotmatPhone;
}

#pragma mark md5
+ (NSString *)MD5String:(NSString *)string {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
