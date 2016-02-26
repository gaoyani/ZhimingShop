//
//  AppDelegate.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/14.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "FileInfo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initNavigationBar];
    [self initParams];
    [self initHistoryAndDraft];
    
    self.paymentUnitList = [NSArray arrayWithObjects:@"天", @"周", @"月", @"年", nil];
    self.seatUnitList = [NSArray arrayWithObjects:@"坐位", @"餐桌", nil];

    return YES;
}

-(void)initNavigationBar {
    //设置返回按钮图片
    UIImage *backUP=[UIImage imageNamed:@"return"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backUP resizableImageWithCapInsets:UIEdgeInsetsMake(0, backUP.size.width, 0, 0)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backUP resizableImageWithCapInsets:UIEdgeInsetsMake(0, backUP.size.width, 0, 0)]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    //去掉返回按钮的标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000.f, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    //导航栏背景色及标题
    UIColor* bgColor = [UIColor colorWithRed:13/255.0 green:184/255.0 blue:246/255.0f alpha:1];
    if ([Utils getDeviceVersion] < 7.0) {
        [[UINavigationBar appearance] setTintColor:bgColor];
    } else {
        [[UINavigationBar appearance] setBarTintColor:bgColor];
        //        [[UINavigationBar appearance] setTranslucent:NO];
        if([Utils getDeviceVersion] > 8.0 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            [[UINavigationBar appearance] setTranslucent:NO];
        } else {
            [[UINavigationBar appearance] setBackgroundColor:bgColor];
        }
    }
    
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20],NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navTitleArr];
    
    if ([Utils getDeviceVersion] >= 7.0) {
        [[UINavigationBar appearance] setTranslucent:NO];  //设置标题半透明
    }
}

-(void)initParams {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:weekDayKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"7" forKey:weekDayKey];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:mouthDayKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"30" forKey:mouthDayKey];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:yearMouthKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"12" forKey:yearMouthKey];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:seatUnitKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",SeatUnitPeople] forKey:seatUnitKey];
    }
}

-(void)initHistoryAndDraft {
    self.historyList = [NSMutableArray array];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[Utils getFilePath:historyFilePath]]) {
        NSString *content = [NSString stringWithContentsOfFile:[Utils getFilePath:historyFilePath] encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
        if(!error) {
            for (NSDictionary* fileDic in array) {
                FileInfo* fileInfo = [[FileInfo alloc] init];
                [fileInfo parseJson:fileDic];
                [self.historyList addObject:fileInfo];
            }
        }
    }

    
    self.draftList = [NSMutableArray array];
    if ([fileManager fileExistsAtPath:[Utils getFilePath:draftFilePath]]) {
        NSString *content = [NSString stringWithContentsOfFile:[Utils getFilePath:draftFilePath] encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        if(!error) {
            for (NSDictionary* fileDic in array) {
                FileInfo* fileInfo = [[FileInfo alloc] init];
                [fileInfo parseJson:fileDic];
                [self.draftList addObject:fileInfo];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveDraftListFile];
    [self saveHistoryListFile];
}

-(void)saveDraftListFile {
    NSMutableArray* jsonArray = [NSMutableArray array];
    for (FileInfo* fileInfo in self.draftList) {
        [jsonArray addObject:[fileInfo getJsonDic]];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
    [jsonString writeToFile:[Utils getFilePath:draftFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)saveHistoryListFile {
    NSMutableArray* jsonArray = [NSMutableArray array];
    for (FileInfo* fileInfo in self.historyList) {
        [jsonArray addObject:[fileInfo getJsonDic]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [jsonString writeToFile:[Utils getFilePath:historyFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveDraftListFile];
    [self saveHistoryListFile];
}

@end
