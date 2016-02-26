//
//  EmployeeInfo.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "EmployeeInfo.h"

@implementation EmployeeInfo

-(EmployeeInfo*)initData:(NSString*)key name:(NSString*)name {
    self = [super init];
    self.key = key;
    self.name = name;
    self.payment = @"0";
    self.paymentUnit = PaymentUnitDay;
    self.number = @"0";
    
    return self;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.key = [jsonDic valueForKey:@"key"];
    self.name = [jsonDic valueForKey:@"name"];
    self.payment = [jsonDic valueForKey:@"payment"];
    self.number = [jsonDic valueForKey:@"number"];
    self.paymentUnit = [[jsonDic valueForKey:@"payment_unit"] intValue];
}

-(NSDictionary*)getJsonDic {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.key forKey:@"key"];
    [dic setValue:self.name forKey:@"name"];
    [dic setValue:self.payment forKey:@"payment"];
    [dic setValue:self.number forKey:@"number"];
    [dic setValue:[NSNumber numberWithInt:self.paymentUnit] forKey:@"payment_unit"];
    
    return dic;
}

@end
