//
//  URLConstants.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "UrlConstants.h"
#import "Constants.h"

//NSString* const root_url = @"http://125.35.14.247:8000/zmkd/api/";
NSString* const root_url = @"http://192.168.22.163/app/zmkd/api/";
NSString* const login_url = @"index.php";
NSString* const calculate_url = @"operation.php";

@implementation UrlConstants

+(NSString *)getUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@%@",root_url,url];
}



@end
