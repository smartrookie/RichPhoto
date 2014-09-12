//
//  RichImageViewController.m
//  RichPhoto
//
//  Created by smartrookie on 14-9-13.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "RichImageViewController.h"
#import "RichImageView.h"

@interface RichImageViewController ()

@end

@implementation RichImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RichImage";
    
    RichImageView *riv = [[RichImageView alloc] initWithFrame:self.view.bounds];
    [riv setBackgroundColor:[UIColor blackColor]];
    [riv setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/girl.jpg", [[NSBundle mainBundle] resourcePath]]]];
    [riv setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:riv];
}

@end
