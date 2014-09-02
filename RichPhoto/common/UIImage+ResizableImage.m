//
//  UIImage+ResizableImage.m
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "UIImage+ResizableImage.h"

@implementation UIImage (ResizableImage)

+ (UIImage *)imageNamed:(NSString *)name resizableDefault:(BOOL)yes_no
{
    if (yes_no) {
        UIImage *image = [UIImage imageNamed:name];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        image = [image resizableImageWithCapInsets:insets];
        return image;
    } else {
        return [UIImage imageNamed:name];
    }
}

+ (UIImage *)processWithImageFilterType:(ImageFilterType)filterType usingImage:(UIImage *)beginImage;
{
    UIImage *completeImage = nil;
    switch (filterType) {
        case MonochromeType:
            completeImage = [self processWithImageFilterType:MonochromeType usingImage:beginImage];
            break;
            
        default:
            break;
    }

    return completeImage;
}

- (UIImage *)processWithImageFilterType:(ImageFilterType)filterType usingImage:(UIImage *)beginImage
{
    DLog(@"xxx");
    return nil;
    

}


@end
