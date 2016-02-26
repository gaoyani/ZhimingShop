//
//  OtherInfo.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface OtherInfo : NSObject

@property NSString* key;
@property NSString* name;
@property NSString* payment;
@property enum PaymentUnit paymentUnit;
@property BOOL isUseZhiming;

-(OtherInfo*)initData:(NSString*)key name:(NSString*)name userZhiming:(BOOL)userZhiming;
-(void)parseJson:(NSDictionary*)jsonDic;
-(NSDictionary*)getJsonDic;

@end
