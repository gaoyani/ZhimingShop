//
//  OutputInfo.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutputInfo : NSObject

@property NSMutableArray* balancePointArray;
@property NSMutableArray* expectProfitArray;

@property NSMutableArray* humanCostArray;

-(void)parseJson:(NSDictionary*)jsonDic;

@end
