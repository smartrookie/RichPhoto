//
//  UIImage+ResizableImage.m
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import "UIImage+ResizableImage.h"
#import <CoreImage/CIImage.h>

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
        case MonochromeType:{
            
            CIImage *ciImage = [[CIImage alloc] initWithImage:beginImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"
                                          keysAndValues:kCIInputImageKey,ciImage,kCIInputColorKey,[CIColor colorWithCGColor:[UIColor lightGrayColor].CGColor],@"inputIntensity",@1.0,nil];
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            CGImageRef cgImage = [context createCGImage:outputImage
                                               fromRect:[outputImage extent]];
            
          
            completeImage = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            return completeImage;
           
        }
        case SepiaToneType:{
            
            CIImage *ciImage = [[CIImage alloc] initWithImage:beginImage];
            CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,ciImage,@"inputIntensity", [NSNumber numberWithFloat:1.1],nil];
            
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            CGImageRef cgImage = [context createCGImage:outputImage
                                               fromRect:[outputImage extent]];
            
            
            completeImage = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            return completeImage;

        }
            break;
        default:
            break;
    }

    return completeImage;
}




@end
