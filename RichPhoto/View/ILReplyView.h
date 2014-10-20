//
//  ILReplyView.h
//  RichView
//
//  Created by 吴福虎 on 14-9-25.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fromNameTouch)(NSString *);//点击发送者姓名触发的block
typedef void(^toNameTouch)(NSString *);//点击被发送者姓名触发的block
typedef void(^fromNameLongTouch)(NSString *);//长按发送者名字
typedef void(^toNameLongTouch)(NSString *);//长按被发送者名字

@protocol ILReplyDelegate <NSObject>

- (void)clickMySelf; //点击背景触发的代理
- (void)longClickMySelf;//长按背景

@end

@interface ILReplyView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,copy  ) fromNameTouch fromBlock;
@property (nonatomic,copy  ) toNameTouch   toBlock;
@property (nonatomic,copy  ) fromNameLongTouch fromLongBlock;
@property (nonatomic,copy  ) toNameLongTouch toLongBlock;


@property (nonatomic,strong) NSString *fromUserName;
@property (nonatomic,strong) NSString *toUserName;

@property (nonatomic,strong) NSString *contentText;//文本内容（除去发送者 和被发送者以及“回复”）

@property (nonatomic,assign) NSInteger cellHeight;//该文本高度

@property (nonatomic,assign) id<ILReplyDelegate>delegate;


- (void) fitFromUserName:(NSString *)fromUserName byClick:(fromNameTouch)fromTouch withLongPress:(fromNameLongTouch)fromLongTouch;

- (void) fitToUserName:(NSString *)toUserName byClick:(toNameTouch)toTouch withLongPress:(toNameLongTouch)toLongTouch;

//此方法需在上面2个方法之后设置
- (void) setContentText:(NSString *)contentText;

//移除长按选择区域
- (void) removeSelectedView;

@end
