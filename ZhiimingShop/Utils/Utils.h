//
//  Utils.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/3.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utils : NSObject

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+(NSString *)md5:(NSString *)str;
+(NSString*)getRandomString:(int)length;
+(NSString *)getDeviceUUID;

+(void)showMessage:(NSString *)message;
+(float)getDeviceVersion;

+(NSString*)getFilePath:(NSString*)fileName;
@end
