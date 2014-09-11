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
   SepiaToneType = 2, //暖黄
    
} ImageFilterType;

@interface UIImage (ResizableImage)

+ (UIImage *)imageNamed:(NSString *)name resizableDefault:(BOOL)yes_no;

/**
 *  设置滤镜
 *
 *  @param filterType 滤镜种类选择
 *  @param beginImage 未设置之前的image
 *
 *  @return 设置完成后的image
 */
+ (UIImage *)processWithImageFilterType:(ImageFilterType)filterType usingImage:(UIImage *)beginImage;

@end
