//
//  RP_CommonObj.m
//  RichPhoto
//
//  Created by 吴福虎 on 14-9-2.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "RP_CommonObj.h"
#import "Reachability.h"
#import "KeychainItemWrapper.h"


@implementation RP_CommonObj


+ (BOOL)checkNetStatus
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
            
        case NotReachable:
            
            DLog(@"没有网络");
            
            return NO;
            
        case ReachableViaWWAN:
            
            DLog(@"正在使用3G网络");
            
            return YES;
            
        case ReachableViaWiFi:
            
            DLog(@"正在使用wifi网络");
            
            return YES;
            
    }
    return YES;
}

+ (BOOL)checkHasGesturePassWord
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    if ([password isEqualToString:@""]) {
        
        return NO;
        
    }else{
        
        return YES;
    }

}

+ (NSString *)getGesturePassWord
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    return password;
}

+ (void)clearGesturePassWord
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];

}

+ (BOOL)checkLockisSetting
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"LockIsSetting" accessGroup:nil];
    NSString  *lockOrNot = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([lockOrNot isEqualToString:@"YES"]) {
        
        return YES;
        
    }else {
        
        return NO;
    }

}


+ (void)settingLock:(BOOL)yes_no
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"LockIsSetting" accessGroup:nil];
    if (yes_no) {
        
        [keychin setObject:@"<锁屏>" forKey:(__bridge id)kSecAttrAccount];
        [keychin setObject:@"YES" forKey:(__bridge id)kSecValueData];
        
    }else{
        
        [keychin resetKeychainItem];
    }

}


+ (UIWindow*)getWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

@end
