//
//  LoginTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "LoginTask.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"
#import "AFHTTPRequestOperationManager.h"

@implementation LoginTask {
    NetConnection* netConnection;
}

-(LoginTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    
    return self;
}

-(void)login:(NSString*)userName password:(NSString *)password {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:userName forKey:@"username"];
    [dataDic setValue:password forKey:@"password"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    [netConnection.manager POST:[UrlConstants getUrl:login_url] parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            BOOL success = [[resultDic objectForKey:@"status"] intValue] == 1;
            NSString* message = [resultDic objectForKey:@"message"];
            if (success) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:message forKey:errorMessage];
            }
        } else {
            [userInfoDic setValue:@"登录失败，请检查网络" forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResult" object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:@"登录失败，请检查网络" forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResult" object:self userInfo:errorInfoDic];
    }];
}

//-(void)loginResult:(NSNotification *)notification {
//    NSString* loginFail = NSLocalizedString(@"login_fail", nil);
//    
//    NSDictionary* result = notification.userInfo;
//    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
//    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
//    if (isSucceed) {
//        NSDictionary* resultDic = [result objectForKey:message];
//        NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
//        NSString* resultFlag = [jsonDic objectForKey:@"loginflag"];
//        if ([resultFlag isEqualToString:@"success"]) {
//            //                Preferences.SetString(context, "session_id", sessionID);
//            //                Preferences.SetString(context, "user_id",
//            //                                      String.valueOf(jsonPhone.getInt("waiterid")));
//            [[NSUserDefaults standardUserDefaults]  setValue:[jsonDic objectForKey:@"waiterid"] forKey:userIDKey];
//            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
//        } else if ([resultFlag isEqualToString:@"logined"]){
//            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//            [userInfoDic setValue:NSLocalizedString(@"login_already", nil) forKey:errorMessage];
//        } else {
//            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//            [userInfoDic setValue:loginFail forKey:errorMessage];
//        }
//
//    } else {
//        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//        [userInfoDic setValue:loginFail forKey:errorMessage];
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:resposeFuncName object:self userInfo:userInfoDic];
//
//}

@end
