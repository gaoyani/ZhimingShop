//
//  ParamsInputViewController.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "FileInfo.h"

@interface DataInputViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    NSArray* basicNameLists;
    NSArray* employeeNameLists;
    NSArray* otherNameLists;
    NSArray* paymentUnitList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property NSMutableDictionary* inputDic;
@property enum InputPageFrom inputPageFrom;
@property FileInfo* fileInfo;

-(void)saveDraft;

@end
