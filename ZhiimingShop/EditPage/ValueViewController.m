//
//  ValueViewController.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/17.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "ValueViewController.h"

@interface ValueViewController ()

@end

@implementation ValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.basicInfo.name;
    
    self.value.delegate = self;
    self.value.returnKeyType = UIReturnKeyDone;
    self.value.text = self.basicInfo.value;
    [self.value becomeFirstResponder];
    self.bgImage.image = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    if (self.isText) {
        self.value.keyboardType = UIKeyboardTypeDefault;
        [self.value setPlaceholder:@"最多输入20个字符"];
    }
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)closeKeyBoard {
    [self.value resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isParamSetting) {
        [[NSUserDefaults standardUserDefaults] setValue:self.value.text forKey:self.basicInfo.key];
    } else {
        self.basicInfo.value = self.value.text;
    }
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
