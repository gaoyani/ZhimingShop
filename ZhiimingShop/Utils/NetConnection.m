//
//  NetConnection.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "NetConnection.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utils.h"


@implementation NetConnection {
    NSString* resposeFuncName;
}

-(NetConnection*)init {
    self = [super init];
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 5;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    return self;
}

-(NSMutableDictionary*)getParamsDictionary:(NSMutableDictionary*)dataDic methodName:(NSString*)methodName {
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:@"1.0" forKey:@"ver"];
    NSString* serial = [Utils getRandomString:32];
    [paramsDic setValue:serial forKey:@"serial"];
    [paramsDic setValue:dataDic forKey:@"params"];
    [paramsDic setValue:methodName forKey:@"method"];
    NSString* auth = [NSString stringWithFormat:@"%@%@",serial,[Utils md5:methodName]];
    [paramsDic setValue:[Utils md5:auth] forKey:@"auth"];
    
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return paramsDic;
}


-(void)startConnect:(NSString*)connectUrl dataDictionary:(NSMutableDictionary*)dataDic methodName:(NSString*)methodName resposeFuncName:(NSString*)funcName{
    resposeFuncName = funcName;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:@"1.0" forKey:@"ver"];
    NSString* serial = [Utils getRandomString:32];
    [paramsDic setValue:serial forKey:@"serial"];
    [paramsDic setValue:dataDic forKey:@"params"];
    [paramsDic setValue:methodName forKey:@"method"];
    NSString* auth = [NSString stringWithFormat:@"%@%@",serial,[Utils md5:methodName]];
    [paramsDic setValue:[Utils md5:auth] forKey:@"auth"];
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:connectUrl parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            [userInfoDic setValue:resultDic forKey:message];
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
//        [self.delegate NetConnectionResult:userInfoDic];
        [self setUserData:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", NSLocalizedString(@"connect_error", nil));
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//        [self.delegate NetConnectionResult:errorInfoDic];
        [self setUserData:errorInfoDic];
    }];
}

-(void)setUserData:(NSMutableDictionary*)userInfoDic {
//    [self.delegate NetConnectionResult:userInfoDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:resposeFuncName object:nil userInfo:userInfoDic];
}

@end
