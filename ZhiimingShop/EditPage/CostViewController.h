//
//  CostView.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/16.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherInfo.h"

@interface CostViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *zhimingExperience;

@property (weak, nonatomic) IBOutlet UIView *valueView;
@property (weak, nonatomic) IBOutlet UIImageView *costBG;
@property (weak, nonatomic) IBOutlet UITextField *costValue;
@property (weak, nonatomic) IBOutlet UIButton *costUnit;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhimingHeightConstraint;

@property OtherInfo* otherInfo;
@property BOOL hasZhiming;

@end
