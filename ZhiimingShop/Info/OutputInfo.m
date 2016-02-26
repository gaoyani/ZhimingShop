//
//  OutputInfo.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "OutputInfo.h"
#import "BasicInfo.h"

@implementation OutputInfo

-(OutputInfo*)init {
    self = [super init];
    
    self.balancePointArray = [NSMutableArray array];
    self.expectProfitArray = [NSMutableArray array];
    self.humanCostArray = [NSMutableArray array];
    
    return self;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    NSArray* breakEvenPointArray = [jsonDic objectForKey:@"break_even_point"];
    for (NSDictionary* pointDic in breakEvenPointArray) {
        BasicInfo* basicInfo = [[BasicInfo alloc] init];
        basicInfo.name = [pointDic valueForKey:@"name"];
        basicInfo.value = [[pointDic valueForKey:@"value"] stringValue];
        [self.balancePointArray addObject:basicInfo];
    }
    
    NSArray* expectProfitArray = [jsonDic objectForKey:@"expect_profit"];
    for (NSDictionary* expectProfitDic in expectProfitArray) {
        BasicInfo* basicInfo = [[BasicInfo alloc] init];
        basicInfo.name = [expectProfitDic valueForKey:@"name"];
        basicInfo.value = [[expectProfitDic valueForKey:@"value"] stringValue];
        [self.expectProfitArray addObject:basicInfo];
    }
    
    NSArray* humanCostArray = [jsonDic objectForKey:@"human_cost"];
    for (NSDictionary* humanCostDic in humanCostArray) {
        BasicInfo* basicInfo = [[BasicInfo alloc] init];
        basicInfo.name = [humanCostDic valueForKey:@"name"];
        basicInfo.value = [humanCostDic valueForKey:@"value"];
        [self.humanCostArray addObject:basicInfo];
    }
}

@end
