//
//  ParamsSettingViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "ParamsSettingViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ValueViewController.h"
#import "ChoseViewController.h"

@interface ParamsSettingViewController () {
    NSArray* paramsNameList;
    NSArray* paramsKeyList;
    NSArray* seatUnitList;
}

@end

@implementation ParamsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    paramsNameList = [NSArray arrayWithObjects:@"周天换算系数",@"月天换算系数",@"年月换算系数",@"餐位计算单位", nil];
    paramsKeyList = [NSArray arrayWithObjects:weekDayKey,mouthDayKey,yearMouthKey,seatUnitKey, nil];
    seatUnitList = ((AppDelegate*)[UIApplication sharedApplication].delegate).seatUnitList;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setExtraCellLineHidden];
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choseResult:) name:@"choseResult" object:nil];
}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)choseResult:(NSNotification*)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    [[NSUserDefaults standardUserDefaults] setValue:[userInfoDic valueForKey:@"select_index"] forKey:seatUnitKey];
    [self.tableView reloadData];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return paramsNameList.count;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.textLabel.text = [paramsNameList objectAtIndex:indexPath.row];
    if (indexPath.row == 3) {
        enum SeatUnit seatUnit = [[[NSUserDefaults standardUserDefaults] stringForKey:seatUnitKey] integerValue];
        cell.detailTextLabel.text = [seatUnitList objectAtIndex:seatUnit];
    } else {
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[paramsKeyList objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        ChoseViewController* viewController = [[ChoseViewController alloc] initWithNibName:@"ChoseViewController" bundle:nil];
        viewController.nameList = seatUnitList;
        viewController.navigationItem.title = [paramsNameList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        BasicInfo* basicInfo = [[BasicInfo alloc] init];
        basicInfo.key = [paramsKeyList objectAtIndex:indexPath.row];
        basicInfo.name = [paramsNameList objectAtIndex:indexPath.row];
        basicInfo.value = [[NSUserDefaults standardUserDefaults] stringForKey:basicInfo.key];
        
        ValueViewController* viewController = [[ValueViewController alloc] initWithNibName:@"ValueViewController" bundle:nil];
        viewController.isText = NO;
        viewController.basicInfo = basicInfo;
        viewController.isParamSetting = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
