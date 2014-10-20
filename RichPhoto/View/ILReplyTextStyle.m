//
//  ILReplyTextStyle.m
//  RichView
//
//  Created by 吴福虎 on 14/10/20.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ILReplyTextStyle.h"
#import <CoreText/CoreText.h>

#define ILTextFont  15
#define ILTextColor [UIColor blueColor]

@implementation ILReplyTextStyle

+ (NSAttributedString *)creatFromUserNameStrRange:(NSRange)fromRange
                                andFromNameString:(NSString*)fromString
                               toUserNameStrRange:(NSRange)toRange
                                  andToNameString:(NSString *)toString
                                    appendContent:(NSString *)contentString{
    
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@：%@",fromString,@"回复",toString,contentString];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"),ILTextFont, NULL);
    
    [attrStr addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[totalString length])];
    [attrStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)(ILTextColor.CGColor) range:fromRange];
    [attrStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)(ILTextColor.CGColor) range:toRange];
    
    CGFloat lineSpace = 8.0f;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(CGFloat);
    lineSpaceStyle.value=&lineSpace;
    
    CTParagraphStyleSetting settings[] = {
        
        lineSpaceStyle,
        
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(CTParagraphStyleSetting));
    
    [attrStr addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    
  //  CFRelease(helvetica);
    
    return attrStr;
    
    
    
    
}


@end
