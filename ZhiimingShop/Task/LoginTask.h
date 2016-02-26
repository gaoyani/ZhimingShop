//
//  LoginTask.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface LoginTask : NSObject

-(void)login:(NSString*)userName password:(NSString *)password;

@end
