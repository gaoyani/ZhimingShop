//
//  EmployeeView.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeInfo.h"

@interface EmployeeViewController: UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *paymentBG;
@property (weak, nonatomic) IBOutlet UITextField *payment;
@property (weak, nonatomic) IBOutlet UIButton *paymentUnit;
@property (weak, nonatomic) IBOutlet UIImageView *peopleNumBG;
@property (weak, nonatomic) IBOutlet UITextField *peopleNum;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property EmployeeInfo* employeeInfo;

@end
