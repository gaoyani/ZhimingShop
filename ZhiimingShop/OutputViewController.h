//
//  OutputViewController.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutputInfo.h"

@interface OutputViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property NSMutableDictionary* inputDic;
@property NSDictionary* outputDic;
@property OutputInfo* outputInfo;
@end
