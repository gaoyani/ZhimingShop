//
//  BasicInfo.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "BasicInfo.h"

@implementation BasicInfo

-(BasicInfo*)initData:(NSString*)key name:(NSString*)name value:(NSString*)value {
    self = [super init];
    self.key = key;
    self.name = name;
    self.value = value;
    
    return self;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.key = [jsonDic valueForKey:@"key"];
    self.name = [jsonDic valueForKey:@"name"];
    self.value = [jsonDic valueForKey:@"value"];
}

-(NSDictionary*)getJsonDic {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.key forKey:@"key"];
    [dic setValue:self.name forKey:@"name"];
    [dic setValue:self.value forKey:@"value"];
    
    return dic;
}

@end
