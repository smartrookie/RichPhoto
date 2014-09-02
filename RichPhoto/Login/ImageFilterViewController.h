//
//  ImageFilterViewController.h
//  RichPhoto
//
//  Created by 吴福虎 on 14-9-2.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "BootViewController.h"

@protocol ImageFilterDelegate <NSObject>

- (void)feedImageToDetailVc:(UIImage *)senderImage;

@end


@interface ImageFilterViewController : BootViewController
{
    UIImage *_beginImage;
    BOOL     _bIsShowStatusBar;
}

@property (nonatomic, strong) UIImage *beginImage;
@property (nonatomic, assign) id<ImageFilterDelegate>delegate;

- (id)initWithImageView:(UIImage *)imageView;

@end
