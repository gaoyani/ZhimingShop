//
//  ViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/14.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "LoginViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "Constants.h"
#import "LoginTask.h"
#import "Utils.h"

@interface LoginViewController () {
    LoginTask* task;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* textBG  = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    self.userNameBG.image = textBG;
    self.passwordBG.image = textBG;
    
    self.loadingView.hidden = YES;
    
    self.userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:userNameKey];
    
    self.userName.delegate = self;
    self.password.delegate = self;
    
    task = [[LoginTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loginResult:)
     name:@"loginResult"
     object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height-(self.login.frame.origin.y+self.login.frame.size.height+216+50);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.transform = CGAffineTransformMakeTranslation(0, offset);
        }];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self resumeView];
    
    return YES;
}

-(void)resumeView {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (IBAction)loginClick:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self resumeView];
    
    if (self.userName.text == nil || [self.userName.text isEqualToString:@""] || self.password.text == nil || [self.password.text isEqualToString:@""]) {
        [Utils showMessage:@"请输入登录用户名或密码"];
    } else {
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
        [[NSUserDefaults standardUserDefaults] setValue:self.userName.text forKey:userNameKey];
        
        [task login:self.userName.text password:self.password.text];
    }
    
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    MMDrawerController* drawerController = [[MMDrawerController alloc] initWithCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"CenterView"] leftDrawerViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenu"]];
//    
//    //    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
//    [drawerController setMaximumLeftDrawerWidth:200.0];
//    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [self presentViewController:drawerController animated:YES completion:nil];
}

-(void)loginResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MMDrawerController* drawerController = [[MMDrawerController alloc] initWithCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"CenterView"] leftDrawerViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenu"]];
        
        //    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
        [drawerController setMaximumLeftDrawerWidth:200.0];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [self presentViewController:drawerController animated:YES completion:nil];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
