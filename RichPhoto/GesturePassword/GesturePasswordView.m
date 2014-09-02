//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}

@synthesize forgetButton;
@synthesize backBtn;


@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
         backBtn = [UIButton buttonWithType:0];
        [backBtn setFrame:CGRectMake(20, 20, 44, 44)];
        [backBtn setTitle:@"返回" forState:0];
        [backBtn.layer setBorderWidth:1.0];
        [backBtn addTarget:self action:@selector(backToFront:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn.layer setBorderColor:RGB(63, 107, 252, 1.0).CGColor];
        [backBtn setTitleColor:RGB(63, 107, 252, 1.0) forState:0];
        backBtn.backgroundColor = RGB(255, 255,255, 1.0);
        backBtn.titleLabel.font = Font(14);
        backBtn.layer.cornerRadius = 5;
        [self addSubview:backBtn];

        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2 - 90, 320, 320)];
       
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(40, view.frame.origin.y - 60, frame.size.width - 40 * 2, 30)];
        [state setTextColor:RGB(2, 174, 240, 1.0)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:state];
 
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-150, frame.size.height/2+200, 120, 30)];
        [forgetButton.titleLabel setFont:Font(14)];
        [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [forgetButton.layer setBorderWidth:1.0];
        forgetButton.layer.cornerRadius = 5;
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetButton];
        
    }
    
    return self;
}

//add by tiger -
- (void)backToFront:(UIButton *)sender
{
    if (gesturePasswordDelegate && [gesturePasswordDelegate respondsToSelector:@selector(backToFrontViewController)]) {
        
        [gesturePasswordDelegate backToFrontViewController];
    }
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

-(void)forget{
    
    [gesturePasswordDelegate forget];
}


@end
