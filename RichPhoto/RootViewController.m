//
//  RootViewController.m
//  RichPhoto
//
//  Created by smartrookie on 7/26/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSArray     *dataArr;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试导航";
    
    self.tableview = ({
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate   = self;
        tableview.dataSource = self;
        tableview;
    });
    [_tableview setFrame:self.view.frame];
    [self.view addSubview:_tableview];
    
    self.dataArr = @[@"高仿登录"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            LoginViewController *loginvctrl = [[LoginViewController alloc] init];
            [self presentViewController:loginvctrl animated:NO completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
