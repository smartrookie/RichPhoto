//
//  DotContentStyleView.h
//  RichImageDemo
//
//  Created by Gueie on 14-7-4.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotView.h"


@protocol DotContentStyleViewDelegate;

@interface DotContentStyleView : UIView

@property (weak, nonatomic) DotView *dot;
@property (assign, nonatomic) id<DotContentStyleViewDelegate> delegate;

- (void)showStyleButton;
- (void)dismiss;

@end

@protocol DotContentStyleViewDelegate <NSObject>

- (void)cancelAddContent;

@end