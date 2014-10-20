//
//  ILReplyView.m
//  RichView
//
//  Created by 吴福虎 on 14-9-25.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ILReplyView.h"
#import <CoreText/CoreText.h>
#import "ILReplyTextStyle.h"


#define kSelectedFrom_Tag 4567
#define kSelectedTo_Tag 7654

#define offset_X 0
#define offset_Y 0



#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色
#define kUserName_unSelectedColor [UIColor colorWithWhite:0 alpha:0]//取消点击姓名颜色

@implementation ILReplyView
{
    NSAttributedString *attrString;//富文本字符串

    NSRange _tempFromRange;
    NSRange _tempToRange;
    
    NSUInteger selectedViewLinesF ;//From按钮所占行数
    NSUInteger selectedViewLinesT ;//To按钮所占行数
    
    BOOL isLongPressFromUser;
    BOOL isLongPressToUser;
  
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selectedViewLinesF = 0;
        selectedViewLinesT = 0;
        
        isLongPressFromUser =  NO;
        isLongPressToUser   =  NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself)];
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMyself:)];
        [self addGestureRecognizer:longPress];
        
   }
    
    return self;
}


////////////////////////////
- (void) fitFromUserName:(NSString *)fromUserName byClick:(fromNameTouch)fromTouch withLongPress:(fromNameLongTouch)fromLongTouch{
    
    _fromUserName = fromUserName;
    _fromBlock = fromTouch;
    _fromLongBlock = fromLongTouch;


}

- (void) fitToUserName:(NSString *)toUserName byClick:(toNameTouch)toTouch withLongPress:(toNameLongTouch)toLongTouch{
    
    _toUserName = toUserName;
    _toBlock = toTouch;
    _toLongBlock = toLongTouch;

}

- (void) setContentText:(NSString *)contentText{

    _contentText = contentText;
    [self setup];

}
////////////////////////////

- (void) setup{

    NSRange fromRange = NSMakeRange(0, _fromUserName.length);
    NSRange toRange = NSMakeRange(fromRange.length + 2, _toUserName.length);
    
    _tempFromRange = fromRange;
    _tempToRange = toRange;
   
//根据 fromRange 和toRange设置 string的样式
    
    attrString = [ILReplyTextStyle creatFromUserNameStrRange:fromRange andFromNameString:_fromUserName toUserNameStrRange:toRange andToNameString:_toUserName appendContent:_contentText];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);//创建CTFramesetterRef
    CGMutablePathRef path = CGPathCreateMutable();//创建path区域，ios上貌似只有矩形，mac上多一点
    
    CGRect iRect = CGRectInset(CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height ), offset_X, offset_Y);
    CGPathAddRect(path, NULL, iRect);//irect添入CGPath
    CTFrameRef workFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    [self getHeight:attrString withWorkFrame:workFrame];
    
    CFRelease(framesetter);
    CFRelease(path);
    CFRelease(workFrame);
}


#pragma mark - 根据range计算该range区间内文字的CGRect，因为可能不在同一行，所以N行的CGRect放入数组返回

- (NSMutableArray *)getSelectedCGRect:(CTFrameRef)senderFrame andClickRange:(NSRange)tempRange
{
    NSMutableArray *clickRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines(senderFrame); //获得行数数组
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins(senderFrame, CFRangeMake(0, [lines count]), origins);//每行的起始位置
    NSInteger count = [lines count];
    
    for (int i = 0; i < count; i++) { //一行行处理
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
        if (intersection.length > 0)
        {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
            
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(baselineOrigin.x + xStart + offset_X, baselineOrigin.y+offset_Y - ascent, xEnd -  xStart , ascent + descent);//所画选择之后背景的 大小 和起始坐标
            [clickRects addObject:NSStringFromCGRect(selectionRect)];
            
        }
        
    }
    

    free(origins);
    return clickRects;
    
    
}

//超出1行 处理
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location)
    {
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location + first.length)
    {
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }
    return result;
}





//自适应高度计算

- (void)getHeight:(NSAttributedString *)hasBlankStr withWorkFrame:(CTFrameRef)tempWorkFrame
{
    NSMutableArray *cellHeightRect = [NSMutableArray arrayWithCapacity:0];
    cellHeightRect = [self getSelectedCGRect:tempWorkFrame andClickRange:NSMakeRange(hasBlankStr.length - 5, 5)];
    CGRect lastRect =  CGRectFromString(cellHeightRect.lastObject);
    _cellHeight = lastRect.origin.y + lastRect.size.height;
   
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
   
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);//创建CTFramesetterRef
    CGMutablePathRef path = CGPathCreateMutable();//创建path区域，ios上貌似只有矩形，mac上多一点
    
    CGRect iRect = CGRectInset(CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height ), offset_X, offset_Y);
    CGPathAddRect(path, NULL, iRect);//irect添入CGPath
    CTFrameRef workFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
  //获得fromUserName 和toUserName的 CGRect
    
    [self drawViewFromRects:[self getSelectedCGRect:workFrame andClickRange:_tempFromRange]];
    [self drawViewToRects:[self getSelectedCGRect:workFrame andClickRange:_tempToRange]];
    
    
    CTFrameDraw(workFrame, context);//画
    
    CFRelease(workFrame);//释放
    CFRelease(path);//释放
 
}




///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - //贴上发送者的透明的view
- (void)drawViewFromRects:(NSArray *)array
{
    //用户名可能超过1行的内容 所以记录在数组里，有多少元素 就有多少view
    selectedViewLinesF = array.count;
    NSLog(@"selectedViewLinesF = %@",array);
    for (int i = 0; i < [array count]; i++) {
        
        UIView *selectedView = [[UIView alloc] init];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = [UIColor clearColor];
        selectedView.tag = kSelectedFrom_Tag + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectedViewF:)];
        tap.delegate = self;
        [selectedView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSelectedViewF:)];
        [selectedView addGestureRecognizer:longGes];

        
        
        [self addSubview:selectedView];
        
    }
    
}


#pragma mark - //贴上被发送者的透明的view
- (void)drawViewToRects:(NSArray *)array{
    
    //用户名可能超过1行的内容 所以记录在数组里，有多少元素 就有多少view
    selectedViewLinesT = array.count;
    
    for (int i = 0; i < [array count]; i++) {
        
        UIView *selectedView = [[UIView alloc] init];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = [UIColor clearColor];
        selectedView.tag = kSelectedTo_Tag + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectedViewT:)];
        tap.delegate = self;
        [selectedView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSelectedViewT:)];
        [selectedView addGestureRecognizer:longGes];
        
        
        [self addSubview:selectedView];
        
    }
    
    
}



#pragma mark - //以下全为各种点击事件

#pragma mark - //被发送者透明的view的点击事件
- (void)tapSelectedViewT:(UITapGestureRecognizer *)sender{
    
    for (int i =0; i < selectedViewLinesT; i++) {
        
        UIView *view_s = (UIView*)[self viewWithTag:kSelectedTo_Tag+i];
        view_s.backgroundColor = kUserName_SelectedColor;
        
    }
    
    _toBlock(_toUserName);
    
    //延迟0.2秒颜色消失
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (int i =0; i < selectedViewLinesT; i++) {
            
            UIView *view_s = (UIView*)[self viewWithTag:kSelectedTo_Tag+i];
            view_s.backgroundColor = kUserName_unSelectedColor;
        }
        
    });
    
}



#pragma mark - //发送者透明的view的点击事件
- (void)tapSelectedViewF:(UITapGestureRecognizer *)sender{
    
    for (int i =0; i < selectedViewLinesF; i++) {
        
        UIView *view_s = (UIView*)[self viewWithTag:kSelectedFrom_Tag+i];
        view_s.backgroundColor = kUserName_SelectedColor;
        
    }
    
    _fromBlock(_fromUserName);
    
    //延迟0.2秒颜色消失
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (int i =0; i < selectedViewLinesF; i++) {
            
            UIView *view_s = (UIView*)[self viewWithTag:kSelectedFrom_Tag+i];
            view_s.backgroundColor = kUserName_unSelectedColor;
        }
        
    });
    
}


#pragma mark - 长按 ToUserName
- (void)longPressSelectedViewT:(UIGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        for (int i =0; i < selectedViewLinesT; i++) {
            
            UIView *view_s = (UIView*)[self viewWithTag:kSelectedTo_Tag+i];
            view_s.backgroundColor = kUserName_SelectedColor;
            
        }
        isLongPressToUser = YES;
        _toLongBlock(_toUserName);
        
    }
    

}

#pragma mark - 长按 FromUserName
- (void)longPressSelectedViewF:(UIGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        for (int i =0; i < selectedViewLinesF; i++) {
            
            UIView *view_s = (UIView*)[self viewWithTag:kSelectedFrom_Tag+i];
            view_s.backgroundColor = kUserName_SelectedColor;
            
        }
        
        _fromLongBlock(_fromUserName);
        isLongPressFromUser = YES;
        
        
    }
    
 
}

#pragma mark -点击自己
- (void)tapMyself{
    
    // self.backgroundColor = [UIColor lightGrayColor]; //设置颜色仍会走drawrect 导致崩溃
    
    UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _cellHeight)];
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = kSelf_SelectedColor;
    
    [_delegate clickMySelf];
    
    //延迟0.2秒移除
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [myselfSelected removeFromSuperview];
        
    });
    
}

#pragma mark -长按自己
- (void)longPressMyself:(UIGestureRecognizer *)longGes{
    
    if (longGes.state == UIGestureRecognizerStateBegan) {
        
        UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _cellHeight)];
        myselfSelected.tag = 10101;
        [self insertSubview:myselfSelected belowSubview:self];
        myselfSelected.backgroundColor = kSelf_SelectedColor;
        
        [_delegate longClickMySelf];
        
        
        
    }
   
}

#pragma mark - 移除长按选择区域
- (void)removeSelectedView{

    if ([self viewWithTag:10101]) {
        NSLog(@"移除大背景");
        [[self viewWithTag:10101] removeFromSuperview];
    }
    
    if (isLongPressFromUser) {
        
        isLongPressFromUser = NO;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            for (int i =0; i < selectedViewLinesF; i++) {
                
                UIView *view_s = (UIView*)[self viewWithTag:kSelectedFrom_Tag+i];
                view_s.backgroundColor = kUserName_unSelectedColor;
                NSLog(@"移除FromUserName点击");
            }
            
            
        });

        
    }
    
    if (isLongPressToUser) {
        
        isLongPressToUser = NO;
        
        dispatch_time_t popTime_ = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime_, dispatch_get_main_queue(), ^(void){
            
            for (int i =0; i < selectedViewLinesT; i++) {
                
                UIView *view_s = (UIView*)[self viewWithTag:kSelectedTo_Tag+i];
                view_s.backgroundColor = kUserName_unSelectedColor;
                NSLog(@"移除ToUserName点击");
                
            }
            
            
        });
    }
  
}

@end
