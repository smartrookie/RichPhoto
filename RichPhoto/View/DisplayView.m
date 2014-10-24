//
//  DisplayView.m
//  ZHX
//
//  Created by 阿虎 on 14-1-8.
//  Copyright (c) 2014年 阿虎. All rights reserved.
//

#import "DisplayView.h"



#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)   // 得到屏幕高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)     // 得到屏幕宽


@implementation DisplayView
@synthesize asyImageView = _asyImageView;
@synthesize delegate_copy = _delegate_copy;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.alpha = 0.0f;
        self.delegate = self;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 0.75;
        [self setZoomScale:[self minimumZoomScale]];
        is_big = NO;
        _asyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_asyImageView];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapper)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
      
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
        _filterScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 60, 320,  50)];
        _filterScroll.backgroundColor = [UIColor clearColor];
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(0 + i *80, 0, 80, 50);
            btn.tag = 1000 + i;
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            [btn setTitle:[NSString stringWithFormat:@"滤镜%d",i + 1] forState:0];
            [btn addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventTouchUpInside];
            [_filterScroll addSubview:btn];
        }
        [[RP_CommonObj getWindow] addSubview:_filterScroll];
    
    }
    return self;
}

#pragma mark - 滤镜
- (void)changeFilter:(UIButton *)sender
{
    UIImage *newImage = nil;
    if (sender.tag == 1000) {
        //MonochromeType
        newImage = [UIImage processWithImageFilterType:MonochromeType usingImage:_originImage];
        self.asyImageView.image = newImage;
        
    }else if(sender.tag == 1001){
       //SepiaTone
        newImage = [UIImage processWithImageFilterType:SepiaToneType usingImage:_originImage];
        self.asyImageView.image = newImage;
    
    }
    
}

#pragma mark - 双击放大到最大－－3.0
- (void)changeBig:(UITapGestureRecognizer *)gesture
{
    if (!is_big) {
        
        CGFloat newscale = 1.9;
        CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gesture locationInView:gesture.view]];
    
        [self zoomToRect:zoomRect animated:YES];
        
        is_big = YES;
        
    }else{
        
        [self setZoomScale:1.0 animated:YES];
        is_big = NO;
    }
}

#pragma mark - 定点放大
- (CGRect)zoomRectForScale:(CGFloat )newscale withCenter:(CGPoint )center{
    
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = self.frame.size.height / newscale;
    zoomRect.size.width  = self.frame.size.width  / newscale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;


}

#pragma mark-- 展现
- (void)showOnTheViewWith:(CGSize)displayViewSize
{
    self.asyImageView.frame = CGRectMake(10, 0, 300 , displayViewSize.height*300/displayViewSize.width);
    
    if (displayViewSize.height*300/displayViewSize.width < self.frame.size.height) {
        self.asyImageView.frame = CGRectMake(10, (self.frame.size.height - displayViewSize.height*300/displayViewSize.width)/2 ,300 , displayViewSize.height*300/displayViewSize.width);
        self.contentSize = CGSizeMake(320, displayViewSize.height*300/displayViewSize.width + 30);
    }else{
        self.contentSize = CGSizeMake(320, displayViewSize.height*300/displayViewSize.width + 30);
    }
   
    self.contentOffset = CGPointMake(0, 0);
    
    
    self.alpha = 1.0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 0.35f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation: animation forKey: @"FadeIn"];
    
    DLog(@"==%f,,==%f",self.asyImageView.center.x,self.asyImageView.center.y);

}

#pragma mark--点击消失
- (void)disapper
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [_delegate_copy hideTheMaskWithImage:self.asyImageView.image];
    [_filterScroll removeFromSuperview];
    self.alpha = 0.0;
    [UIView commitAnimations];
}



- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    if (aScrollView == _filterScroll) {
        return;
    }
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    
    _asyImageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                 self.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == _filterScroll) {
        return nil;
    }
	return _asyImageView;
}



@end
