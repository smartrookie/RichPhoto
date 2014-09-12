//
//  RichImageView.m
//  RichImageDemo
//
//  Created by Gueie on 14-7-3.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import "RichImageView.h"
#import "DotView.h"
#import "DotContentStyleView.h"
#import "TextInputViewController.h"

@interface RichImageView ()<UIActionSheetDelegate, DotViewDelegate, DotContentStyleViewDelegate>
{
    UITapGestureRecognizer *singleTapGesture;
    UIActionSheet *removeActionSheet;
    
    DotContentStyleView *styleView;
    DotView *currentDot;
}

@end

@implementation RichImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(singleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [singleTapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        
        styleView = [[DotContentStyleView alloc] initWithFrame:self.bounds];
        [styleView setAlpha:0];
        [styleView setDelegate:self];
        [self addSubview:styleView];
        
        removeActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除"
                                               otherButtonTitles:nil, nil];
        
        [removeActionSheet setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
//    DotView *dot = [[DotView alloc] initWithFrame:CGRectMake(point.x - 30.0f, point.y - 30.0f, 90.0f, 60.0f)];
    DotView *dot = [[DotView alloc] initWithFrame:CGRectMake(point.x - 13.0f, point.y - 13.0f, 90.0f, 26.0f)];

    NSLog(@"%.0f, %.0f, %.0f, %.0f", dot.frame.origin.x, dot.frame.origin.y, dot.frame.size.width, dot.frame.size.height);
    
    [dot setDelegate:self];
    [self addSubview:dot];

    currentDot = dot;
    
    [singleTapGesture requireGestureRecognizerToFail:dot.singleTapGesture];
    [singleTapGesture requireGestureRecognizerToFail:dot.doubleTapGesture];
    
    [self bringSubviewToFront:styleView];
    
    [self showDotContentStyle];
}

- (void)showDotContentStyle
{
    [styleView setAlpha:1.0f];
    [styleView setDot:currentDot];
    [styleView showStyleButton];
}

- (void)removeDot:(DotView *)dot
{
    [removeActionSheet showInView:self];
    
    currentDot = dot;
}

- (void)cancelAddContent
{
    [currentDot removeFromSuperview];
    
    currentDot = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [currentDot removeFromSuperview];
        
        currentDot = nil;
    }
}

@end
