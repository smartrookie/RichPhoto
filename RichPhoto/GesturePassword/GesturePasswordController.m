//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"


#import "KeychainItemWrapper/KeychainItemWrapper.h"

@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString     * previousString;
    NSString     * password;
    ComeFromType   tempType;
}

@synthesize gesturePasswordView;

- (id)initWithType:(ComeFromType)type;
{
    self = [super init];
    if (self) {
        // Custom initialization
        tempType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    previousString = [NSString string];
//add by tiger -
    
    if ([RP_CommonObj checkHasGesturePassWord]){
        password = [RP_CommonObj getGesturePassWord];
        [self verify];
    
    }else{
        
        [self reset];
    }
//end add
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 验证手势密码
//change by tiger -

- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:VerifyType];
    [gesturePasswordView.state setHidden:NO];
    [gesturePasswordView.state setText:@"输入原先解锁图案"];
    [gesturePasswordView setGesturePasswordDelegate:self];
    if (tempType == HomePageType) {
        gesturePasswordView.backBtn.hidden = YES;
    }
    [self.view addSubview:gesturePasswordView];
}

#pragma -mark 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:ResetType];
    [gesturePasswordView.state setHidden:NO];
    [gesturePasswordView.state setText:@"绘制解锁图案"];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView setGesturePasswordDelegate:self];
    if (tempType == HomePageType) {
        gesturePasswordView.backBtn.hidden = YES;
    }
    [self.view addSubview:gesturePasswordView];
}
//end change



#pragma -mark 忘记手势密码
- (void)forget{
    //todo 
}

#pragma mark - 返回上级页面
- (void)backToFrontViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)verification:(NSString *)result{
    
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确"];
        
        //add by tiger -
        if (tempType == HomePageType) {
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
        }else{
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
                [gesturePasswordView removeFromSuperview];
                [RP_CommonObj clearGesturePassWord];
                [self reset];
            
            });
        }
        //end add

        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误，请重新输入"];
    
    //add by tiger -
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [gesturePasswordView.tentacleView enterArgin];
        
    });
    //end add

    
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            
//add by tiger -
            __weak typeof(self) weakSelf = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                
                
                if (_delegate && [_delegate respondsToSelector:@selector(changeDetailBtnState)]) {
                    [_delegate changeDetailBtnState];
                }
                
            });
//end add
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
//add by tiger -
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [gesturePasswordView.tentacleView enterArgin];
                
            });
//end add
            return NO;
        }
    }
    
}



@end
