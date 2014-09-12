//
//  DotView.m
//  RichImageDemo
//
//  Created by Gueie on 14-7-3.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import "DotView.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATIONDURATION_HALO 2.75f
#define ANIMATIONINTERVAL_HALO 0.75f

#define ANIMATIONDURATION_POINT 0.75f
#define ANIMATIONINTERVAL_POINT 2.75f

#define RADIUS_HALO 16.0f
#define RADIUS_POINT 4.0f

typedef NS_ENUM(NSInteger, DotOrientationType) {
    DotOrientationLeft,
    DotOrientationRight
};

@interface DotView ()
{
    CALayer *pointLayer;
    CALayer *haloLayer;
    
    UIImage *bgImage;
    UIImageView *bgImageView;
    
    DotOrientationType dotOrientationType;
}

@property (strong, nonatomic) CAAnimationGroup *animationGroup_Halo;
@property (strong, nonatomic) CAAnimationGroup *animationGroup_Point;

@end

@implementation DotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //  添加手势
        [self setUserInteractionEnabled:YES];
        
        self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(singleTapDot:)];
        [self addGestureRecognizer:self.singleTapGesture];
        
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(doubleTapDot:)];
        [self.doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:self.doubleTapGesture];
        
        [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(longPressDot:)];
        [self.longPressGesture setMinimumPressDuration:1.0f];
        [self addGestureRecognizer:self.longPressGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(panDot:)];
        [self addGestureRecognizer:panGesture];
        
        bgImage = [UIImage imageNamed:@"text_bg_right"];
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 0, 50, 26)];
        [bgImageView setAlpha:0];
        [bgImageView setImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 13, 8, 4)
                                                      resizingMode:UIImageResizingModeStretch]];
        [self addSubview:bgImageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 34, 16)];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [bgImageView addSubview:self.textLabel];
        
        //  添加动效层
        haloLayer = [CALayer layer];
        [haloLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
        [haloLayer setOpacity:0];
        [haloLayer setBounds:CGRectMake(0, 0, RADIUS_HALO * 2.0f, RADIUS_HALO * 2.0f)];
        [haloLayer setCornerRadius:RADIUS_HALO];
        [haloLayer setPosition:CGPointMake(13, 13)];
        [self.layer addSublayer:haloLayer];
        
        pointLayer = [CALayer layer];
        [pointLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [pointLayer setBounds:CGRectMake(0, 0, RADIUS_POINT * 2.0f, RADIUS_POINT * 2.0f)];
        [pointLayer setCornerRadius:RADIUS_POINT];
        [pointLayer setShadowColor:[[UIColor blackColor] CGColor]];
        [pointLayer setShadowOffset:CGSizeMake(0, 0)];
        [pointLayer setShadowRadius:4.0f];
        [pointLayer setShadowOpacity:1];
        [pointLayer setPosition:CGPointMake(13, 13)];
        [self.layer addSublayer:pointLayer];
        
        [self setupHaloAnimationGroup];
        [self setupPointAnimationGroup];
        
        [pointLayer addAnimation:self.animationGroup_Point forKey:@"point"];
        
        [NSTimer scheduledTimerWithTimeInterval:0.4f
                                         target:self
                                       selector:@selector(startHaloAnimation)
                                       userInfo:nil
                                        repeats:NO];
    }
    return self;
}

- (void)setDotText:(NSString *)dotText
{
    _dotText = dotText;
    
    CGSize size = [dotText sizeWithFont:[UIFont systemFontOfSize:13.0f]
                      constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
    
    CGFloat dotTextWidth = size.width;
    
    NSLog(@"dotTextWidth = %f", dotTextWidth);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat usableWidth_Right = screenWidth - self.frame.origin.x - bgImageView.frame.origin.x - self.textLabel.frame.origin.x - 4;
    
    CGFloat usableWidth_Left = screenWidth - usableWidth_Right;

    if (dotTextWidth < usableWidth_Right) {
        dotOrientationType = DotOrientationRight;
    } else if (dotTextWidth < usableWidth_Left) {
        dotOrientationType = DotOrientationLeft;
    } else {
        if ((self.frame.origin.x + pointLayer.position.x) > screenWidth / 2.0f) {
            dotOrientationType = DotOrientationLeft;
            
            dotTextWidth = [self.singleTapGesture locationInView:self.superview].x - bgImageView.frame.origin.x - self.textLabel.frame.origin.x - 4;
        } else {
            dotOrientationType = DotOrientationRight;
            
            dotTextWidth = usableWidth_Right;
        }
    }
    
    [self resetContentViewFrame:dotText
                    orientation:dotOrientationType
                          width:dotTextWidth];
}

- (void)resetContentViewFrame:(NSString *)dotText
                  orientation:(DotOrientationType)orientationType
                        width:(CGFloat)dotTextWidth
{
    CGFloat bgWidth = 13 + 4 + dotTextWidth;
    
    NSLog(@"bgWidth = %f", bgWidth);
    
    if (orientationType == DotOrientationRight) {   //  标签在右侧
        [self setFrame:CGRectMake(self.frame.origin.x,
                                  self.frame.origin.y,
                                  bgImageView.frame.origin.x + self.textLabel.frame.origin.x + dotTextWidth + 4,
                                  bgImageView.bounds.size.height)];
        
        [bgImageView setFrame:CGRectMake(bgImageView.frame.origin.x,
                                         bgImageView.frame.origin.y,
                                         bgWidth,
                                         bgImageView.bounds.size.height)];
        
        [self.textLabel setFrame:CGRectMake(self.textLabel.frame.origin.x,
                                            self.textLabel.frame.origin.y,
                                            dotTextWidth,
                                            self.textLabel.bounds.size.height)];
    } else {    //  标签在左侧
        [self setFrame:CGRectMake(self.frame.origin.x - bgWidth + 3,        //  这里的计算有点不准，为了位置准确直接用“+3”偏移量补齐
                                  self.frame.origin.y,
                                  bgWidth + 22,
                                  self.bounds.size.height)];
        
        NSLog(@"x = %f", self.frame.origin.x);
        
        bgImage = [UIImage imageNamed:@"text_bg_left"];
        
        [bgImageView setFrame:CGRectMake(0, 0, bgWidth, 26)];
        [bgImageView setImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 4, 8, 13)
                                                      resizingMode:UIImageResizingModeStretch]];
        
        [self.textLabel setFrame:CGRectMake(4, 5, dotTextWidth, 16)];
        
        [pointLayer setPosition:CGPointMake(self.bounds.size.width - 13, 13)];
        [haloLayer setPosition:pointLayer.position];
    }
    
    [self.textLabel setText:dotText];
    
    [self displayDotContent:YES];
}

- (void)displayDotContent:(BOOL)allowDisplay
{
    if (allowDisplay) {
        [bgImageView setAlpha:0.75f];
    } else {
        [bgImageView setAlpha:0];
    }
}

- (void)singleTapDot:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"%.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)doubleTapDot:(UITapGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(removeDot:)]) {
        [self.delegate removeDot:self];
    }
}

- (void)longPressDot:(UILongPressGestureRecognizer *)recognizer
{
    
}

- (void)panDot:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.superview];
    
    [recognizer.view setCenter:point];
}

- (void)startHaloAnimation
{
    [haloLayer addAnimation:self.animationGroup_Halo forKey:@"halo"];
}

- (void)setupPointAnimationGroup
{
    self.animationGroup_Point = [CAAnimationGroup animation];
    [self.animationGroup_Point setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.animationGroup_Point setDuration:(ANIMATIONDURATION_POINT + ANIMATIONINTERVAL_POINT)];
    [self.animationGroup_Point setRepeatCount:INFINITY];
    [self.animationGroup_Point setRemovedOnCompletion:NO];
    [self.animationGroup_Point setFillMode:kCAFillModeBackwards];
    
    CAKeyframeAnimation *scaleAnimation_Point = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation_Point.duration = ANIMATIONDURATION_POINT;
    scaleAnimation_Point.values = @[@0.75, @1.25, @1.0];
    scaleAnimation_Point.keyTimes = @[@0, @0.5, @1];
    scaleAnimation_Point.removedOnCompletion = NO;
    
    NSArray *animations_Point = @[scaleAnimation_Point];
    
    self.animationGroup_Point.animations = animations_Point;
}

- (void)setupHaloAnimationGroup
{
    self.animationGroup_Halo = [CAAnimationGroup animation];
    [self.animationGroup_Halo setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.animationGroup_Halo setDuration:(ANIMATIONDURATION_HALO + ANIMATIONINTERVAL_HALO)];
    [self.animationGroup_Halo setRepeatCount:INFINITY];
    [self.animationGroup_Halo setRemovedOnCompletion:NO];
    [self.animationGroup_Halo setFillMode:kCAFillModeBackwards];
    
    CABasicAnimation *scaleAnimation_Halo = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    [scaleAnimation_Halo setFromValue:@0.0f];
    [scaleAnimation_Halo setToValue:@1.0f];
    [scaleAnimation_Halo setDuration:ANIMATIONDURATION_HALO / 2.0f];
    [scaleAnimation_Halo setRepeatCount:2];
    [scaleAnimation_Halo setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *opacityAnimation_Halo = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation_Halo setFromValue:@1.0f];
    [opacityAnimation_Halo setToValue:@0.0f];
    [opacityAnimation_Halo setDuration:ANIMATIONDURATION_HALO / 2.0f];
    [opacityAnimation_Halo setRepeatCount:2];
    [opacityAnimation_Halo setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    NSArray *animations_Halo = @[scaleAnimation_Halo, opacityAnimation_Halo];
    
    self.animationGroup_Halo.animations = animations_Halo;
}

@end
