//
//  UIImage+ResizableImage.h
//  RichPhoto
//
//  Created by smartrookie on 7/27/14.
//  Copyright (c) 2014 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  滤镜种类
 */
typedef enum  {
   MonochromeType = 1, //黑白照
    
} ImageFilterType;

@interface UIImage (ResizableImage)

+ (UIImage *)imageNamed:(NSString *)name resizableDefault:(BOOL)yes_no;

+ (UIImage *)processWithImageFilterType:(ImageFilterType)filterType usingImage:(UIImage *)beginImage;

@end
