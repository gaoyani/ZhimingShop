//
//  LeftMenuViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "RootViewController.h"
#import "Constants.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self setExtraCellLineHidden];
    
    self.userName.text = [[NSUserDefaults standardUserDefaults] stringForKey:userNameKey];
    
    menuLists = [NSArray arrayWithObjects:@"计算",@"参数设置",@"历史纪录",@"草稿", nil];
    
    //ios8 解决分割线没有左对齐问题
//    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.menuTableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.menuTableView setLayoutMargins:UIEdgeInsetsZero];
//    }

}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.menuTableView setTableFooterView:view];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuLists.count;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //cell右侧小箭头
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.text = [menuLists objectAtIndex:indexPath.row];
//int imageSize = 25;
//            cell.imageView.image = [Utils scaleToSize:[UIImage imageNamed:@"main_order"] size:CGSizeMake(imageSize, imageSize)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 0:
//            self.moreInfoContainer.hidden = YES;
//            self.orderContainer.hidden = NO;
//            [self viewMoveLeft];
//            break;
//            
//        case 1:
//            self.orderContainer.hidden = YES;
//            self.moreInfoContainer.hidden = NO;
//            [self viewMoveLeft];
//            break;
//            
//        default:
//            break;
//    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        RootViewController *rootViewController = (RootViewController*)[(UINavigationController *)self.mm_drawerController.centerViewController topViewController];
        [rootViewController menuClick:(int)indexPath.row title:[menuLists objectAtIndex:indexPath.row]];
    }];

    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
