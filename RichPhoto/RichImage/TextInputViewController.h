//
//  TextInputViewController.h
//  RichImageDemo
//
//  Created by Gueie on 14-7-15.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotView.h"
#import "DotContentStyleView.h"

//@protocol TextInputViewControllerDelegate;

@interface TextInputViewController : UIViewController

@property (strong, nonatomic) UITextView *textInputView;
//@property (assign, nonatomic) id<TextInputViewControllerDelegate> delegate;

@property (weak, nonatomic) DotView *dot;
@property (weak, nonatomic) DotContentStyleView *styleView;

@end

@protocol TextInputViewControllerDelegate <NSObject>

- (void)cancelInputText:(UITextView *)textView;
- (void)saveInputText:(UITextView *)textView;

@end