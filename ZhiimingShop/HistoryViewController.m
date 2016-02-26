//
//  HistoryViewController.m
//  KaimingShop
//
//  Created by 高亚妮 on 15/12/15.
//  Copyright © 2015年 gaoyani. All rights reserved.
//

#import "HistoryViewController.h"
#import "DataInputViewController.h"
#import "AppDelegate.h"
#import "DraftTableViewCell.h"
#import "Utils.h"

@interface HistoryViewController () {
    NSArray* historyArray;
    NSArray *selIndexPaths;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    historyArray = appDelegate.historyList;
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DraftTableViewCell" bundle:nil] forCellReuseIdentifier:@"DraftTableViewCell"];
}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)rightBarButtonClick:(BOOL)isStartDelete {
    if (isStartDelete) {
        self.tableView.allowsMultipleSelectionDuringEditing=YES;
        [self.tableView setEditing:YES];
    } else {
        selIndexPaths = [self.tableView indexPathsForSelectedRows];
        if (selIndexPaths.count != 0) {
            NSString* message = [NSString stringWithFormat:@"确定删除选中的历史纪录吗"];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        } else {
            self.tableView.allowsMultipleSelectionDuringEditing=NO;
            [self.tableView setEditing:NO];
        }
    }
    
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableArray* fileInfoArray = [NSMutableArray array];
        for (NSIndexPath * indexPath in selIndexPaths) {
            FileInfo* fileInfo = [historyArray objectAtIndex:indexPath.row];
            [fileInfoArray addObject:fileInfo];
            
            
            NSFileManager* fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:[Utils getFilePath:fileInfo.fileName] error:nil];
        }
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).historyList removeObjectsInArray:fileInfoArray];
        [((AppDelegate*)[UIApplication sharedApplication].delegate) saveHistoryListFile];
        
        self.tableView.allowsMultipleSelectionDuringEditing=NO;
        [self.tableView setEditing:NO];
    }
    
    [self.tableView reloadData];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"DraftTableViewCell";
    DraftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setContent:[historyArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        FileInfo* fileInfo = [historyArray objectAtIndex:indexPath.row];
        DataInputViewController* viewController = [[DataInputViewController alloc] initWithNibName:@"DataInputViewController" bundle:nil];
        viewController.inputPageFrom = InputPageFromHistory;
        viewController.fileInfo = fileInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
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
