//
//  ParamsInputViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "DataInputViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "BasicInfo.h"
#import "EmployeeInfo.h"
#import "OtherInfo.h"
#import "EmployeeViewController.h"
#import "CostViewController.h"
#import "ValueViewController.h"
#import "BasicInfoViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "FileInfo.h"
#import "CalculateTask.h"
#import "OutputViewController.h"

@interface DataInputViewController () {
    CalculateTask* task;
    NSDictionary* historyOutputDic;
}

@end

@implementation DataInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.fileInfo != nil) {
        self.navigationItem.title = self.fileInfo.restaurantName;
    }
    
    if (self.inputPageFrom == InputPageFromDraft) {
        self.navigationItem.rightBarButtonItem = [self saveDraftButton];
    }

    paymentUnitList = ((AppDelegate*)[UIApplication sharedApplication].delegate).paymentUnitList;
    basicNameLists = [NSArray arrayWithObjects:@"餐厅别名",@"餐厅基本信息",@"餐桌数",@"桌均消费", @"预想翻台率",nil];
    employeeNameLists = [NSArray arrayWithObjects:@"厨师长/高级厨师",@"普通厨师",@"帮厨/洗碗/杂工",@"店长/经理", @"领班",@"服务员/收银员",nil];
    otherNameLists = [NSArray arrayWithObjects:@"房租物业",@"食材/原料成本",@"饮品成本",@"杂费开销",nil];
    [self initData];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.loadingView.hidden = YES;
    task = [[CalculateTask alloc] init];
    if (self.inputPageFrom == InputPageFromMenu) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(calculateResult:)
         name:@"calculateResult"
         object:nil];
    } else if (self.inputPageFrom == InputPageFromDraft) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(draftCalculateResult:)
         name:@"draftCalculateResult"
         object:nil];
    }
}

-(UIBarButtonItem*)saveDraftButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveDraft) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return plusItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.inputPageFrom != InputPageFromMenu) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.inputPageFrom != InputPageFromMenu) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
}

-(void)initData {
    self.inputDic = [[NSMutableDictionary alloc] init];
    if (self.inputPageFrom == InputPageFromMenu) {
        [self newData];
    } else if(self.inputPageFrom == InputPageFromHistory) {
        [self parseHistoryJson];
    } else {
        [self parseDraftJson];
    }
}

-(void)parseHistoryJson {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[Utils getFilePath:self.fileInfo.fileName]]) {
        NSString *content = [NSString stringWithContentsOfFile:[Utils getFilePath:self.fileInfo.fileName] encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
        if(!error) {
            NSDictionary* historyInputDic = [jsonDic objectForKey:@"input_data"];
            historyOutputDic = [jsonDic objectForKey:@"output_data"];
            NSArray* basicJsonArray = [historyInputDic objectForKey:basicInfoKey];
            NSMutableArray* basicArray = [NSMutableArray array];
            for (NSDictionary* basicDic in basicJsonArray) {
                BasicInfo* basicInfo = [[BasicInfo alloc] init];
                [basicInfo parseJson:basicDic];
                [basicArray addObject:basicInfo];
            }
            [self.inputDic setValue:basicArray forKey:basicInfoKey];
            
            NSArray* employeeJsonArray = [historyInputDic objectForKey:employeeInfoKey];
            NSMutableArray* employeeArray = [NSMutableArray array];
            for (NSDictionary* employeeDic in employeeJsonArray) {
                EmployeeInfo* employeeInfo = [[EmployeeInfo alloc] init];
                [employeeInfo parseJson:employeeDic];
                [employeeArray addObject:employeeInfo];
            }
            [self.inputDic setValue:employeeArray forKey:employeeInfoKey];
            
            NSArray* otherJsonArray = [historyInputDic objectForKey:otherInfoKey];
            NSMutableArray* otherArray = [NSMutableArray array];
            for (NSDictionary* otherDic in otherJsonArray) {
                OtherInfo* otherInfo = [[OtherInfo alloc] init];
                [otherInfo parseJson:otherDic];
                [otherArray addObject:otherInfo];
            }
            [self.inputDic setValue:otherArray forKey:otherInfoKey];
        } else {
            [Utils showMessage:@"打开历史纪录失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [Utils showMessage:@"打开历史纪录失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)parseDraftJson {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[Utils getFilePath:self.fileInfo.fileName]]) {
        NSString *content = [NSString stringWithContentsOfFile:[Utils getFilePath:self.fileInfo.fileName] encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
        if(!error) {
            NSArray* basicJsonArray = [jsonDic objectForKey:basicInfoKey];
            NSMutableArray* basicArray = [NSMutableArray array];
            for (NSDictionary* basicDic in basicJsonArray) {
                BasicInfo* basicInfo = [[BasicInfo alloc] init];
                [basicInfo parseJson:basicDic];
                [basicArray addObject:basicInfo];
            }
            [self.inputDic setValue:basicArray forKey:basicInfoKey];
            
            NSArray* employeeJsonArray = [jsonDic objectForKey:employeeInfoKey];
            NSMutableArray* employeeArray = [NSMutableArray array];
            for (NSDictionary* employeeDic in employeeJsonArray) {
                EmployeeInfo* employeeInfo = [[EmployeeInfo alloc] init];
                [employeeInfo parseJson:employeeDic];
                [employeeArray addObject:employeeInfo];
            }
            [self.inputDic setValue:employeeArray forKey:employeeInfoKey];
            
            NSArray* otherJsonArray = [jsonDic objectForKey:otherInfoKey];
            NSMutableArray* otherArray = [NSMutableArray array];
            for (NSDictionary* otherDic in otherJsonArray) {
                OtherInfo* otherInfo = [[OtherInfo alloc] init];
                [otherInfo parseJson:otherDic];
                [otherArray addObject:otherInfo];
            }
            [self.inputDic setValue:otherArray forKey:otherInfoKey];
        } else {
            [Utils showMessage:@"打开草稿失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [Utils showMessage:@"打开草稿失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)newData {
    NSMutableArray* basicArray = [NSMutableArray array];
    [self.inputDic setValue:basicArray forKey:basicInfoKey];
    [basicArray addObject:[[BasicInfo alloc] initData:@"name" name:[basicNameLists objectAtIndex:InputDataName] value:@""]];
    [basicArray addObject:[[BasicInfo alloc] initData:@"basic_info" name:[basicNameLists objectAtIndex:InputDataInfo] value:@""]];
    
    enum SeatUnit seatUnit = [[[NSUserDefaults standardUserDefaults] stringForKey:seatUnitKey] intValue];
    [basicArray addObject:[[BasicInfo alloc] initData:@"number" name:(seatUnit == SeatUnitPeople ? @"坐位数" : @"餐桌数") value:@""]];
    [basicArray addObject:[[BasicInfo alloc] initData:@"consume" name:(seatUnit == SeatUnitPeople ? @"人均消费" : @"桌均消费") value:@""]];
    [basicArray addObject:[[BasicInfo alloc] initData:@"probability" name:[basicNameLists objectAtIndex:InputDataProbability] value:@"2.0"]];
    
    NSMutableArray* employeeArray = [NSMutableArray array];
    [self.inputDic setValue:employeeArray forKey:employeeInfoKey];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"chef" name:[employeeNameLists objectAtIndex:InputDataChief]]];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"cook" name:[employeeNameLists objectAtIndex:InputDataCook]]];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"backman" name:[employeeNameLists objectAtIndex:InputDataBackman]]];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"manager" name:[employeeNameLists objectAtIndex:InputDataManager]]];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"foreman" name:[employeeNameLists objectAtIndex:InputDataForeman]]];
    [employeeArray addObject:[[EmployeeInfo alloc] initData:@"waiter" name:[employeeNameLists objectAtIndex:InputDataCashier]]];
    
    NSMutableArray* otherArray = [NSMutableArray array];
    [self.inputDic setValue:otherArray forKey:otherInfoKey];
    [otherArray addObject:[[OtherInfo alloc] initData:@"rent" name:[otherNameLists objectAtIndex:InputDataRent] userZhiming:NO]];
    [otherArray addObject:[[OtherInfo alloc] initData:@"food" name:[otherNameLists objectAtIndex:InputDataFood] userZhiming:YES]];
    [otherArray addObject:[[OtherInfo alloc] initData:@"drink" name:[otherNameLists objectAtIndex:InputDataDrink] userZhiming:YES]];
    [otherArray addObject:[[OtherInfo alloc] initData:@"extras" name:[otherNameLists objectAtIndex:InputDataExtras] userZhiming:YES]];
}

-(void)saveDraft {
    NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
    BasicInfo* basicInfo = [basicArray objectAtIndex:InputDataName];//[basicDic valueForKey:[NSString stringWithFormat:@"%d",InputDataName]];
    if ([basicInfo.value isEqualToString:@""]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"需要输入餐厅别名才能保存草稿" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        if (self.inputPageFrom == InputPageFromMenu) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateTime = [dateFormatter stringFromDate:[NSDate date]];
            FileInfo* fileInfo = [[FileInfo alloc] init];
            fileInfo.date = dateTime;
            fileInfo.restaurantName = basicInfo.value;
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            fileInfo.fileName = [NSString stringWithFormat:@"%@.txt",[dateFormatter stringFromDate:[NSDate date]]];
            [((AppDelegate*)[UIApplication sharedApplication].delegate).draftList addObject:fileInfo];
            [self saveDraftFile:[Utils getFilePath:fileInfo.fileName]];
        } else {
            [self saveDraftFile:[Utils getFilePath:self.fileInfo.fileName]];
        }
    }
}

-(void)saveDraftFile:(NSString*)fileName {
    NSMutableDictionary* jsonDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* basicJsonArray = [NSMutableArray array];
    NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
    for (BasicInfo* basicInfo in basicArray) {
        [basicJsonArray addObject:[basicInfo getJsonDic]];
    }
    [jsonDic setObject:basicJsonArray forKey:basicInfoKey];
    
    NSMutableArray* employeeJsonArray = [NSMutableArray array];
    NSArray* employeeArray = [self.inputDic valueForKey:employeeInfoKey];
    for (EmployeeInfo* employeeInfo in employeeArray) {
        [employeeJsonArray addObject:[employeeInfo getJsonDic]];
    }
     [jsonDic setObject:employeeJsonArray forKey:employeeInfoKey];
    
    NSMutableArray* otherJsonArray = [NSMutableArray array];
    NSArray* otherArray = [self.inputDic valueForKey:otherInfoKey];
    for (OtherInfo* otherInfo in otherArray) {
        [otherJsonArray addObject:[otherInfo getJsonDic]];
    }
    [jsonDic setObject:otherJsonArray forKey:otherInfoKey];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        BOOL success = [jsonString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [((AppDelegate*)[UIApplication sharedApplication].delegate) saveDraftListFile];
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
        return 5;
    } else if (section == 1) {
        return 6;
    }else {
        return 4;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return @"  基本信息";
    } else if (section == 1) {
        return @"  人工成本";
    }else {
        return @"  其他成本";
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 70;
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView* footerView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"开始计算" forState:UIControlStateNormal ];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        button.layer.cornerRadius = 4.0;
        button.frame = CGRectMake(10, 15, [UIScreen mainScreen].bounds.size.width-20, 35);
        button.backgroundColor = [UIColor colorWithRed:13/255.0 green:184/255.0 blue:246/255.0f alpha:1];
        [button addTarget:self action:@selector(footerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
        return footerView;
    }
    
    return nil;
}

-(void)footerButtonClick {
    if (self.inputPageFrom == InputPageFromHistory) {
        OutputViewController* viewController = [[OutputViewController alloc] initWithNibName:@"OutputViewController" bundle:nil];
        viewController.outputDic = historyOutputDic;
        viewController.navigationItem.rightBarButtonItem.customView.hidden = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        self.loadingView.hidden = NO;
        [task getResult:self.inputDic resultFuncName:(self.inputPageFrom == InputPageFromMenu) ? @"calculateResult" : @"draftCalculateResult"];
    }
}

-(void)calculateResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        OutputViewController* viewController = [[OutputViewController alloc] initWithNibName:@"OutputViewController" bundle:nil];
        viewController.inputDic = self.inputDic;
        viewController.outputDic = [userInfoDic objectForKey:message];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}
-(void)draftCalculateResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        OutputViewController* viewController = [[OutputViewController alloc] initWithNibName:@"OutputViewController" bundle:nil];
        viewController.inputDic = self.inputDic;
        viewController.outputDic = [userInfoDic objectForKey:message];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //cell右侧小箭头
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    if (indexPath.section == 0) {
        NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
        BasicInfo* basicInfo = [basicArray objectAtIndex:indexPath.row];
        cell.textLabel.text = basicInfo.name;
        cell.detailTextLabel.text = basicInfo.value;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [employeeNameLists objectAtIndex:indexPath.row];
        NSArray* employeeArray = [self.inputDic valueForKey:employeeInfoKey];
        EmployeeInfo* employeeInfo = [employeeArray objectAtIndex:indexPath.row];//[employeeDic valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        NSString* detail = [NSString stringWithFormat:@"%@人  %@元/%@/人",employeeInfo.number,employeeInfo.payment,[paymentUnitList objectAtIndex:employeeInfo.paymentUnit]];
        cell.detailTextLabel.text = detail;
    } else {
        cell.textLabel.text = [otherNameLists objectAtIndex:indexPath.row];
        NSArray* otherArray = [self.inputDic valueForKey:otherInfoKey];
        OtherInfo* otherInfo = [otherArray objectAtIndex:indexPath.row];//[otherDic valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        NSString* detail = otherInfo.isUseZhiming ? @"知明经验值" : [NSString stringWithFormat:@"%@元/%@",otherInfo.payment,[paymentUnitList objectAtIndex:otherInfo.paymentUnit]];
        cell.detailTextLabel.text = detail;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray* basicArray = [self.inputDic valueForKey:basicInfoKey];
        BasicInfo* basicInfo = [basicArray objectAtIndex:indexPath.row];
        if (indexPath.row == InputDataInfo) {
            BasicInfoViewController* viewController = [[BasicInfoViewController alloc] initWithNibName:@"BasicInfoViewController" bundle:nil];
            viewController.basicInfo = basicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            ValueViewController* viewController = [[ValueViewController alloc] initWithNibName:@"ValueViewController" bundle:nil];
            viewController.isText = indexPath.row == InputDataName;
            viewController.basicInfo = basicInfo;
            viewController.isParamSetting = NO;
            [self.navigationController pushViewController:viewController animated:YES];
        }

    } else if (indexPath.section == 1) {
        NSArray* employeeArray = [self.inputDic valueForKey:employeeInfoKey];
        EmployeeInfo* employeeInfo = [employeeArray objectAtIndex:indexPath.row];
        EmployeeViewController* viewController = [[EmployeeViewController alloc] initWithNibName:@"EmployeeViewController" bundle:nil];
        viewController.employeeInfo = employeeInfo;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        NSArray* otherArray = [self.inputDic valueForKey:otherInfoKey];
        OtherInfo* otherInfo = [otherArray objectAtIndex:indexPath.row];
        CostViewController* viewController = [[CostViewController alloc] initWithNibName:@"CostViewController" bundle:nil];
        viewController.otherInfo = otherInfo;
        viewController.hasZhiming = indexPath.row != InputDataRent;
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
