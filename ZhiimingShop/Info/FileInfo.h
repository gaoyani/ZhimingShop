//
//  fileInfo.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject

@property NSString* date;
@property NSString* restaurantName;
@property NSString* fileName;

-(void)parseJson:(NSDictionary*)jsonDic;
-(NSDictionary*)getJsonDic;

@end
