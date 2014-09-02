//
//  RP_CommonObj.h
//  RichPhoto
//
//  Created by 吴福虎 on 14-9-2.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RP_CommonObj : NSObject
/**
 *  判断是否有网络
 *
 *  @return 返回YES 表示有网 否则无网
 */
+ (BOOL)checkNetStatus;

/**
 *  检查是否有设置手势密码
 *
 *  @return 返回YES 表示有 否则无
 */
+ (BOOL)checkHasGesturePassWord;

/**
 *  获得手势密码
 *
 *  @return 手势密码
 */
+ (NSString *)getGesturePassWord;

/**
 *  清除手势密码
 */
+ (void)clearGesturePassWord;


/**
 *  检查用户对手势密码的开关状况
 *
 *  @return 返回YES 为开了手势密码
 */
+ (BOOL)checkLockisSetting;

/**
 *  设置手势密码开关状态
 *
 *  @param yes_no 为YES 则是设置了，反之没设置
 */
+ (void)settingLock:(BOOL)yes_no;

@end
