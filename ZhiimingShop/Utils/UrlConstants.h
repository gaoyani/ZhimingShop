//
//  URLConstants.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const login_url;
extern NSString* const calculate_url;

@interface UrlConstants : NSObject

+(NSString *)getUrl:(NSString*)url;

@end
