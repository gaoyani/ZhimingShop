//
//  EmployeeInfo.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface EmployeeInfo : NSObject

@property NSString* key;
@property NSString* name;
@property NSString* payment;
@property NSString* number;
@property enum PaymentUnit paymentUnit;

-(EmployeeInfo*)initData:(NSString*)key name:(NSString*)name;
-(void)parseJson:(NSDictionary*)jsonDic;
-(NSDictionary*)getJsonDic;

@end
