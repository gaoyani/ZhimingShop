//
//  BasicInfo.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface BasicInfo : NSObject

@property NSString* key;
@property NSString* name;
@property NSString* value;

-(BasicInfo*)initData:(NSString*)key name:(NSString*)name value:(NSString*)value;
-(void)parseJson:(NSDictionary*)jsonDic;
-(NSDictionary*)getJsonDic;

@end
