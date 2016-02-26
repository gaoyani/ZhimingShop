//
//  ChoseViewController.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray* nameList;
@property int selIndex;

@end
