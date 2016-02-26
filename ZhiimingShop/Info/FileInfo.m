//
//  fileInfo.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "FileInfo.h"

@implementation FileInfo

-(void)parseJson:(NSDictionary*)jsonDic {
    self.date = [jsonDic valueForKey:@"date"];
    self.restaurantName = [jsonDic valueForKey:@"name"];
    self.fileName = [jsonDic valueForKey:@"file_name"];
}

-(NSDictionary*)getJsonDic {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.date forKey:@"date"];
    [dic setValue:self.restaurantName forKey:@"name"];
    [dic setValue:self.fileName forKey:@"file_name"];
    
    return dic;
}

@end
