//
//  OutputViewController.m
//  ZhimingShop
//
//  Created by 高亚妮 on 15/12/18.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "OutputViewController.h"
#import "BasicInfo.h"
#import "FileInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "EmployeeInfo.h"
#import "OtherInfo.h"

@interface OutputViewController () {
}

@end

@implementation OutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"输出结果";
    self.navigationItem.rightBarButtonItem = [self saveRecordButton];
    
    self.outputInfo = [[OutputInfo alloc] init];
    [self.outputInfo parseJson:self.outputDic];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(UIBarButtonItem*)saveRecordButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveRecordClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return plusItem;
}

-(void)saveRecordClick {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定保存记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateTime = [dateFormatter stringFromDate:[NSDate date]];
        FileInfo* fileInfo = [[FileInfo alloc] init];
        fileInfo.date = dateTime;
        NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
        BasicInfo* basicInfo = [basicArray objectAtIndex:InputDataName];
        fileInfo.restaurantName = basicInfo.value;
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        fileInfo.fileName = [NSString stringWithFormat:@"%@.txt",[dateFormatter stringFromDate:[NSDate date]]];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).historyList addObject:fileInfo];
        [self saveRecordFile:[Utils getFilePath:fileInfo.fileName]];

    }
}

-(void)saveRecordFile:(NSString*)fileName {
    NSMutableDictionary* jsonDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* inputDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* basicJsonArray = [NSMutableArray array];
    NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
    for (BasicInfo* basicInfo in basicArray) {
        [basicJsonArray addObject:[basicInfo getJsonDic]];
    }
    [inputDic setObject:basicJsonArray forKey:basicInfoKey];
    
    NSMutableArray* employeeJsonArray = [NSMutableArray array];
    NSArray* employeeArray = [self.inputDic valueForKey:employeeInfoKey];
    for (EmployeeInfo* employeeInfo in employeeArray) {
        [employeeJsonArray addObject:[employeeInfo getJsonDic]];
    }
    [inputDic setObject:employeeJsonArray forKey:employeeInfoKey];
    
    NSMutableArray* otherJsonArray = [NSMutableArray array];
    NSArray* otherArray = [self.inputDic valueForKey:otherInfoKey];
    for (OtherInfo* otherInfo in otherArray) {
        [otherJsonArray addObject:[otherInfo getJsonDic]];
    }
    [inputDic setObject:otherJsonArray forKey:otherInfoKey];
    [jsonDic setObject:inputDic forKey:@"input_data"];
    [jsonDic setObject:self.outputDic forKey:@"output_data"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        BOOL success = [jsonString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [((AppDelegate*)[UIApplication sharedApplication].delegate) saveHistoryListFile];
        
        [Utils showMessage:success ? @"保存成功" : @"保存失败，请重试"];
    } else {
        NSLog(@"%@", error.description);
    }
}


#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.outputInfo.balancePointArray.count;
    } else if (section == 1) {
        return self.outputInfo.expectProfitArray.count;
    }else {
        return self.outputInfo.humanCostArray.count;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return @"  盈亏平衡点";
    } else if (section == 1) {
        return @"  达到预想翻台率后的利润预测";
    }else {
        return @"  人力成本详情";
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
//        UIView* footerView = [[UIView alloc] init];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button setTitle:@"开始计算" forState:UIControlStateNormal ];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
//        button.layer.cornerRadius = 4.0;
//        button.frame = CGRectMake(10, 15, [UIScreen mainScreen].bounds.size.width-20, 35);
//        button.backgroundColor = [UIColor colorWithRed:13/255.0 green:184/255.0 blue:246/255.0f alpha:1];
//        [button addTarget:self action:@selector(footerButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [footerView addSubview:button];
//        return footerView;
    }
    
    return nil;
}

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
    
    cell.accessoryType = UITableViewCellAccessoryNone; //cell右侧小箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    if (indexPath.section == 0) {
        BasicInfo* basicInfo = [self.outputInfo.balancePointArray objectAtIndex:indexPath.row];
        cell.textLabel.text = basicInfo.name;
        cell.detailTextLabel.text = basicInfo.value;
    } else if (indexPath.section == 1) {
        BasicInfo* basicInfo = [self.outputInfo.expectProfitArray objectAtIndex:indexPath.row];
        cell.textLabel.text = basicInfo.name;
        NSString* detail = [NSString stringWithFormat:@"%@元",basicInfo.value];
        cell.detailTextLabel.text = detail;
    } else {
        BasicInfo* basicInfo = [self.outputInfo.humanCostArray objectAtIndex:indexPath.row];
        cell.textLabel.text = basicInfo.name;
        cell.detailTextLabel.text = basicInfo.value;
    }
    
    return cell;
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
