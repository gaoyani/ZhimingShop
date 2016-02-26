//
//  BasicInfoViewController.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/17.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "BasicInfoViewController.h"

@interface BasicInfoViewController ()

@end

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.basicInfo.name;
    
    self.text.delegate = self;
    self.text.text = self.basicInfo.value;
    [self.text becomeFirstResponder];
    self.textBG.image = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];

    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)closeKeyBoard {
    [self.text resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.basicInfo.value = self.text.text;
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
