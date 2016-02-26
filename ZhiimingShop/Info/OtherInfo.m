//
//  OtherInfo.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "OtherInfo.h"

@implementation OtherInfo

-(OtherInfo*)initData:(NSString*)key name:(NSString*)name userZhiming:(BOOL)userZhiming{
    self = [super init];
    self.key = key;
    self.name = name;
    self.payment = @"0";
    self.paymentUnit = PaymentUnitDay;
    self.isUseZhiming =userZhiming;
    
    return self;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.key = [jsonDic valueForKey:@"key"];
    self.name = [jsonDic valueForKey:@"name"];
    self.payment = [jsonDic valueForKey:@"payment"];
    self.isUseZhiming = [[jsonDic valueForKey:@"use_zhiming"] boolValue];
    self.paymentUnit = [[jsonDic valueForKey:@"payment_unit"] intValue];
}

-(NSDictionary*)getJsonDic {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.key forKey:@"key"];
    [dic setValue:self.name forKey:@"name"];
    [dic setValue:self.payment forKey:@"payment"];
    [dic setValue:[NSNumber numberWithBool:self.isUseZhiming]  forKey:@"use_zhiming"];
    [dic setValue:[NSNumber numberWithInt:self.paymentUnit] forKey:@"payment_unit"];
    
    return dic;
}

@end
