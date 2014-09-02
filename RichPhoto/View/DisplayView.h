//
//  DisplayView.h
//  ZHX
//
//  Created by 阿虎 on 14-1-8.
//  Copyright (c) 2014年 阿虎. All rights reserved.
//
/*
 小图变大图，coreanimation
 */

#import <UIKit/UIKit.h>

@protocol DisplayDelegate <NSObject>

- (void)hideTheMaskWithImage:(UIImage *)sImage;

@end

@interface DisplayView : UIScrollView<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIImageView *_asyImageView;
    UIView *backgroudView;
    BOOL   is_big;
    UIScrollView *_filterScroll;

}

@property (nonatomic,retain)UIImageView *asyImageView;
@property (nonatomic,assign)id<DisplayDelegate>delegate_copy;

/**
 *  展现
 *
 *  @param displayViewSize 图片大小
 */
- (void)showOnTheViewWith:(CGSize)displayViewSize;

/**
 *  点击消失
 */
- (void)disapper;

@end
