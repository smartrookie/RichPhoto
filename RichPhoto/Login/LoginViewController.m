//
//  LoginViewController.m
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL    hasNaviBar;
    BOOL    isShowExt;
}

@property (strong, nonatomic) UITableView   *tableview;
@property (strong, nonatomic) UITextField   *tf_account;
@property (strong, nonatomic) UITextField   *tf_password;
@property (strong, nonatomic) UIImageView   *iv_avatar;
@property (strong, nonatomic) UIImageView   *iv_header;
@property (strong, nonatomic) UIImageView   *iv_footer;
@property (strong, nonatomic) UIButton      *btn_login;
@property (strong, nonatomic) UIButton      *btn_newUser;
@property (strong, nonatomic) UIButton      *btn_forget;
@property (strong, nonatomic) NSArray       *countArr;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hasNaviBar = !self.navigationController.navigationBarHidden;
    if (hasNaviBar) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:!hasNaviBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iv_avatar = [[UIImageView alloc] init];
    [_iv_avatar setFrame:CGRectMake(115, 50, 90, 90)];
    [_iv_avatar setImage:[UIImage imageNamed:@"login_avatar" resizableDefault:YES]];
    [self.view addSubview:_iv_avatar];
    
    self.tableview = ({
        UITableView *tableview = [[UITableView alloc] init];
        [tableview setDelegate:self];
        [tableview setDataSource:self];
        [tableview setBackgroundColor:[UIColor clearColor]];
        [tableview setScrollEnabled:NO];
        tableview;
    });
    [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+20, 320, 88)];
    [self.view addSubview:_tableview];
    
    self.btn_login = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_login setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor" resizableDefault:YES]
                          forState:UIControlStateNormal];
    [_btn_login setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press" resizableDefault:YES]
                          forState:UIControlStateHighlighted];
    [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
    [_btn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_btn_login];
    
    self.tf_account = ({
        UITextField *account = [[UITextField alloc] init];
        [account setFrame:CGRectMake(44, 2, 320-88, 40)];
        [account setTextAlignment:NSTextAlignmentCenter];
        [account setClearButtonMode:UITextFieldViewModeWhileEditing];
        [account setPlaceholder:@"账号/邮箱/手机号"];
        account;
    });
    
    self.tf_password = ({
        UITextField *password = [[UITextField alloc] init];
        [password setFrame:CGRectMake(10, 2, 320-20, 40)];
        [password setSecureTextEntry:YES];
        [password setTextAlignment:NSTextAlignmentCenter];
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
        [password setPlaceholder:@"密码"];
        password;
    });
    
    self.iv_header = ({
        UIImageView *header = [[UIImageView alloc] init];
        [header setFrame:CGRectMake(0, 0, 320, 44)];
        [header setBackgroundColor:[UIColor whiteColor]];
        [header setUserInteractionEnabled:YES];
        
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        [more setFrame:CGRectMake(320-44, 0, 44, 44)];
        [more setImage:[UIImage imageNamed:@"login_textfield_more"] forState:UIControlStateNormal];
        [more addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:more];
        
        UIImageView *line = [[UIImageView alloc] init];
        [line setFrame:CGRectMake(0, 43, 320, 2)];
        [line setImage:[UIImage imageNamed:@"line"]];
        [header addSubview:line];
        
        header;
    });
    [_iv_header addSubview:_tf_account];
    
    self.iv_footer = ({
        UIImageView *footer = [[UIImageView alloc] init];
        [footer setFrame:CGRectMake(0, 0, 320, 44)];
        [footer setBackgroundColor:[UIColor whiteColor]];
        [footer setUserInteractionEnabled:YES];
        
        UIImageView *line = [[UIImageView alloc] init];
        [line setFrame:CGRectMake(0, -1, 320, 2)];
        [line setImage:[UIImage imageNamed:@"line"]];
        [footer addSubview:line];
        
        footer;
    });
    [_iv_footer addSubview:_tf_password];
    
    self.btn_newUser = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_newUser setFrame:CGRectMake(235, CGRectGetHeight(self.view.frame) - 45, 70, 33)];
    [_btn_newUser setTitle:@"新用户" forState:UIControlStateNormal];
    [_btn_newUser setTitleColor:[UIColor colorWithRed:63.0f/255.0 green:107.0f/255.0 blue:252.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [_btn_newUser.layer setCornerRadius:3.0f];
    [_btn_newUser.layer setBorderWidth:1.0f];
    [_btn_newUser.layer setBorderColor:[[UIColor colorWithRed:63.0f/255.0 green:107.0f/255.0 blue:252.0f/255 alpha:1.0f] CGColor]];
    [_btn_newUser.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_newUser setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btn_newUser setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor"] forState:UIControlStateHighlighted];
    [_btn_newUser setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.view addSubview:_btn_newUser];
    
    _countArr = @[@"Lucy",@"Lilei",@"sam",@"Hanmeimei"];
}

#pragma mark- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _iv_header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _iv_footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LoginAccountsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

#pragma mark- Button Action
- (void)loginAction:(UIButton *)sender
{
    NSLog(@"login button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreAction:(UIButton *)sender
{
    NSLog(@"more button pressed");
    isShowExt = !isShowExt;
    if (isShowExt && [_countArr count] > 0) {
        [UIView animateWithDuration:0.3f animations:^{
            [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+20, 320, 88 + 100)];
            [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
            [sender setTransform:CGAffineTransformMakeRotation(M_PI)];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+20, 320, 88)];
            [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
            [sender setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

- (void)resignKeyboard
{
    [_tf_account resignFirstResponder];
    [_tf_password resignFirstResponder];
}

@end

/*============================================================================*/
#pragma mark -
#pragma mark LoginAccountsCell
/*============================================================================*/

@interface LoginAccountsCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSArray     *accountArr;

@end

@implementation LoginAccountsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.tableview = ({
        UITableView *tableview = [[UITableView alloc] init];
        [tableview setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableview setFrame:CGRectMake(0, 0, 320, 100)];
        [tableview setDelegate:self];
        [tableview setDataSource:self];
        tableview;
    });
    [self.contentView addSubview:_tableview];
    
    _accountArr = @[@"1"];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accountArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_accountArr count] == 1) {
        return 320;
    } else if ([_accountArr count] == 2) {
        return 160;
    } else {
        return 107;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([_accountArr count] == 1) {
        cell.cellType = AccountCellType_One;
    } else if ([_accountArr count] == 2) {
        cell.cellType = AccountCellType_Two;
    } else {
        cell.cellType = AccountCellType_More;
    }
    
    return cell;
}

@end

/*============================================================================*/
#pragma mark -
#pragma mark AccountCell
/*============================================================================*/

@interface AccountCell()

@property (strong, nonatomic) UIImageView       *iv_avatar;

@end

@implementation AccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.iv_avatar = [[UIImageView alloc] init];
    [self.iv_avatar setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [_iv_avatar setFrame:CGRectMake(0, 0, 60, 60)];
    [_iv_avatar setBackgroundColor:[UIColor whiteColor]];
    [_iv_avatar.layer setBorderWidth:2];
    [_iv_avatar.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [_iv_avatar.layer setCornerRadius:4];
    [_iv_avatar setCenter:self.contentView.center];
    [self.contentView addSubview:_iv_avatar];
    
    return self;
}

- (void)setCellType:(AccountCellType)cellType
{
    _cellType = cellType;
    switch (cellType) {
        case AccountCellType_One:{
            [_iv_avatar setCenter:CGPointMake(50, 160)];
        }
            break;
        case AccountCellType_Two:{
            [_iv_avatar setCenter:CGPointMake(50, 80)];
        }
            break;
        case AccountCellType_More:{
            [_iv_avatar setCenter:CGPointMake(50, 53.6f)];
        }
            break;
        default:
            break;
    }
}

@end

