//
//  RootViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "RootViewController.h"
#import "DataInputViewController.h"
#import "ParamsSettingViewController.h"
#import "HistoryViewController.h"
#import "DraftListViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface RootViewController () {
    UIViewController* currentViewController;
    DataInputViewController *inputViewController;
    ParamsSettingViewController *settingViewController;
    HistoryViewController *historyViewController;
    DraftListViewController* draftListViewController;
    BOOL isStartDelete;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self mainMenuButton];
    self.navigationItem.rightBarButtonItem = [self rightBarButton:@"保存"];
    
    inputViewController = [[DataInputViewController alloc] initWithNibName:@"DataInputViewController" bundle:nil];
    inputViewController.inputPageFrom = InputPageFromMenu;
    [inputViewController.view setFrame:self.view.frame];
    [self addChildViewController:inputViewController];
    
    settingViewController = [[ParamsSettingViewController alloc] initWithNibName:@"ParamsSettingViewController" bundle:nil];
    [settingViewController.view setFrame:self.view.frame];
    [self addChildViewController:settingViewController];
    
    historyViewController=[[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    [historyViewController.view setFrame:self.view.frame];
    [self addChildViewController:historyViewController];
    
    draftListViewController=[[DraftListViewController alloc] initWithNibName:@"DraftListViewController" bundle:nil];
    [draftListViewController.view setFrame:self.view.frame];
    [self addChildViewController:draftListViewController];
    
    self.navigationItem.title = @"计算";
    [self.view addSubview:inputViewController.view];
    currentViewController = inputViewController;
}

-(UIBarButtonItem*)mainMenuButton{
    UIImage *btnImage = [UIImage imageNamed:@"main_menu"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mainMenuClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mainMenuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return mainMenuItem;
}

-(UIBarButtonItem*)rightBarButton:(NSString*)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return plusItem;
}

-(void)mainMenuClick {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightBarButtonClick {
    if (currentViewController == inputViewController) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定保存草稿吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        isStartDelete = !isStartDelete;
        [self deleteButtonClick];
    }
}

-(void)deleteButtonClick {
    self.navigationItem.rightBarButtonItem = [self rightBarButton:isStartDelete ? @"确定" : @"删除"];
    if (currentViewController == draftListViewController) {
        [draftListViewController rightBarButtonClick:isStartDelete];
    } else {
        [historyViewController rightBarButtonClick:isStartDelete];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [inputViewController saveDraft];
    }
}

-(void)menuClick:(int)menuIndex title:(NSString*)title {
    
    if ((currentViewController == inputViewController && menuIndex == 0) || (currentViewController == settingViewController && menuIndex == 1) || (currentViewController == historyViewController && menuIndex == 2) || (currentViewController == draftListViewController && menuIndex == 3)) {
        return;
    }

    switch (menuIndex) {
        case 0: {
            [self transitionFromViewController:currentViewController toViewController:inputViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController = inputViewController;
                    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                    self.navigationItem.rightBarButtonItem = [self rightBarButton:@"保存"];
                }
            }];
        }
            break;
        case 1: {
            [self transitionFromViewController:currentViewController toViewController:settingViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=settingViewController;
                    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
                }
            }];
        }
            break;
        case 2: {
            [self transitionFromViewController:currentViewController toViewController:historyViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=historyViewController;
                    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                    isStartDelete = NO;
                    [self deleteButtonClick];
                    
                }
            }];
        }
            break;
        case 3: {
            [self transitionFromViewController:currentViewController toViewController:draftListViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=draftListViewController;
                    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
                    isStartDelete = NO;
                    [self deleteButtonClick];
                }
            }];
        }
            break;
        default:
            break;
    }
    
    self.navigationItem.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
