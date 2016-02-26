//
//  NetConnection.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@protocol NetConnectionDelegate <NSObject>

@required
-(void)NetConnectionResult:(NSMutableDictionary *)result;

@end


@interface NetConnection : NSObject

//@property(assign,nonatomic)id<NetConnectionDelegate> delegate;

@property AFHTTPRequestOperationManager *manager;

-(NetConnection*)init;
-(NSMutableDictionary*)getParamsDictionary:(NSMutableDictionary*)dataDic methodName:(NSString*)methodName;
//-(void)startConnect:(NSString*)connectUrl dataDictionary:(NSMutableDictionary*)dataDic methodName:(NSString*)methodName resposeFuncName:(NSString*)funcName;

@end

