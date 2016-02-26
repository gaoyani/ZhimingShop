//
//  DraftTableViewCell.h
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/22.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileInfo;

@interface DraftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)setContent:(FileInfo*)info;

@end
