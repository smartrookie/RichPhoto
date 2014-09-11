//
//  ImageFilterViewController.m
//  RichPhoto
//
//  Created by 吴福虎 on 14-9-2.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "ImageFilterViewController.h"
#import "DisplayView.h"

@interface ImageFilterViewController ()<DisplayDelegate>
{
    DisplayView *displayDetailImage;
    UIImageView *maskview;//黑色蒙板
}
@end

@implementation ImageFilterViewController



- (id)initWithImageView:(UIImage *)imageView
{
    self = [super init];
    if (self) {
        _beginImage = imageView;
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStatusBarHidden:YES];
    [self initMask];
    
    displayDetailImage.asyImageView.image = _beginImage;
    displayDetailImage.originImage = _beginImage;
    maskview.hidden = NO;
    maskview.alpha = 1.0f;
    [displayDetailImage showOnTheViewWith:_beginImage.size];
    
    [self initDownBtn];
    
}

- (void)initMask
{
    displayDetailImage = [[DisplayView alloc] initWithFrame:CGRectMake(0,0, 320, isInch4?568:480)];
    displayDetailImage.delegate_copy = self;
    
    maskview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, isInch4?568:480)];
    maskview.backgroundColor = [UIColor blackColor];
    maskview.layer.cornerRadius = 0;
    maskview.alpha = 0.7f;
    [self.view addSubview:maskview];
    maskview.hidden = YES;
    
    displayDetailImage.userInteractionEnabled = YES;
    maskview.userInteractionEnabled = YES;
    [self.view addSubview:displayDetailImage];
}

- (void)initDownBtn
{
    UIButton *downBtn = [UIButton buttonWithType:0];
   // downBtn.tag = kDownBtnTag;
    downBtn.frame = CGRectMake(260, self.view.bounds.size.height - 60, 50, 50);
    //[downBtn setBackgroundImage:[UIImage imageNamed:@"downLoadImage.png"] forState:0];
    [downBtn addTarget:self action:@selector(downloadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
    
}

- (void)downloadImage
{
   // UIImageWriteToSavedPhotosAlbum([_tempImageView image], self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    
    if(error != NULL)
    {
        msg = @"保存图片失败";
    }
    
    else
    {
        msg = @"保存图片成功";
    }
    
    
}

#pragma mark -  DisplayViewDelegate

- (void)hideTheMaskWithImage:(UIImage *)sImage
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:maskview cache:YES];
    maskview.alpha = 0.0;
    [UIView commitAnimations];
    
   // [(UIButton *)[self.view viewWithTag:kDownBtnTag] removeFromSuperview];
    
    [maskview removeFromSuperview];
    
    [displayDetailImage removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(feedImageToDetailVc:)]) {
        [_delegate feedImageToDetailVc:sImage];
    }
    [self dismissViewControllerAnimated:NO completion:NULL];
    
    
}




-(void)setStatusBarHidden:(BOOL)hidden{
    _bIsShowStatusBar = hidden;
    
    [[UIApplication sharedApplication] setStatusBarHidden:_bIsShowStatusBar withAnimation:UIStatusBarAnimationSlide];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setStatusBarHidden:NO];
    
}



@end
