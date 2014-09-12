//
//  DotContentStyleView.m
//  RichImageDemo
//
//  Created by Gueie on 14-7-4.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import "DotContentStyleView.h"
#import "TextInputViewController.h"

@interface DotContentStyleView ()
{
    UIButton *textButton;
    UIButton *voiceButton;
    UIButton *photoButton;
}

@end

#define RADIUS 30.0f

@implementation DotContentStyleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [textButton setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.95f]];
        [textButton setFrame:CGRectMake(35, -60, RADIUS * 2, RADIUS * 2)];
        [textButton.layer setCornerRadius:RADIUS];
        [textButton.layer setMasksToBounds:YES];
        [textButton.layer setBorderWidth:1.0f];
        [textButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [textButton setAlpha:0];
        [textButton setTitle:@"文字" forState:UIControlStateNormal];
        [textButton addTarget:self action:@selector(addText:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:textButton];
        
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceButton setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.95f]];
        [voiceButton setFrame:CGRectMake(35 + RADIUS * 2 + 35, -60, RADIUS * 2, RADIUS * 2)];
        [voiceButton.layer setCornerRadius:RADIUS];
        [voiceButton.layer setMasksToBounds:YES];
        [voiceButton.layer setBorderWidth:1.0f];
        [voiceButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [voiceButton setAlpha:0];
        [voiceButton setTitle:@"语音" forState:UIControlStateNormal];
        [self addSubview:voiceButton];
        
        photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoButton setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.95f]];
        [photoButton setFrame:CGRectMake(35 + RADIUS * 2 + 35 + RADIUS * 2 + 35, -60, RADIUS * 2, RADIUS * 2)];
        [photoButton.layer setCornerRadius:RADIUS];
        [photoButton.layer setMasksToBounds:YES];
        [photoButton.layer setBorderWidth:1.0f];
        [photoButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [photoButton setAlpha:0];
        [photoButton setTitle:@"图片" forState:UIControlStateNormal];
        [self addSubview:photoButton];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissStyleView:)];
        [self addGestureRecognizer:singleTapGesture];
        
    }
    return self;
}

- (void)addText:(UIButton *)button
{
    TextInputViewController *tiVC = [[TextInputViewController alloc] init];
    
    [self.window.rootViewController presentViewController:tiVC
                                                 animated:YES
                                               completion:^{
                                                   [tiVC setDot:self.dot];
                                                   [tiVC.textInputView becomeFirstResponder];
                                                   [tiVC setStyleView:self];
                                               }];
}

- (void)dismissStyleView:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(cancelAddContent)]) {
        [self.delegate cancelAddContent];
    }
}

- (void)dismiss
{
    [self setAlpha:0];
    
    [textButton setFrame:CGRectMake(textButton.frame.origin.x, -60, RADIUS * 2, RADIUS * 2)];
    [voiceButton setFrame:CGRectMake(voiceButton.frame.origin.x, -60, RADIUS * 2, RADIUS * 2)];
    [photoButton setFrame:CGRectMake(photoButton.frame.origin.x, -60, RADIUS * 2, RADIUS * 2)];
}

- (void)showStyleButton
{
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [textButton setAlpha:1.0f];
                         [textButton setFrame:CGRectMake(textButton.frame.origin.x, 250, RADIUS * 2, RADIUS * 2)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.5f
                          delay:0.1f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [voiceButton setAlpha:1.0f];
                         [voiceButton setFrame:CGRectMake(voiceButton.frame.origin.x, 250, RADIUS * 2, RADIUS * 2)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.5f
                          delay:0.2f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [photoButton setAlpha:1.0f];
                         [photoButton setFrame:CGRectMake(photoButton.frame.origin.x, 250, RADIUS * 2, RADIUS * 2)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

@end
