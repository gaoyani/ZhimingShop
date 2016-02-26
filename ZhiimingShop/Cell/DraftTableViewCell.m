//
//  DraftTableViewCell.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/22.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "DraftTableViewCell.h"
#import "FileInfo.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation DraftTableViewCell {
    FileInfo* fileInfo;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setContent:(FileInfo*)info {
    fileInfo = info;
    self.date.text = fileInfo.date;
    self.name.text = fileInfo.restaurantName;
}

//- (IBAction)deleteClick:(id)sender {
//    NSString* message = [NSString stringWithFormat:@"确定删除\"%@\"吗", fileInfo.restaurantName];
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        [((AppDelegate*)[UIApplication sharedApplication].delegate).draftList removeObject:fileInfo];
//        
//        NSFileManager* fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:[Utils getFilePath:fileInfo.fileName] error:nil];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteItem" object:nil];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
