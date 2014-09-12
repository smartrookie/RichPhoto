//
//  DotView.h
//  RichImageDemo
//
//  Created by Gueie on 14-7-3.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DotViewDelegate;

@interface DotView : UIView


//@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;
@property (assign, nonatomic) id<DotViewDelegate> delegate;

@property (copy, nonatomic) NSString *dotText;
@property (strong, nonatomic) UILabel *textLabel;

- (void)displayDotContent:(BOOL)allowDisplay;

@end

@protocol DotViewDelegate <NSObject>

- (void)removeDot:(DotView *)dot;

@end