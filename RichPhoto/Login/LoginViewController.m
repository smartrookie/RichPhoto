//
//  LoginViewController.m
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "LoginViewController.h"
#import "DetailViewController.h"


@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    BOOL    hasNaviBar;
    BOOL    isShowExt;
}

@property (strong, nonatomic) UITableView   *tableview;
@property (strong, nonatomic) UITextField   *tf_account;
@property (strong, nonatomic) UITextField   *tf_password;
@property (strong, nonatomic) UIImageView   *iv_avatar;
@property (strong, nonatomic) UIImageView   *iv_header;
@property (strong, nonatomic) UIImageView   *iv_footer;
@property (strong, nonatomic) UIButton      *btn_more;
@property (strong, nonatomic) UIButton      *btn_login;
@property (strong, nonatomic) UIButton      *btn_newUser;
@property (strong, nonatomic) UIButton      *btn_forget;
@property (strong, nonatomic) NSArray       *countArr;
@property (strong, nonatomic) LoginAccountsCell   *tb_loginAccounts;

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
    [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+250, 320, 88)];
    [self.view addSubview:_tableview];
    
    self.btn_login = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_login setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor" resizableDefault:YES]
                          forState:UIControlStateNormal];
    [_btn_login setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press" resizableDefault:YES]
                          forState:UIControlStateHighlighted];
    [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
    [_btn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_login setTitle:NSLocalizedString(@"Sign in",@"登录") forState:UIControlStateNormal];
    [self.view addSubview:_btn_login];
    
    self.tf_account = ({
        UITextField *account = [[UITextField alloc] init];
        [account setFrame:CGRectMake(44, 2, 320-88, 40)];
        [account setTextAlignment:NSTextAlignmentCenter];
        [account setClearButtonMode:UITextFieldViewModeWhileEditing];
        [account setPlaceholder:NSLocalizedString(@"Username/Email/PhoneNum", @"账号/邮箱/手机号")];
        [account setDelegate:self];
        account;
    });
    
    self.tf_password = ({
        UITextField *password = [[UITextField alloc] init];
        [password setFrame:CGRectMake(10, 2, 320-20, 40)];
        [password setSecureTextEntry:YES];
        [password setTextAlignment:NSTextAlignmentCenter];
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
        [password setPlaceholder:NSLocalizedString(@"Password", @"密码")];
        [password setDelegate:self];
        password;
    });
    
    self.btn_more = ({
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        [more setFrame:CGRectMake(320-44, 0, 44, 44)];
        [more setImage:[UIImage imageNamed:@"login_textfield_more"] forState:UIControlStateNormal];
        [more addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        more;
    });
    
    self.iv_header = ({
        UIImageView *header = [[UIImageView alloc] init];
        [header setFrame:CGRectMake(0, 0, 320, 44)];
        [header setBackgroundColor:[UIColor whiteColor]];
        [header setUserInteractionEnabled:YES];
        [header addSubview:_btn_more];
        
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
    [_btn_newUser setTitle:NSLocalizedString(@"Sign up", @"新用户")  forState:UIControlStateNormal];
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
    isShowExt = NO;
    
    [_tableview setAlpha:0];
    [_btn_login setAlpha:0];
    [UIView animateWithDuration:0.4f delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+5, 320, 88)];
        [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
        [_tableview setAlpha:1];
        [_btn_login setAlpha:1];
    } completion:^(BOOL finished) {
        ;
    }];
    
    self.tb_loginAccounts = [[LoginAccountsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:@"loginAccounts"];
    [_tb_loginAccounts setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    return _tb_loginAccounts;
}

#pragma mark- Button Action
- (void)loginAction:(UIButton *)sender
{
    NSLog(@"login button pressed");
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    [self presentViewController:detailVc animated:YES completion:NULL];
}

- (void)moreAction:(UIButton *)sender
{
    NSLog(@"more button pressed");
    if (!isShowExt && [_countArr count] > 0) {
        [self openAnimation];
    } else {
        [self closeAnimation];
    }
}

- (void)openAnimation
{
    [self resignKeyboard];
    if (!isShowExt && [_countArr count] > 0) {
        isShowExt = YES;
        [UIView animateWithDuration:0.3f animations:^{
            [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+5, 320, 88 + 100)];
            [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
            [_btn_more setTransform:CGAffineTransformMakeRotation(M_PI)];
        }];
    }
    [self.tf_account setTextColor:[UIColor grayColor]];
    [self.tf_password setTextColor:[UIColor grayColor]];
    [self.tb_loginAccounts setShake:NO];
}

- (void)closeAnimation
{
    if (isShowExt || [_countArr count] == 0) {
        isShowExt = NO;
        [UIView animateWithDuration:0.3f animations:^{
            [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+5, 320, 88)];
            [_btn_login setFrame:CGRectMake(10, CGRectGetMaxY(_tableview.frame)+15, 300, 44)];
            [_btn_more setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
    [self.tf_account setTextColor:[UIColor blackColor]];
    [self.tf_password setTextColor:[UIColor blackColor]];
    [self.tb_loginAccounts setShake:NO];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self closeAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
    [self closeAnimation];
}

- (void)resignKeyboard
{
    [_tf_account resignFirstResponder];
    [_tf_password resignFirstResponder];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

/*================================================================================================*/
#pragma mark -
#pragma mark LoginAccountsCell
/*================================================================================================*/

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
        [tableview setShowsVerticalScrollIndicator:NO];
        [tableview setFrame:CGRectMake(0, 0, 320, 100)];
        [tableview setDelegate:self];
        [tableview setDataSource:self];
        tableview;
    });
    [self.contentView addSubview:_tableview];
    
    _accountArr = @[@"1",@"1",@"1",@"1",@"1"];
    
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
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunc4shakeAnimation:)];
        [cell.iv_avatar addGestureRecognizer:longPress];
    }
    if ([self isShake]) {
        [cell startShake];
    } else {
        [cell stopShake];
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

- (void)longPressFunc4shakeAnimation:(UILongPressGestureRecognizer *)gesture
{
    if (![self isShake]) {
        [self setShake:YES];
        [_tableview reloadData];
    }
}

@end

/*================================================================================================*/
#pragma mark -
#pragma mark AccountCell
/*================================================================================================*/

@interface AccountCell()

@end

@implementation AccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.iv_avatar = [[UIImageView alloc] init];
    [_iv_avatar setUserInteractionEnabled:YES];
    [_iv_avatar setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [_iv_avatar setFrame:CGRectMake(0, 0, 60, 60)];
    [_iv_avatar setBackgroundColor:[UIColor whiteColor]];
    [_iv_avatar.layer setBorderWidth:2];
    [_iv_avatar.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [_iv_avatar.layer setCornerRadius:4];
    [_iv_avatar setCenter:self.contentView.center];
    [self.contentView addSubview:_iv_avatar];
    
    self.btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_delete setFrame:CGRectMake(0, 0, 19, 19)];
    [_btn_delete setImage:[UIImage imageNamed:@"login_account_clear"] forState:UIControlStateNormal];
    [_btn_delete setCenter:CGPointMake(2, 2)];
    [_iv_avatar addSubview:_btn_delete];
    
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
- (void)startShake
{
//    srand([[NSDate date] timeIntervalSince1970]);
//    float rand=(float)random();
//    CFTimeInterval t=rand*0.0000000001;
//    [UIView animateWithDuration:0.1 delay:t options:0  animations:^
//     {
//         _iv_avatar.transform=CGAffineTransformMakeRotation(-0.05);
//     } completion:^(BOOL finished)
//     {
//         [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
//          {
//              _iv_avatar.transform=CGAffineTransformMakeRotation(0.05);
//          } completion:^(BOOL finished) {}];
//     }];
    float rand=(float)random();
    CFTimeInterval t=rand*0.0000000001;
    [self performSelector:@selector(addShakeAnimation) withObject:nil afterDelay:t];
}

- (void)addShakeAnimation
{
    static NSString *animationKey = @"rotationAnimation";
    CAAnimation *animation = [_iv_avatar.layer animationForKey:animationKey];
    if (animation) {
        NSLog(@"搜到保存动画");
    }
    if (![_iv_avatar.layer animationForKey:animationKey]) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:0.1f];
        rotationAnimation.duration = 0.08f;
        rotationAnimation.cumulative = NO;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.autoreverses = YES;
        [_iv_avatar.layer addAnimation:rotationAnimation forKey:animationKey];
    }
}

- (void)stopShake
{
    if ([_iv_avatar.layer animationForKey:@"rotationAnimation"]) {
        [_iv_avatar.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

@end

