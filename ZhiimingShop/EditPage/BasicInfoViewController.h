//
//  BasicInfoViewController.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/17.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicInfo.h"

@interface BasicInfoViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *textBG;
@property (weak, nonatomic) IBOutlet UITextView *text;

@property BasicInfo* basicInfo;

@end
