//
//  EmployeeView.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "EmployeeViewController.h"
#import "AppDelegate.h"

@interface EmployeeViewController () {
    NSArray* paymentUnitList;
}

@end
@implementation EmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.employeeInfo.name;
    
    paymentUnitList = ((AppDelegate*)[UIApplication sharedApplication].delegate).paymentUnitList;
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    UIImage* textBG  = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    self.paymentBG.image = textBG;
    self.peopleNumBG.image = textBG;
    
    self.payment.text = self.employeeInfo.payment;
    self.peopleNum.text = self.employeeInfo.number;
    [self.payment becomeFirstResponder];
    
    [self.paymentUnit.layer setMasksToBounds:YES];
    [self.paymentUnit.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [self.paymentUnit.layer setBorderWidth:1.0]; //边框宽度
    self.paymentUnit.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.paymentUnit setTitle:[NSString stringWithFormat:@"/%@",[paymentUnitList objectAtIndex:self.employeeInfo.paymentUnit]] forState:UIControlStateNormal];
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  /%@  ",[paymentUnitList objectAtIndex:self.employeeInfo.paymentUnit]]];
//    NSRange strRange = {0,[str length]};
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];  //设置颜色
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [self.paymentUnit setAttributedTitle:str forState:UIControlStateNormal];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)closeKeyBoard {
    [self.payment resignFirstResponder];
    [self.peopleNum resignFirstResponder];
}


- (IBAction)paymentUnitClick:(id)sender {
    [self pickerViewAppear];
    [self.payment resignFirstResponder];
    [self.peopleNum resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.employeeInfo.payment = self.payment.text;
    self.employeeInfo.number = self.peopleNum.text;
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
    [self.paymentUnit setTitle:[NSString stringWithFormat:@"/%@",[paymentUnitList objectAtIndex:row]] forState:UIControlStateNormal];
    self.employeeInfo.paymentUnit = row;
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
