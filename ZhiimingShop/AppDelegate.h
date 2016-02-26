//
//  AppDelegate.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/14.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSArray* paymentUnitList;
@property NSArray* seatUnitList;

@property NSMutableArray* historyList;
@property NSMutableArray* draftList;

-(void)saveDraftListFile;
-(void)saveHistoryListFile;

@end

