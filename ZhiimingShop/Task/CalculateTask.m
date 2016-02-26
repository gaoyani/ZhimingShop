//
//  CommonInfoTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "CalculateTask.h"
#import "NetConnection.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "BasicInfo.h"
#import "EmployeeInfo.h"
#import "OtherInfo.h"

@implementation CalculateTask {
    NetConnection* netConnection;
}

-(CalculateTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    
    return  self;
}


-(void)getResult:(NSMutableDictionary*)inputDic resultFuncName:(NSString*)resultName{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:userNameKey] forKey:@"username"];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:weekDayKey] forKey:weekDayKey];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:mouthDayKey] forKey:mouthDayKey];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:yearMouthKey] forKey:yearMouthKey];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:seatUnitKey] forKey:seatUnitKey];
    
    NSArray* basicArray = [inputDic valueForKey:basicInfoKey];
    for (BasicInfo* basicInfo in basicArray) {
        [dataDic setValue:[basicInfo getJsonDic] forKey:basicInfo.key];
    }
    
    NSArray* employeeArray = [inputDic valueForKey:employeeInfoKey];
    for (EmployeeInfo* employeeInfo in employeeArray) {
        [dataDic setValue:[employeeInfo getJsonDic] forKey:employeeInfo.key];
    }
    
    NSArray* otherArray = [inputDic valueForKey:otherInfoKey];
    for (OtherInfo* otherInfo in otherArray) {
        [dataDic setValue:[otherInfo getJsonDic] forKey:otherInfo.key];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    [netConnection.manager POST:[UrlConstants getUrl:calculate_url] parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            [userInfoDic setValue:resultDic forKey:message];
        } else {
            [userInfoDic setValue:@"获取结果失败" forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:resultName object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.debugDescription);
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:@"获取结果失败" forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:resultName object:self userInfo:errorInfoDic];
    }];
    
}

@end
