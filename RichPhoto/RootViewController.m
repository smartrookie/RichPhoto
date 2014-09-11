//
//  RootViewController.m
//  RichPhoto
//
//  Created by smartrookie on 7/26/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "E_ScrollViewController.h"
#import "DetailViewController.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSArray     *dataArr;

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview setFrame:self.view.frame];
}

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
    
    self.dataArr = @[@"高仿登录",@"EReader",@"手势密码"];
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
        case 0: {   //@"高仿登录"
            LoginViewController *loginvctrl = [[LoginViewController alloc] init];
            [self presentViewController:loginvctrl animated:NO completion:nil];
        }
            break;
        case 1: {   //@"EReader"
            E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
            [self presentViewController:loginvctrl animated:NO completion:nil];
        }
            break;
        case 2: {   //@"手势密码"
            DetailViewController *detailVc = [[DetailViewController alloc] init];
            [self presentViewController:detailVc animated:YES completion:NULL];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [_tableview setFrame:self.view.frame];
    }];
}

@end
