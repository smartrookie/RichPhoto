//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

//add by tiger
typedef enum  {
    HomePageType = 1,
    SettingType = 2
} ComeFromType;

@protocol GesturePasswordVcDelegate <NSObject>

- (void)changeDetailBtnState;

@end
//end add

@interface GesturePasswordController : BootViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property (nonatomic,assign) id<GesturePasswordVcDelegate>delegate;

//add by tiger -
- (id)initWithType:(ComeFromType)type;

@end
