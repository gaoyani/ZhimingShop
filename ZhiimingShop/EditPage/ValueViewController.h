//
//  ValueViewController.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/17.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicInfo.h"

@interface ValueViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UITextField *value;

@property BasicInfo* basicInfo;
@property BOOL isText;
@property BOOL isParamSetting;

@end
