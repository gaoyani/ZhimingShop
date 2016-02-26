//
//  RootViewController.h
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;

-(void)menuClick:(int)menuIndex title:(NSString*)title;

@end
