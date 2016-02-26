//
//  CostView.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "CostViewController.h"
#import "AppDelegate.h"

@interface CostViewController () {
    NSArray* paymentUnitList;
}

@end
@implementation CostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.otherInfo.name;
    paymentUnitList = ((AppDelegate*)[UIApplication sharedApplication].delegate).paymentUnitList;
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    self.costBG.image = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    self.costValue.text = self.otherInfo.payment;
    [self.costValue becomeFirstResponder];
    
    [self.costUnit.layer setMasksToBounds:YES];
    [self.costUnit.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [self.costUnit.layer setBorderWidth:1.0]; //边框宽度
    self.costUnit.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.costUnit setTitle:[NSString stringWithFormat:@"/%@",[paymentUnitList objectAtIndex:self.otherInfo.paymentUnit]] forState:UIControlStateNormal];
    
    if (self.hasZhiming) {
        self.zhimingExperience.selected = self.otherInfo.isUseZhiming;
        self.valueView.hidden = self.otherInfo.isUseZhiming;
    } else {
        self.zhimingHeightConstraint.constant = 0;
        self.zhimingExperience.hidden = YES;
    }
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)closeKeyBoard {
    [self.costValue resignFirstResponder];
}

- (IBAction)paymentUnitClick:(id)sender {
    [self pickerViewAppear];
    [self.costValue resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.otherInfo.payment = self.costValue.text;
}

- (IBAction)zhimingCheckClick:(id)sender {
    self.zhimingExperience.selected = !self.zhimingExperience.selected;
    self.otherInfo.isUseZhiming = self.zhimingExperience.selected;
    self.valueView.hidden = self.otherInfo.isUseZhiming;
}

#pragma mark pickerview function
/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return paymentUnitList.count;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [paymentUnitList objectAtIndex:row];
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.costUnit setTitle:[NSString stringWithFormat:@"/%@",[paymentUnitList objectAtIndex:row]] forState:UIControlStateNormal];
    self.otherInfo.paymentUnit = row;
    [self pickerViewDisappear];
}

-(void)pickerViewAppear {
    self.pickerView.hidden = NO;
    self.pickerView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.transform = CGAffineTransformIdentity;
        self.pickerView.alpha = 1.0f;
    }];
}

-(void)pickerViewDisappear {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.pickerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.pickerView.hidden = YES;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
