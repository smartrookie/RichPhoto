//
//  LoginViewController.h
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark LoginViewController

@interface LoginViewController : BootViewController

@end

/*============================================================================*/
#pragma mark -
#pragma mark LoginAccountsCell
/*============================================================================*/

@interface LoginAccountsCell : UITableViewCell

@property (assign, nonatomic, getter = isShake) BOOL shake; //抖动开关

@end

/*============================================================================*/
#pragma mark -
#pragma mark AccountCell
/*============================================================================*/

typedef enum : NSUInteger {
    AccountCellType_One,
    AccountCellType_Two,
    AccountCellType_More,
} AccountCellType;

@interface AccountCell : UITableViewCell

@property (assign, nonatomic) AccountCellType   cellType;
@property (strong, nonatomic) UIImageView       *iv_avatar;
@property (strong, nonatomic) UIButton          *btn_delete;

- (void)startShake;
- (void)stopShake;

@end